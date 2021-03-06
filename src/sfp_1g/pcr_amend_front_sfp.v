`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:59:18 02/05/2010 
// Design Name: 
// Module Name:    pcr_amend_front 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
// 
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module pcr_amend_front_sfp
(
    clk,
    rst,
    pcr_din,
    pcr_din_en,
    
    good_frame_in,
    bad_frame_in ,
        
    pcr_base_cnt,  
    pcr_ext_cnt,    

    pcr_dout,
    pcr_dout_en,
    good_frame_out,
    bad_frame_out  
//    test_flag 
) ;

//------------------------------------------------------------------------------
    
    input            clk ;
    input            rst ;
    input  [7:0]   pcr_din;
    input            pcr_din_en ;
    input	       good_frame_in;
    input	       bad_frame_in ;
        
    input  [32:0] pcr_base_cnt ;
    input  [8:0]   pcr_ext_cnt ;
    
    output          pcr_dout_en;
    output [7:0]  pcr_dout;
    output		good_frame_out;
    output		bad_frame_out ;
//    output		test_flag	;
    
    reg		pcr_dout_en;
    reg     [7:0]   pcr_dout;
    reg		good_frame_out;
    reg		bad_frame_out ;
    
    
    always@(posedge clk)begin
    	pcr_dout	<=	pcr_din;
    	pcr_dout_en	<=	pcr_din_en;
    	good_frame_out	<=	good_frame_in;
    	bad_frame_out	<=	bad_frame_in;
    end

//------------------------------------------------------------------------------
//
//    reg		[47:0]	data_in_r;
//    reg		[5:0]	pcr_din_dvalid_r;
//    reg		[5:0]	good_frame_r;
//    reg		[5:0]	bad_frame_r;
//   
//    reg		[32:0]	pcr_base_cnt_r;
//    reg		[8:0]	pcr_ext_cnt_r;
//    reg		[8:0]	pcr_ext_cnt_r1;
//    
//    reg		[10:0]	ip_cnt	;
//    reg		[7:0]	ts_cnt	;
//    reg		[7:0]	head_num;
//
//    reg     [3:0]   pcr_state ;
//
////------------------------------------------------------------------------------
//
//    parameter       IDLE    =   4'd0,	// state definition of the fsm
//                    BYTE1   =   4'd1,
//                    BYTE2   =   4'd2,
//                    BYTE3   =   4'd3,
//                    BYTE4   =   4'd4,
//                    BYTE5   =   4'd5,
//                    BYTE6   =   4'd6,
//                    BYTE7   =   4'd7,
//                    BYTE8   =   4'd8,
//                    BYTE9   =   4'd9,
//                    BYTE10  =   4'd10,
//                    BYTE11  =   4'd11,
//                    BYTE12  =   4'd12;  
//                    
//   //----------------------------------------------------------------------
///*
//   	reg [12:0]	pid_reg	;
//   	reg	[3:0]	cc_reg1	;
//	reg	[3:0]	cc_dif1	;	
//	reg	[3:0]	cc_reg2	;
//	reg	[3:0]	cc_dif2	;  
//   	reg			test_flag;
//*/   
//   
//   //----------------------------------------------------------------------                 
//
//   	always @ (posedge clk)
//   	begin
//   		if(pcr_din_en)
//   			ip_cnt <= ip_cnt + 1;
//   		else
//   			ip_cnt <= 0;
//	end
//	
//	always @ (posedge clk)
//	begin
//		if(ip_cnt == 11'd14)
//			head_num <= {2'b00,pcr_din[3:0],2'b00} + 8'd20;
//		else
//			head_num <= head_num ;	
//	end
//    
//    always @ (posedge clk)
//    begin
//    	if(ip_cnt > 11'd40)	
//    	begin
//    		if(ip_cnt > head_num)
//    		begin	
//    			if(ts_cnt >= 8'd188)
//    				ts_cnt <= 8'd1;
//    			else
//    				ts_cnt <= ts_cnt + 1;    		
//    		end
//    		else
//    			ts_cnt <= 0;
//    	end	
//    	else
//    		ts_cnt <= 0;	
//    end
//    
//    
//    always @(posedge clk)
//	begin
//			if(pcr_state == BYTE12)
//			begin
//				if(data_in_r[8:0]  < pcr_ext_cnt_r)
//				begin 
//					{pcr_dout[7:0],data_in_r[47:23]}	<= (data_in_r[47:15] - pcr_base_cnt_r) - 1;
//					data_in_r[22:17]					<= 6'b0;
//					data_in_r[16:8]						<= data_in_r[8:0] + pcr_ext_cnt_r1;
//					data_in_r[7:0]						<= pcr_din[7:0];
//				end
//				else
//				begin
//					{pcr_dout[7:0],data_in_r[47:23]}	<= data_in_r[47:15] - pcr_base_cnt_r;
//					data_in_r[22:17]					<= 6'b0;
//					data_in_r[16:8]						<= data_in_r[8:0] - pcr_ext_cnt_r;
//					data_in_r[7:0]						<= pcr_din[7:0];
//				end
//			end
//			else
//			begin
//				pcr_dout[7:0]		<= data_in_r[47:40];
//				data_in_r[47:40]	<= data_in_r[39:32];
//				data_in_r[39:32]	<= data_in_r[31:24];
//				data_in_r[31:24]	<= data_in_r[23:16];
//				data_in_r[23:16]	<= data_in_r[15:8];
//				data_in_r[15:8]		<= data_in_r[7:0];
//				data_in_r[7:0]		<= pcr_din[7:0];
//			end
//	end	
//	
//	always @(posedge clk)
//	begin
//		pcr_dout_en			<= pcr_din_dvalid_r[5];
//		pcr_din_dvalid_r[5]	<= pcr_din_dvalid_r[4];
//		pcr_din_dvalid_r[4]	<= pcr_din_dvalid_r[3];
//		pcr_din_dvalid_r[3]	<= pcr_din_dvalid_r[2];
//		pcr_din_dvalid_r[2]	<= pcr_din_dvalid_r[1];
//		pcr_din_dvalid_r[1]	<= pcr_din_dvalid_r[0];
//		pcr_din_dvalid_r[0]	<= pcr_din_en;
//	end
//	
//	always @(posedge clk)
//	begin
//		good_frame_out	<= good_frame_r[5];
//		good_frame_r[5]	<= good_frame_r[4];
//		good_frame_r[4]	<= good_frame_r[3];
//		good_frame_r[3]	<= good_frame_r[2];
//		good_frame_r[2]	<= good_frame_r[1];
//		good_frame_r[1]	<= good_frame_r[0];
//		good_frame_r[0]	<= good_frame_in;
//	end
//	
//	always @(posedge clk)
//	begin
//		bad_frame_out	<= bad_frame_r[5];
//		bad_frame_r[5]	<= bad_frame_r[4];
//		bad_frame_r[4]	<= bad_frame_r[3];
//		bad_frame_r[3]	<= bad_frame_r[2];
//		bad_frame_r[2]	<= bad_frame_r[1];
//		bad_frame_r[1]	<= bad_frame_r[0];
//		bad_frame_r[0]	<= bad_frame_in;
//	end
//	
//	always @(posedge clk)
//	begin
//		if (pcr_state == BYTE10)
//		begin
//			pcr_base_cnt_r	<= pcr_base_cnt;
//			pcr_ext_cnt_r	<= pcr_ext_cnt;
//		end
//		else
//		begin
//			pcr_base_cnt_r	<= pcr_base_cnt_r;
//			pcr_ext_cnt_r	<= pcr_ext_cnt_r;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(pcr_state == BYTE11)
//		begin
//			pcr_ext_cnt_r1	<= 300 - pcr_ext_cnt_r;
//		end
//		else
//		begin
//			pcr_ext_cnt_r1	<= pcr_ext_cnt_r1;
//		end
//	end
//		
////------------------------ sequential state transition -------------------------
//
//    always @ ( posedge clk ) 
//    begin
//        if ( rst ) 
//            pcr_state <= IDLE ;
//        else 
//        begin
//        	if(pcr_din_en)
//        	begin
//            	case ( pcr_state )
//            	    IDLE: 
//            	    	begin
//            	    	    if (ts_cnt == 8'd1 &&  pcr_din[7:0] == 8'h47 ) 
//            	    	    begin
//            	    	        pcr_state <= BYTE1 ;
//            	    	    end
//            	    	    else 
//            	    	    begin
//            	    	        pcr_state <= IDLE ;
//            	    	    end
//            	    	end
//            	    BYTE1:
//            	    	begin
//            	    		pcr_state	<= BYTE2;
//            	    	end
//            	    BYTE2:
//            	    	begin
//            	    		pcr_state	<= BYTE3;
//            	    	end
//            	    BYTE3:
//            	    	begin
//            	    		if(pcr_din[5] == 1'b1)//有调整字段
//            	    			pcr_state	<= BYTE4;
//            	    		else
//            	    			pcr_state	<= IDLE;
//            	    	end
//            	    BYTE4:
//            	    	begin
//            	    		if(pcr_din[7:0] > 0)//调整字段长度 > 0
//            	    		begin
//            	    			pcr_state	<= BYTE5;
//            	    		end
//            	    		else
//            	    		begin
//            	    			pcr_state	<= IDLE;
//            	    		end
//            	    	end
//            	    BYTE5:
//            	    	begin
//            	    		if(pcr_din[4] == 1'b1)//pcr_flag
//            	    			pcr_state	<= BYTE6;
//            	    		else
//            	    			pcr_state	<= IDLE;
//            	    	end
//            	    BYTE6:
//            	    	pcr_state	<= BYTE7;
//            	    BYTE7:
//            	    begin
//            	    	pcr_state	<= BYTE8;
//            	    end
//            	    BYTE8:
//            	    begin
//            	    	pcr_state	<= BYTE9;
//            	    end
//            	    BYTE9:
//            	    begin
//            	    	pcr_state	<= BYTE10;
//            	    end
//            	    BYTE10:
//            	    begin
//            	    	pcr_state	<= BYTE11;
//            	    end
//            	    BYTE11:
//            	    begin
//            	    	pcr_state	<= BYTE12;
//            	    end
//            	    BYTE12:
//            	    begin
//            	    	pcr_state	<= IDLE;
//            	    end
//            	    default: 
//            	    begin
//            	        pcr_state <= IDLE ;
//            	    end
//            	    
//            	endcase
//           end
//        	else
//        		 pcr_state <= IDLE ;
//        end
//    end    




//-----------------------------------------------------------------------
/*
	always @ (posedge clk)
	begin
		if(ts_cnt == 8'd2)		
			pid_reg[12:8] <= pcr_din[4:0];
		else if(ts_cnt == 8'd3)
			pid_reg[7:0] <= pcr_din;
		else
			pid_reg <= pid_reg;
	end
	
	
	always @ (posedge clk)
	begin
		if(ts_cnt == 8'd4 && pid_reg[12:0] == 13'h1001)
			begin
				cc_reg1	<= pcr_din[3:0];	
				cc_dif1	<= pcr_din[3:0] - cc_reg1;
			end
		else	
			begin
				cc_reg1	<= cc_reg1;
				cc_dif1 <= cc_dif1;
			end		
	end
	
	always @ (posedge clk)
	begin
		if(ts_cnt == 8'd4 && pid_reg[12:0] == 13'h1003)
			begin
				cc_reg2	<= pcr_din[3:0];	
				cc_dif2	<= pcr_din[3:0] - cc_reg2;
			end
		else	
			begin
				cc_reg2	<= cc_reg2;
				cc_dif2 <= cc_dif2;
			end		
	end
	
	always @ (posedge clk)
	begin
		test_flag	<= cc_dif1&& cc_dif2;
	end
*/
endmodule
