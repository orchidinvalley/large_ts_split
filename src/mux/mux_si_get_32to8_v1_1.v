`timescale 1ns / 1ps
//+FHEADER//////////////////////////////////////////////////////////////////////
// 版权所有者：山东泰信电子股份有限公司 
// Copyright 2014. All Rights Reserved.
// 保密级别：  绝密，本代码绝对不能外传
//------------------------------------------------------------------------------
// 文件名:     mux_si_get_32to8.v
// 设计部门:   FPGA部门
// 原始作者：  潘瑞芬
// 联系方式：  电子邮件: panrf@taixin.cn
//------------------------------------------------------------------------------
// 版本升级历史：
// 版本生效日期： 
// 1.0 2015-03-02  潘瑞芬  第1版  
// 1.1 2015-04-14  PanRuifen NO.2 将输入端口改为33位，配合sdt表crc错误进行优化修改
//------------------------------------------------------------------------------
// 关键字 :    32bit
//------------------------------------------------------------------------------
// 模块功能:   搜表模块，输入的ts流位宽是33bit，输入的命令位宽是8bit,
//             32位搜表，上传section
//             参考的是之前8bit位宽的代码，以240t-80G的协议为准
//------------------------------------------------------------------------------
// 参数文件名：  no
//------------------------------------------------------------------------------
// 复位策略:i_reset
// 时钟域 : i_clk 
// 关键时序: N/A
// 是否需要实例引用别的模块 : Yes
// 可综合否 : Yes 
//
//-FHEADER//////////////////////////////////////////////////////////////////////
module mux_si_get_32to8_v1_1(
    i_clk,   //156.25Mhz
    i_reset,
    
    iv_ts,   //1B光口号、4B ip和2B port分别各占32bits，低位有效，高位补0凑足32bits，后面跟着0x47开头的流
    i_ts_en,             
    iv_con,  //6B命令头(command_ctrl模块中去掉了2B的命令头)
    i_con_en,//+ 1B光口序号 + 4B ip + 2B port + 2B pid + 1B Table id + 1B Section_index + 1B overtime
    
    ov_si,   //上传section
    o_si_en
    );
////////////////////////////////////////////////////////////////////////////////
    parameter	ONE_SECOND_CNT = 28'h9502F90;
    parameter	TIME_SET_INIT  = 10;
    
////////////////////////////////////////////////////////////////////////////////
    input  i_clk;
    input  i_reset;
    
    input  [32:0] iv_ts;
    input  i_ts_en;
    input  [7:0]  iv_con;
    input  i_con_en;
    
    output [7:0]  ov_si;
    output o_si_en;
    
    reg    [7:0]  ov_si;
    reg    o_si_en;
    
////////////////////////////////////////////////////////////////////////////////    
    //命令细则请参考240t-80g协议中的命令细则
    reg    [4:0]  con_cnt;
    reg    [15:0] reply_head1; //命令头中的1B命令序号+1B是否回复
//    reg    [31:0] reply_head2; //2B当前包序号+2B包总个数
    reg    [7:0]  con_sfp_num; //1B光口序号
    reg    [31:0] con_ip;      //4B ip
    reg    [15:0] con_port;    //2B port  
    reg    [12:0] con_pid;     //13bit的pid
    reg    [7:0]  con_table_id;//1B的Table id
    reg    [7:0]  con_sec_num; //1B的Section_index
    reg    [7:0]  con_over_time;//1B的overtime
    
////////////////////////////////////////   
    reg    ts_en_r1;
    reg    [31:0] ts_r1;
    reg    wr_en;

    reg    [1:0] fifo_state;
    reg    [1:0] fifo_nxt_state;
    
    parameter FIFO_IDLE = 2'b00,
              FIFO_IP_CHECK = 2'b01,
              FIFO_PORT_CHECK = 2'b10,
              FIFO_WR = 2'b11;
   
////////////////////////////////////////
    wire   rd_en;
    wire   empty;
    
    wire   [7:0] fifo_dout;//过滤掉最后4个字节的ts流
    reg    fifo_dout_en;

////////////////////////////////////////
    reg		si_get_en;
    reg		[27:0] second_cnt;
	reg		[7:0] second_num;
	reg		null_en;
	
    reg     [11:0] section_len;//eit表可能比较长
	reg		[1:0] head_cnt;
	reg     [2:0] nop_cnt;
	reg		[11:0] rd_len;
	reg		nxt_en;
	reg		[7:0] wait_cnt;
	reg		[7:0] wait_len;
	reg		[7:0] si_cnt;
	reg		[3:0] continue_cnt;
	reg		section_start_en;
	
////////////////////////////////////////
    reg		[7:0] si_ram_din;
    reg     si_ram_wr;
    reg		[11:0] si_ram_addra;
    reg		[11:0] si_ram_addrb;
    wire	[7:0] si_ram_dout;
    reg	    over_en;

////////////////////搜表状态机////////////////////
	reg		[3:0] si_state;
	reg		[3:0] nxt_state;
	
	parameter	IDLE			= 4'd0,
				PID1_CHECK		= 4'd1,
				PID2_CHECK		= 4'd2,
				CCNT_CK			= 4'd3,
				ADAP_JUDGE		= 4'd4,
				ADAP_LEN		= 4'd5,
				ADAP_WAIT		= 4'd6,
				POINT_LEN		= 4'd7,
				POINT_WAIT		= 4'd8,
				TABLEID_CK		= 4'd9,
				SI_WRITE		= 4'd10,
				SI_WAIT			= 4'd11,
				SI_SEND			= 4'd12;

//-----------------RD_STATE-------------------
	reg		[2:0] rd_state;
	reg		[2:0] nxt_rstate;		
	
	parameter	RD_IDLE  = 3'd0,
				RD_HEAD1 = 3'd1,
				RD_HEAD2 = 3'd2,
				RD_DATA  = 3'd3,
				RD_NOP   = 3'd4,
				RD_NULL  = 3'd5;
	
	//添加udp包长度判断			
    parameter   UDP_SEC1 = 1450;
    parameter   UDP_SEC2 = 2490;
				
////////////////////////////////////////////////////////////////////////////////
//处理配置命令
    always @ (posedge i_clk)
    begin
    	if(i_reset)
    		con_cnt <= 5'd0;
    	else if(i_con_en)
    		con_cnt <= con_cnt + 5'd1;
    	else
    		con_cnt <= 5'd0;   		
    end
    
    
    //命令头中的1B命令序号+1B是否回复
    always @ (posedge i_clk)
    begin
    	if(i_reset)
    		reply_head1 <= 16'b0;
    	else if(i_con_en && con_cnt == 5'd0)
    		reply_head1[15:8] <= iv_con;
    	else if(con_cnt == 5'd1)
    		reply_head1[7:0] <= iv_con;
    	else
    		reply_head1 <= reply_head1;
    end
    
/*    
    //2B当前包序号+2B包总个数
    always @ (posedge i_clk)
    begin
    	if(i_reset)
    		reply_head2 <= 32'b0;
    	else if(con_cnt == 5'd2)
    		reply_head2[31:24] <= iv_con;
    	else if(con_cnt == 5'd3)
    		reply_head2[23:16] <= iv_con;
    	else if(con_cnt == 5'd4)
    		reply_head2[15:8] <= iv_con;
    	else if(con_cnt == 5'd5)
    		reply_head2[7:0] <= iv_con;
    	else
    		reply_head2 <= reply_head2;
    end
*/    
    
    //1B 光口序号
    always @ (posedge i_clk)
    begin
    	if(i_reset)
    		con_sfp_num <= 8'b0;
    	else if(con_cnt == 5'd6)
    		con_sfp_num <= iv_con;
    	else
    		con_sfp_num <= con_sfp_num;
    end
    
    
    //4B ip
    always @ (posedge i_clk)
    begin
    	if(i_reset)
    		con_ip <= 32'b0;
    	else if(con_cnt == 5'd7)
    		con_ip[31:24] <= iv_con;
    	else if(con_cnt == 5'd8)
    		con_ip[23:16] <= iv_con;
    	else if(con_cnt == 5'd9)
    		con_ip[15:8] <= iv_con;
    	else if(con_cnt == 5'd10)
    		con_ip[7:0] <= iv_con;
    	else
    		con_ip <= con_ip;
    end
    
    //2B port
    always @ (posedge i_clk)
    begin
    	if(i_reset)
    		con_port <= 16'b0;
    	else if(con_cnt == 5'd11)
    		con_port[15:8] <= iv_con;
    	else if(con_cnt == 5'd12)
    		con_port[7:0] <= iv_con;
    	else
    		con_port <= con_port;
    end
        
    //13bit的pid
    always @ (posedge i_clk)
    begin
    	if(i_reset)
    		con_pid <= 13'b0;
    	else if(con_cnt == 5'd13)
    		con_pid[12:8] <= iv_con[4:0];
    	else if(con_cnt == 5'd14)
    		con_pid[7:0] <= iv_con;
    	else
    		con_pid <= con_pid;
    end
    
    //1B table id
    always @ (posedge i_clk)
    begin
    	if(i_reset)
    		con_table_id <= 8'b0;
    	else if(con_cnt == 5'd15)
    		con_table_id <= iv_con;
    	else
    		con_table_id <= con_table_id;
    end
    
    
    //1B ssection_index
    always @ (posedge i_clk)
    begin
    	if(i_reset)
    		con_sec_num <= 8'b0;
    	else if(con_cnt == 5'd16)
    		con_sec_num <= iv_con;
    	else
    		con_sec_num <= con_sec_num;
    end
    
    
    //1B overtime
    always @ (posedge i_clk)
    begin
    	if(i_reset)
    		con_over_time <= TIME_SET_INIT;
    	else if(con_cnt == 5'd17)
    		con_over_time <= iv_con;
    	else
    		con_over_time <= con_over_time;
    end
        
////////////////////////////////////////////////////////////////////////////////
//format of this ts
//the first period: the number of the sfp
//the second perios: ip --- 4Bytes
//the third period: port --- 2Bytes 
//ts stream:from the fourth period, 188Bytes / 4Bytes = 47
//将ts流送入fifo，转成8bit+1bit标志位送出来后，送给后面的搜表状态机

    always @ (posedge i_clk)
    begin
    	ts_en_r1 <= i_ts_en;
    	ts_r1 <= iv_ts[31:0];
    end
    
    always @ (posedge i_clk)
    begin
        if(i_reset)
            fifo_state <= FIFO_IDLE;
        else
            fifo_state <= fifo_nxt_state;
    end
    
    always @ (fifo_state or i_ts_en or ts_en_r1 or con_sfp_num or iv_ts or con_ip or con_port)
    begin
        case(fifo_state)
        	FIFO_IDLE:
        	begin
        	    if(i_ts_en && (!ts_en_r1) && con_sfp_num == iv_ts[7:0] && iv_ts[32] == 1'b1)
        	        fifo_nxt_state = FIFO_IP_CHECK;
        	    else
        	        fifo_nxt_state = FIFO_IDLE;
        	end
        	
        	FIFO_IP_CHECK:
        	begin
        	    if(con_ip == iv_ts)
        	        fifo_nxt_state = FIFO_PORT_CHECK;
        	    else
        	        fifo_nxt_state = FIFO_IDLE;
        	end
        	
        	FIFO_PORT_CHECK:
        	begin
        	    if(con_port == iv_ts[15:0])
        	        fifo_nxt_state = FIFO_WR;
        	    else
        	        fifo_nxt_state = FIFO_IDLE;
        	end
        	
        	FIFO_WR:
        	begin        	    
        	    fifo_nxt_state = FIFO_IDLE;
        	end
        	
        	default: fifo_nxt_state = FIFO_IDLE;
        endcase
    end

    always @ (posedge i_clk)
    begin
        if(fifo_state == FIFO_WR)
            wr_en <= 1'b1;
        else if(!i_ts_en)
            wr_en <= 1'b0;
        else
            wr_en <= wr_en;
    end

    //write:4Bytes x (1+1+1+47=50), read:1Bytes x 200
    fifo_32bit_8bit     fifo_32bit_8bit_uut 
    (
        .rst            (i_reset), // input rst
        .wr_clk         (i_clk), // input wr_clk
        .rd_clk         (i_clk), // input rd_clk
        .din            (ts_r1), // input [31 : 0] din
        .wr_en          (wr_en), // input wr_en
        
        .rd_en          (rd_en), // input rd_en
        .dout           (fifo_dout), // output [7 : 0] dout
        .full           (), // output full
        .empty          (empty) // output empty
    );
    
    assign rd_en = (!empty) && (si_cnt != 8'd187);
    
    always @ (posedge i_clk)
    begin
        fifo_dout_en <= rd_en;
    end
    
    always @ (posedge i_clk)
    begin
        if(i_reset)
            si_cnt <= 8'b0;
        else if(fifo_dout_en)
            begin
                if(si_cnt == 8'd187)
                    si_cnt <= 8'd0;
                else
                    si_cnt <= si_cnt + 8'd1;
            end
        else
            si_cnt <= 8'd0;
    end
    
////////////////////////////////////////////////////////////////////////////////    
    always @ (posedge i_clk)
    begin
    	if(i_reset)
    		si_get_en	<= 1'b0;
    	else if(con_cnt == 5'd16)
    		si_get_en	<= 1'b1;
    	else if(si_state == SI_SEND || over_en)
    		si_get_en	<= 1'b0;
    	else
    		si_get_en	<= si_get_en;
    end

///////////////////time_setting////////////////
    always @ (posedge i_clk)
    begin
    	if(si_get_en)
    		begin
    			if(second_cnt == ONE_SECOND_CNT)//1s
    				second_cnt <= 28'd0;
    			else
    				second_cnt <= second_cnt + 28'd1;
   			end
   		else
   			second_cnt <= 28'd0;    
    end
    
    always @ (posedge i_clk)
    begin
    	if(si_get_en)
    		begin
    			if(second_cnt == ONE_SECOND_CNT)
    				second_num <= second_num  + 8'd1;
    			else
    				second_num <= second_num ;
    		end
    	else
    		second_num <= 8'd0;
    end
    
    always @ (posedge i_clk)
    begin
    	if((second_num == con_over_time) && si_get_en)
    		over_en <= 1'b1;
    	else
    		over_en <= 1'b0;
    end
    
    always @ (posedge i_clk)
    begin
    	if(i_reset)
    		null_en <= 1'b0;
    	else if(over_en)
    		null_en <= 1'b1;
    	else if(rd_state == RD_NULL)
    		null_en <= 1'b0;
    	else
    		null_en <= null_en;
    end
	
//----------------搜表状态机-------------
	always @ (posedge i_clk)
	begin
		if(i_reset)
			si_state <= IDLE;
		else if(i_con_en)
			si_state <= IDLE;
		else if(over_en)
			si_state <= IDLE;
		else
			si_state <= nxt_state;
	end
	
	always @(si_state or fifo_dout_en or si_cnt or si_get_en or fifo_dout or con_pid or con_table_id or con_sec_num 
	         or wait_cnt or wait_len or nxt_en or si_ram_addra or section_len or continue_cnt or section_start_en)
	begin
		case(si_state)
			IDLE:
			begin
			    if(fifo_dout_en == 1'b1 && si_cnt == 8'd0 && si_get_en == 1 && fifo_dout == 8'h47)
					nxt_state = PID1_CHECK;
				else
					nxt_state = IDLE;
			end		
						
			PID1_CHECK: 	
			begin
    			if(fifo_dout[4:0] == con_pid[12:8])	
    				nxt_state = PID2_CHECK;	
    			else if(nxt_en)
					nxt_state = SI_WAIT;
				else
    				nxt_state = IDLE;
    		end
    		
    		PID2_CHECK:	
    		begin
				if(fifo_dout == con_pid[7:0])
					begin
						if(section_start_en)
							nxt_state = ADAP_JUDGE;
						else if(nxt_en)
							nxt_state = CCNT_CK;
						else
							nxt_state = IDLE;
					end
				else if(nxt_en)
					nxt_state = SI_WAIT;
				else
					nxt_state = IDLE;
			end
			
			CCNT_CK:
			begin
				if(continue_cnt == fifo_dout[3:0])
					nxt_state = SI_WRITE;
				else
					nxt_state = SI_WAIT;
			end
			
			ADAP_JUDGE:	
			begin
				if(fifo_dout[5:4] == 2'b01)
    				nxt_state = POINT_LEN;
    			else if(fifo_dout[5:4] == 2'b11)
    				nxt_state = ADAP_LEN;
    			else if(fifo_dout[5:4] == 2'b10)
    				nxt_state = SI_WAIT;
    			else
    				nxt_state = IDLE;
			end
			
			ADAP_LEN:	
			begin
				if(fifo_dout == 0)
					nxt_state = POINT_LEN;
				else
					nxt_state = ADAP_WAIT;
			end
			
			ADAP_WAIT:	
			begin
				if(wait_cnt == wait_len)
					nxt_state = POINT_LEN;
				else
					nxt_state = ADAP_WAIT;
			end
			
			POINT_LEN:	
			begin
				if(fifo_dout == 0)
					nxt_state = TABLEID_CK;
				else
					nxt_state = POINT_WAIT;
			end
			
			POINT_WAIT:	
			begin
				if(wait_cnt == wait_len)
					nxt_state = TABLEID_CK;
				else
					nxt_state = POINT_WAIT;
			end	 
			
			TABLEID_CK:	
			begin
				if(fifo_dout == con_table_id)
    				nxt_state = SI_WRITE;
    			else
    				nxt_state = IDLE;
			end
			
			SI_WRITE:	
			begin
				if(si_ram_addra == 5 && fifo_dout != con_sec_num)//==5
    				nxt_state = IDLE;
    			else if(si_ram_addra == section_len && si_ram_addra > 3)//section全部写完
					nxt_state = SI_SEND;
				else if(fifo_dout_en)//正在写section
					nxt_state = SI_WRITE;
				else
					nxt_state = SI_WAIT;
			end
			
			SI_WAIT:	
			begin
				if(fifo_dout_en == 1'b1 && si_cnt == 8'd0 && fifo_dout == 8'h47)
					nxt_state = PID1_CHECK;
				else
					nxt_state = SI_WAIT;
			end
			
			SI_SEND:	
			begin
				nxt_state = IDLE;
			end
			
			default:
			begin
				nxt_state = IDLE;			
			end
		endcase
	end
	
////////////////////////////////////////
    always @ (posedge i_clk)
	begin
		if(si_state == IDLE)
			nxt_en <= 0;
		else if(si_state == PID2_CHECK && fifo_dout == con_pid[7:0] && section_start_en)
			nxt_en <= 0;
		else if(si_state == SI_WAIT)
			nxt_en <= 1;
		else
			nxt_en <= nxt_en;
	end  
	
	//---------------wait_cnt and len--------------------------------
	always @ (posedge i_clk)
	begin
		if(si_state	== ADAP_LEN || si_state	== POINT_LEN)	
			wait_cnt <= 8'd1;	
		else if(si_state ==	ADAP_WAIT || si_state == POINT_WAIT)	
			wait_cnt <= wait_cnt + 8'd1;
		else
			wait_cnt <= 8'd0;
	end
	
	always @ (posedge i_clk)
	begin
		if(si_state	== IDLE)
			wait_len <= 0;
		else if(si_state == ADAP_LEN || si_state == POINT_LEN)	
			wait_len <= fifo_dout;
		else
			wait_len <= wait_len;
	end
	
//---------------Continue_cnt process--------------------------------
	always @ (posedge i_clk)
	begin
		if(si_state	== PID1_CHECK && fifo_dout[6] == 1'b1)
			section_start_en <= 1'b1;
		else
			section_start_en <= 1'b0;
	end
	
	always @ (posedge i_clk)
	begin
		if(si_state	== IDLE)
			continue_cnt <= 4'd0;
		else if(si_state == ADAP_JUDGE)
			continue_cnt <= fifo_dout[3:0];
		else if(si_state == PID2_CHECK && (fifo_dout == con_pid[7:0]) && nxt_en == 1)	
			continue_cnt <= continue_cnt + 4'd1;
		else
			continue_cnt <= continue_cnt;
	end
    
//-----------------------RAM_writting---------------------------
	always @ (posedge i_clk)
	begin
		si_ram_din <= fifo_dout ;		
	end
	
	always @ (posedge i_clk)
	begin
		if(si_state	 == TABLEID_CK || si_state == SI_WRITE)
			si_ram_wr <= fifo_dout_en ;
		else
			si_ram_wr <= 1'b0;
	end
	
	always @ (posedge i_clk)
	begin
		if(si_state	 == TABLEID_CK)	
			si_ram_addra <= 12'b0;
		else if(si_ram_wr)
			si_ram_addra <= si_ram_addra + 12'b1;
		else
			si_ram_addra <= si_ram_addra ;		
	end

	always @ (posedge i_clk)
	begin
		if(i_reset)
			section_len <= 12'd0;
		else if(si_ram_addra == 12'd1)
			section_len[11:8] <= si_ram_din[3:0];
//			section_len[9:8] <= si_ram_din[1:0];
		else if(si_ram_addra == 12'd2)
			section_len[7:0] <= si_ram_din;
		else if(si_ram_addra == 12'd3)
			section_len <= section_len + 11'd3;
		else
			section_len <= section_len ;
	end 
	
//-----------------------RAM_reading---------------------------    
    always @ (posedge i_clk)
	begin
		if(si_state == SI_SEND)
			rd_len <= section_len;
		else if(rd_state == RD_IDLE)	
			rd_len <= 12'd0;
		else
			rd_len <= rd_len;
	end
    
	always @ (posedge i_clk)
	begin
		if(i_reset)
			rd_state <= RD_IDLE;
		else
			rd_state <= nxt_rstate;
	end
	
	always @ (rd_state or null_en or si_state or head_cnt or nop_cnt or si_ram_addrb or rd_len)
	begin
		case(rd_state)
			RD_IDLE:	
			begin
				if(null_en || (si_state == SI_SEND))
					nxt_rstate = RD_HEAD1;
				else
					nxt_rstate = RD_IDLE;
			end
			
			RD_HEAD1:	
			begin
				if(head_cnt == 2'd3)
					nxt_rstate = RD_HEAD2;
				else
					nxt_rstate = RD_HEAD1;	
			end
			
			RD_HEAD2:
			begin
				if(head_cnt == 2'd3)
					begin
						if(null_en)
							nxt_rstate = RD_NULL;
						else
							nxt_rstate = RD_DATA;
					end
				else
					nxt_rstate = RD_HEAD2;
			end
			
			RD_DATA:	
			begin
				if(si_ram_addrb == rd_len)	
					nxt_rstate = RD_IDLE;
				else if(si_ram_addrb == UDP_SEC1 || si_ram_addrb == UDP_SEC2)
					nxt_rstate = RD_NOP;
				else
					nxt_rstate = RD_DATA;
			end
			
			RD_NOP://假如表的长度大于一个udp包，则分开发送，中间加间隔
			begin
				if(nop_cnt == 3'd7)
					nxt_rstate = RD_HEAD1;
				else
					nxt_rstate = RD_NOP;
			end
			
			RD_NULL:	
			begin
				if(head_cnt == 2'd3)
					nxt_rstate = RD_IDLE;
				else
					nxt_rstate = RD_NULL;
			end
			
			default:	
			begin
				nxt_rstate = RD_IDLE;
			end
		endcase
	end

	always @ (posedge i_clk)
    begin
    	if(rd_state == RD_HEAD1 || rd_state == RD_HEAD2 || rd_state == RD_NULL)
    		head_cnt <= head_cnt + 2'd1;
    	else
    		head_cnt <= 2'd0;
    end
    
    always @ (posedge i_clk)
    begin
    	if(rd_state == RD_NOP)
    		nop_cnt <= nop_cnt + 3'd1;
    	else
    		nop_cnt <= 3'd0;
    end
	
	always @ (posedge i_clk)
    begin
    	case(rd_state)
    		RD_HEAD1:	
    		begin
				case(head_cnt)
	            2'd0: ov_si <= 8'h04;
	            2'd1: ov_si <= 8'h01;
	            2'd2: ov_si <= reply_head1[15:8];
	            2'd3: ov_si <= reply_head1[7:0];
        		endcase
			end
			
			RD_HEAD2://考虑udp包长度的问题	
			begin
				case(head_cnt)
	            2'd0: ov_si <= 8'h00;//reply_head2[31:24];
	            2'd1:
	            begin
	            	if(si_ram_addrb < UDP_SEC1)
	            		ov_si <= 8'd1;
	            	else if(si_ram_addrb > UDP_SEC2)
	            		ov_si <= 8'd3;
	            	else
	            		ov_si <= 8'd2;
	            end
	            2'd2: ov_si <= 8'h00;
	            2'd3:
	            begin
	            	if(rd_len <= UDP_SEC1)
	            		ov_si <= 8'd1;
	            	else if(rd_len > UDP_SEC2)
	            		ov_si <= 8'd3;
	            	else
	            		ov_si <= 8'd2;
	            end
        		endcase
			end
			
			RD_DATA:	
			begin
				ov_si <= si_ram_dout;
			end			
			
			RD_NULL:	
			begin
				ov_si <= 8'hff;
			end
			
			default:
			    ov_si <= 8'h0;
        endcase
    end
	
	always @ (posedge i_clk)
	begin
		if(rd_state == RD_IDLE)
			si_ram_addrb <= 12'd0;
		else if(rd_state == RD_NULL)
			si_ram_addrb <= 12'd0;
		else if(rd_state == RD_HEAD2)
			begin
				if(head_cnt == 2'd3)
					si_ram_addrb <= si_ram_addrb + 12'd1;
				else
					si_ram_addrb <= si_ram_addrb;
			end
		else if(rd_state == RD_DATA)
			si_ram_addrb <= si_ram_addrb + 12'd1;
		else
			si_ram_addrb <= si_ram_addrb;
	end
	
	always @ (posedge i_clk)
	begin
		if(rd_state == RD_IDLE || rd_state == RD_NOP)
			o_si_en <= 1'b0;
		else
			o_si_en <= 1'b1;
	end

	si_ram_get       si_ram_get_uut //8x4096
	(
	    .clka        (i_clk),
	    .wea         (si_ram_wr),
	    .addra       (si_ram_addra),
	    .dina        (si_ram_din),
	    
	    .clkb        (i_clk),
	    .addrb       (si_ram_addrb),
	    .doutb       (si_ram_dout)
	); 		
endmodule
