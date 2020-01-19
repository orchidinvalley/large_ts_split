`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:43:35 08/28/2013 
// Design Name: 
// Module Name:    multi_7in1_new 
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
`include "txsoc_defines.v"

module multi_7in1_new(	
   i_clk,
	i_reset,		
	iv_ts,
	i_ts_en,
	
	i_ack,
	o_ready,
	
	ov_ts,
	o_ts_en
    );
	input			i_clk;
	input			i_reset;
	input [7:0]		iv_ts;
	input			i_ts_en;
	input			i_ack;
	output			o_ready;
	output [7:0]	ov_ts;
	output 			o_ts_en;
	
	reg			o_ready;
	reg [7:0]	ov_ts;
	reg			o_ts_en;
///////////////////////////////////////////////////////////////////////////////////	
	reg			ts_en_r,ts_en_r1,ts_en_r2,ts_en_r3,ts_en_r4,ts_en_r5;
	reg	[7:0]	ts_r,ts_r1,ts_r2,ts_r3,ts_r4;
	reg	[1:0]	wr_state;
	reg	[1:0]	wr_nxt_state;
	parameter	WR_IDLE = 2'b00,
				WR_LEN0	= 2'b01,
				WR_LEN1	= 2'b10,
				WR_TS	= 2'b11;
				
	reg	[2:0]	packet_cnt;
	reg	[7:0]	ts_cnt;
	
	reg			wr_en;
	reg	[7:0]	ram_din;
	reg	[10:0]	addra,addrb;
	wire[7:0]	ram_dout;
	
	reg	[1:0]	rd_state;
	reg	[1:0]	rd_nxt_state;
	parameter	RD_IDLE	= 2'b00,
				RD_HEAD	= 2'b01,
				RD_WT	= 2'b10,
				RD_TS	= 2'b11;
	
	reg	[2:0]	head_cnt;			
	reg	[10:0]	rd_cnt;
	
/////////////////////////////
	//artisan ram
	reg				ram_cena;
	reg				ram_wena;
	wire			ram_wenb;
	wire			ram_cenb;
////////////////////////////////////////////////////////////////////////////////////
	always @(posedge i_clk)
	begin
		if(i_reset)
		begin
			ts_r <= 8'b0;
			ts_r1 <= 8'b0;
			ts_r2 <= 8'b0;
			ts_r3 <= 8'b0;
			ts_r4 <= 8'b0;
		end	
		else
		begin
			ts_r <= iv_ts;
			ts_r1 <= ts_r;
			ts_r2 <= ts_r1;
			ts_r3 <= ts_r2;
			ts_r4 <= ts_r3;
		end
	end
	
	always @(posedge i_clk)
	begin
		if(i_reset)
		begin
			ts_en_r <= 1'b0;
			ts_en_r1 <= 1'b0;
			ts_en_r2 <= 1'b0;
			ts_en_r3 <= 1'b0;
			ts_en_r4 <= 1'b0;
			ts_en_r5 <= 1'b0;
		end
		else
		begin
			ts_en_r <= i_ts_en;
			ts_en_r1 <= ts_en_r;
			ts_en_r2 <= ts_en_r1;
			ts_en_r3 <= ts_en_r2;
			ts_en_r4 <= ts_en_r3;
			ts_en_r5 <= ts_en_r4;
		end
	end
	
	always @(posedge i_clk)
	begin
		if(i_reset)
			ts_cnt <= 8'b0;
		else if(i_ts_en)
				ts_cnt <= ts_cnt + 8'b1;
			else
				ts_cnt <= 8'b0;
	end
			
	always @(posedge i_clk)
	begin
		if(i_reset)
			packet_cnt <= 3'b0;
		else if(packet_cnt == 3'd7)
				packet_cnt <= 3'b0;
			else
			begin
				if(~ts_en_r4 && ts_en_r5)
					packet_cnt <= packet_cnt + 3'b1;
				else
					packet_cnt <= packet_cnt;
			end
	end
				
			
	always @(posedge i_clk)
	begin
		if(i_reset)
			wr_state <= WR_IDLE;
		else
			wr_state <= wr_nxt_state;
	end
	
	always @(wr_state or i_ts_en or packet_cnt)
	begin
		case(wr_state)
			WR_IDLE:
				if(i_ts_en)
				begin
					if(packet_cnt == 3'b0)
						wr_nxt_state = 	WR_LEN0;
					else
						wr_nxt_state = WR_TS;
				end
				else
					wr_nxt_state = WR_IDLE;
			WR_LEN0:
				wr_nxt_state = 	WR_LEN1;
			WR_LEN1:
				wr_nxt_state = WR_TS;
			WR_TS:
				if(packet_cnt == 3'd7)
					wr_nxt_state = WR_IDLE;
				else
					wr_nxt_state = WR_TS;
			default:
				wr_nxt_state = WR_IDLE;
		endcase
	end
	
	always @(posedge i_clk)
	begin
		if(i_reset)
		begin
			wr_en <= 1'b0;
		end
		else if(wr_state== WR_LEN0)
				begin
						wr_en <= 1'b1;
				end
		else if(wr_state== WR_LEN1)
				begin
						wr_en <= 1'b1;
				end
		else if(wr_state== WR_TS)
				begin
						if(packet_cnt == 3'b0)
						begin
								wr_en <= ts_en_r4;
						end
						else if(ts_cnt > 8'd5)
								begin
										wr_en <= i_ts_en;
								end
								else
								begin
										wr_en <= 1'b0;
								end
				end
end

	always @(posedge i_clk)
	begin
		if(i_reset)
		begin
			ram_wena <= 1'b1;
			ram_cena <= 1'b1;
		end
		else if(wr_state== WR_LEN0)
				begin
						ram_wena <= 1'b0;
						ram_cena <= 1'b0;
				end
		else if(wr_state== WR_LEN1)
				begin
						ram_wena <= 1'b0;
						ram_cena <= 1'b0;
				end
		else if(wr_state== WR_TS)
				begin
						if(packet_cnt == 3'b0)
						begin
								ram_wena <= ~ts_en_r4;
								ram_cena <= ~ts_en_r4;
						end
						else if(ts_cnt > 8'd5)
								begin
										ram_wena <= ~i_ts_en;
										ram_cena <= ~i_ts_en;
								end
								else
								begin
										ram_wena <= 1'b1;
										ram_cena <= 1'b1;
								end
				end
end

	always @(posedge i_clk)
	begin
		if(i_reset)
		begin
			
			ram_din <= 8'b0;
		end
		else if(wr_state== WR_LEN0)
			begin
				
				ram_din <= 8'h05;
			end
		else if(wr_state== WR_LEN1)
			begin
				
				ram_din <= 8'h2c;
			end
		else if(wr_state== WR_TS)
			begin
				if(packet_cnt == 3'b0)
				begin
					
					ram_din <= ts_r4;
				end
				else if(ts_cnt > 8'd5)
					begin
						ram_din <= iv_ts;
					end
					else
					begin
						
						ram_din <= 8'b0;
					end
				end
				else
				begin
					
					ram_din <= 8'b0;
				end
		end
	
	always @(posedge i_clk)
	begin
		if(i_reset)
			addra <= 11'b0;
		else if(wr_en || (~ram_wena))
				addra <= addra + 11'b1;
			else
				addra <= addra;
	end
					
	always @(posedge i_clk)
	begin
		if(i_reset)
			o_ready <= 1'b0;
		else
		begin
			if(i_ack==1'b1)
				o_ready <= 1'b0; 
			else if(packet_cnt == 3'd7)
						o_ready <= 1'b1;		
					else
						o_ready <= o_ready;
		end
	end
	
	always @(posedge i_clk)
	begin
		if(i_reset)
			rd_state <= RD_IDLE;
		else
			rd_state <= rd_nxt_state;
	end
	
	always @(posedge i_clk)
	begin
		if(i_reset)
			head_cnt <= 3'b0;
		else if(rd_state == RD_HEAD)
				head_cnt <= head_cnt + 3'b1;
			else
				head_cnt <= 3'b0;
	end
	
	always @(posedge i_clk)
	begin
		if(i_reset)
			rd_cnt <= 11'b0;
		else if(rd_state == RD_TS)
				rd_cnt <= rd_cnt + 11'b1;
			else
				rd_cnt <= 11'b0;
	end
	
	always @(rd_state or i_ack or head_cnt or rd_cnt)
	begin
		case(rd_state)
			RD_IDLE:
				if(i_ack)
					rd_nxt_state = RD_HEAD;
				else
					rd_nxt_state = RD_IDLE;
			RD_HEAD:
				if(head_cnt==3'd7)
					rd_nxt_state = RD_WT;
				else
					rd_nxt_state = RD_HEAD;
			RD_WT:
				if(i_ack)
					rd_nxt_state = RD_TS;
				else
					rd_nxt_state = RD_WT;
			RD_TS:
				if(rd_cnt==11'd1315)
					rd_nxt_state = RD_IDLE;
				else
					rd_nxt_state = RD_TS;
			default:
				rd_nxt_state = RD_IDLE;
		endcase
	end
	
	always @(posedge i_clk)
	begin
		if(i_reset)
			addrb <= 11'b0;
		else if((rd_nxt_state==RD_HEAD) || (rd_nxt_state==RD_TS))
				addrb <= addrb + 11'b1;
			else
				addrb <= addrb;
	end
	
	assign	ram_wenb = ((rd_nxt_state==RD_HEAD) || (rd_nxt_state==RD_TS)) ? 1'b1 : 1'b0;
	assign	ram_cenb = ((rd_nxt_state==RD_HEAD) || (rd_nxt_state==RD_TS)) ? 1'b0 : 1'b1;
	
	always @(posedge i_clk)
	begin
		if(i_reset)
		begin
			ov_ts <= 8'b0;
			o_ts_en <= 1'b0;
		end
		else if((rd_state==RD_HEAD) || (rd_state==RD_TS))
			begin
				ov_ts <= ram_dout;
				o_ts_en <= 1'b1;
			end
			else
			begin
				ov_ts <= 8'b0;
				o_ts_en <= 1'b0;
			end
	end
///////////////////////////////////////////////////////////////////////
`ifdef XILINX_RAM				
multi_7in1_ram			multi_7in1_ram
(
		.clka 		(i_clk),	
		.wea			(wr_en),
		.addra		(addra),
		.dina 		(ram_din),
		.clkb     (i_clk),
		.addrb		(addrb),				        		
		.doutb 		(ram_dout)	
);
`endif

`ifdef ARTISAN_RAM
multi_7in1_ram			multi_7in1_ram
(
	.CLKA				(i_clk),
	.CENA				(ram_cena),
	.WENA				(ram_wena),  //LOW :write activity
	.AA					(addra),
	.DA					(ram_din),
	.OENA				(1'b1),
	.QA					(),
	.CLKB				(i_clk),
	.CENB				(ram_cenb),
	.WENB				(ram_wenb),			//HIGH:read activity
	.AB					(addrb),
	.DB					(),
	.OENB				(1'b0),
	.QB					(ram_dout)
);
`endif
endmodule
