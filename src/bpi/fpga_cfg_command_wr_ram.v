`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:09:37 03/29/2010 
// Design Name: 
// Module Name:    qam_9789_cfg_command_4DA_wr_ram 
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
module flash_cfg_ram_wr
(
    clk_166m      ,
    reset         ,
    con_din       ,//2字节当前计数+2字节包总个数+4保留字节+256字节8位有效数据
    con_din_valid ,
    
    clkb          ,    //双口RAM B端口信号
    addrb         ,
    enb           ,
    doutb         ,
	
	
	config_reset,
    
    wr_flash_flag ,
    
    flag_clr	   ,
	
	pack_cnt,
	
	pack_num
    
);
  //-------------------------------------------------------  
  
    input              clk_166m        ;
    input              reset           ;
    input     [7:0]    con_din         ;
    input              con_din_valid   ;
    
    input              clkb            ;
    input     [6:0]    addrb           ;
    input              enb             ;
    output    [15:0]    doutb           ;
    
	output				config_reset;
	
	output			   wr_flash_flag  ;
    
	
    input				flag_clr	   ;
    
	
	output 				pack_cnt;
	
	output				pack_num;
    
  //-------------------------------------------------------
  
	reg				config_reset;
  
  
  	wire      [15:0]    doutb           ;
    reg				   wr_flash_flag ;
    
    reg       [6:0]    addra 		   ; 
	reg 		[15:0]		dina;
	reg 					wra;
  
 
    reg                con_din_valid_reg ;
    
   
		
	reg 		[8:0]		con_cnt;
	reg 					count;
	reg 		[15:0]  pack_cnt;
	reg 		[15:0]  pack_num;
	
	 
	wire 	[7:0]con_din_reverse;


    //-------------------------------------------------------    
    
    assign con_din_reverse[7]=con_din[0];
    assign con_din_reverse[6]=con_din[1];
    assign con_din_reverse[5]=con_din[2];
    assign con_din_reverse[4]=con_din[3];
    assign con_din_reverse[3]=con_din[4];
    assign con_din_reverse[2]=con_din[5];
    assign con_din_reverse[1]=con_din[6];
    assign con_din_reverse[0]=con_din[7];
      
    
    always @(posedge clk_166m)
    begin
        con_din_valid_reg <=con_din_valid;
    end
        
	always@(posedge clk_166m)begin
		if(reset)
			con_cnt<=0;
		else if(con_din_valid)
			con_cnt<=con_cnt+9'h1;
		else
			con_cnt<=0;
	end	
	
	
	always@(posedge clk_166m)begin
		if(reset)
			pack_cnt<=0;
		else if(con_cnt==0&&con_din_valid )
				pack_cnt[7:0]<=con_din;
		else if(con_cnt==1)
				pack_cnt<={pack_cnt[7:0],con_din};
		else
			pack_cnt<=pack_cnt;
	end	
	
		always@(posedge clk_166m)begin
		if(reset)
			pack_num<=0;
		else if(con_cnt==2 )
				pack_num[7:0]<=con_din;
		else if(con_cnt==3)
				pack_num<={pack_num[7:0],con_din};
		else
			pack_num<=pack_num;
	end	
	
	
		
	always@(posedge clk_166m)begin
		if(reset)
			config_reset<=0;
		else  if(con_cnt==2)begin
			if(pack_cnt==1)
			config_reset<=1;
			else
			config_reset<=0;			
		end
		else if(flag_clr)
			config_reset<=0;		
		else 
			config_reset<=config_reset;
	end
	
	
	always@(posedge clk_166m )begin 
		if(reset)
			count<=1'b0;
		else if(con_cnt>7)
			count<=count+1'b1;
		else 
			count<=1'b0;
	end 

	always@(posedge clk_166m)begin
		if(reset)begin			
			wra<=0;
			dina<=0;
		end
		else if((con_cnt>7) && con_din_valid)begin
			if(!count)begin
				wra<=0;
				dina<={8'b0,con_din_reverse};
			end
			else begin 
			 wra<=1;
		     dina<={dina[7:0],con_din_reverse};
			end 
		end
		else begin
			wra<=0;
			dina<=0;
		end
	end	
   
   always@(posedge clk_166m)begin
	if(reset)
		addra<=0;
	else if(wra)begin
		if(con_cnt==9)
			addra<=0;
		else 
			addra<=addra+7'h1;
	end 
	else
		addra<=addra;
   end
   
    
    
    
    always @(posedge clk_166m)                 //
    begin
        if(reset)           
            wr_flash_flag <=0;          
        else if(!con_din_valid && con_din_valid_reg)  //flag_clr           
            wr_flash_flag <= 1'b1;           
        else        
        	begin
        		if(flag_clr)
        			wr_flash_flag <=0;
        		else
         			wr_flash_flag <=wr_flash_flag; 
			end
    end

    
    fpga_cfg_wr_ram  fpga_cfg_wr_ram //128深度的RAM块 16位
    (
	.clka                  (clk_166m)          ,
	.dina                  (dina)       ,
	.addra                 (addra)             ,
	.ena                   (1'b1)              ,
	.wea                   (wra ) ,
	.douta                 ()                  ,
	.clkb                  (clkb)              ,
	.dinb                  (16'b0)              ,
	.addrb                 (addrb)             ,
	.enb                   (enb)               ,
	.web                   (1'b0)              ,
	.doutb                 (doutb)
	);
endmodule

