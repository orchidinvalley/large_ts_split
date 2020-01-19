`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:15:05 05/03/2011 
// Design Name: 
// Module Name:    arp_fade 
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
module arp_fade(

	tx_req_netport,
	tx_req_ip,
	tx_req_en,
	
	tx_del_ip,
	tx_del_en,

	rx_wr_netport,
	rx_wr_ip,
	rx_wr_addr,
	rx_wr_en,
	
//	rd_ram_sign,	//test port
//	rd_ram_addr,	//test port
//	req_cnt,    	//test port
//	wr_ram_sign,	//test port
//	wr_ram_addr,	//test port
//	wr_ram_en,      //test port
	
	rst,
	clk 
	
    );
    
	parameter	DATA_DEPTH = 4'd10; //2的DATA_DEPTH次方
	parameter	INQUIRE = 26'h22ecb25;// 时钟频率 125M  数据深度1024 约5分钟遍历一次
       
	output		[23:0]				tx_req_netport;
	output		[31:0]				tx_req_ip;
	output	reg						tx_req_en;
	
	output		[31:0]				tx_del_ip;
	output	reg						tx_del_en;
	
	input		[23:0]				rx_wr_netport;
	input		[31:0]				rx_wr_ip;     
	input		[DATA_DEPTH-1:0]	rx_wr_addr;   
	input							rx_wr_en;     

	input							rst;
	input							clk;
	
//	output		[1:0]				wr_ram_sign;	//test port	
//	output		[DATA_DEPTH-1:0]	wr_ram_addr;	//test port
//	output							wr_ram_en;      //test port
//	output		[1:0]				rd_ram_sign;	//test port
//	output		[DATA_DEPTH-1:0]	rd_ram_addr;	//test port
//	output		[25:0]				req_cnt;    	//test port
	
	reg			[1:0]				wr_ram_sign;
	reg			[DATA_DEPTH-1:0]	wr_ram_addr;							
	reg								wr_ram_en;
	
	reg			[DATA_DEPTH-1:0]	rd_ram_addr;

	reg			[25:0]				req_cnt;
	
	wire		[1:0]				rd_ram_sign;
	
assign	tx_del_ip = tx_req_ip;

always@(posedge clk)
begin
	if(rst)
	begin
		wr_ram_sign <= 0;
		wr_ram_addr <= 0;
		wr_ram_en <= 0;
		rd_ram_addr <= 0;
		tx_req_en <= 0;
		tx_del_en <= 0;		
	end
	else
	begin
		if(rx_wr_en	&& rx_wr_netport != 0)
		begin
			wr_ram_sign <= 2'b01;
			wr_ram_addr <= rx_wr_addr;
			wr_ram_en <= 1'b1;
			rd_ram_addr <= rd_ram_addr;
			tx_req_en <= 0;
			tx_del_en <= 0;	
		end
		else
		begin
			if(req_cnt == INQUIRE )
			begin
				case(rd_ram_sign)
					2'b00:	begin	
								rd_ram_addr <= rd_ram_addr + 1'b1;	
								wr_ram_addr <= 0;
								wr_ram_en <= 1'b0;
								wr_ram_sign <= 2'b00;
								tx_req_en <= 0;
								tx_del_en <= 0;	
							end
					2'b01:	begin	
								rd_ram_addr <= rd_ram_addr + 1'b1;
								wr_ram_addr <= rd_ram_addr;
								wr_ram_en <= 1'b1;
								wr_ram_sign <= 2'b10;
								tx_req_en <= 0;
								tx_del_en <= 0;	
							end
					2'b10:	begin
								rd_ram_addr <= rd_ram_addr + 1'b1;
								wr_ram_addr <= rd_ram_addr;
								wr_ram_en <= 1'b1;
								wr_ram_sign <= 2'b11;
								tx_req_en <= 1'b1;
								tx_del_en <= 0;	
							end
					2'b11:	begin
								rd_ram_addr <= rd_ram_addr + 1'b1;
								wr_ram_addr <= rd_ram_addr;
								wr_ram_en <= 1'b1;
								wr_ram_sign <= 2'b00;
								tx_req_en <= 1'b1;
								tx_del_en <= 1'b1;	
							end
				endcase
			end
			else
			begin
				wr_ram_sign <= 2'b00;
				wr_ram_addr <= wr_ram_addr;
				rd_ram_addr <= rd_ram_addr;
				wr_ram_en <= 1'b0;
				tx_req_en <= 0;	
				tx_del_en <= 0;	
			end
		end
	end
end

always@(posedge clk)
begin
	if(req_cnt == INQUIRE || rst)
	begin
		req_cnt <= 0;
	end
	else
	begin
		req_cnt <= req_cnt + 1'b1;
	end
end

sign_ram	sign_ram_inst(
	
		.doutb(rd_ram_sign),//2bit sign
		.addrb(rd_ram_addr),
		
		.dina(wr_ram_sign),
		.addra(wr_ram_addr),
		.wea(wr_ram_en), 
		
		.clka(clk),
		.clkb(clk)
		
		);
		
ip_ram	ip_ram_inst(

		.doutb({tx_req_netport,tx_req_ip}),//[55:0],24bit netport,32bit ip
		.addrb(rd_ram_addr),
		
		.dina({rx_wr_netport,rx_wr_ip}),//[55:0],[55:32] netport,[31:0] ip
		.addra(rx_wr_addr),
		.wea(rx_wr_en), 
		
		.clka(clk),
		.clkb(clk)
		
		);

endmodule
