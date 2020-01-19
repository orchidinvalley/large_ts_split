`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:05:56 09/19/2019 
// Design Name: 
// Module Name:    dma_time_test 
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
module dma_time_test(

clk_pcie,
rst_pcie,

dma_write_start,
dma_write_end,

test_interval



    );
    
    input	clk_pcie;
    input rst_pcie;
    
    input	dma_write_start;
    input dma_write_end;
    
    output	test_interval;

	
	reg	[32:0]read_cnt;	
	reg	[32:0]read_interval;
	reg	[32:0]read_cnt_max;	
	reg	[32:0]read_interval_max;
	
	
	reg	[1:0]	time_cstate;
	reg	[1:0]	time_nstate;
	
	parameter	T_IDLE=0,
						T_READ=1,
						T_INTERVAL=2;
	
	
	always@(posedge clk_pcie)begin
		if(rst_pcie)
			time_cstate	<=	T_IDLE;
		else
			time_cstate	<=	time_nstate;
	end


	always@(*)begin
		case(time_cstate)
				T_IDLE:
					if(dma_write_start)
						time_nstate	=	T_READ;
					else
						time_nstate	=	T_IDLE;
				T_READ:
					if(dma_write_end)
						time_nstate	=	T_INTERVAL;
					else
						time_nstate	=	T_READ;	
				T_INTERVAL:
					if(dma_write_start)	
						time_nstate	=	T_READ;
					else
						time_nstate	=	T_INTERVAL;
				default:
					time_nstate	=	T_IDLE;
		endcase
	end

	always@(posedge clk_pcie)begin
		if(time_cstate==	T_READ)
			read_cnt	<=	read_cnt+1;
		else
			read_cnt	<=0;
	end

	always@(posedge clk_pcie)begin
		if(time_cstate==	T_INTERVAL)
			read_interval	<=	read_interval+1;
		else
			read_interval	<=0;
	end
	
	always@(posedge clk_pcie)begin
		if(rst_pcie)
			read_cnt_max	<=0;
		else if(dma_write_end)begin
			if(read_cnt>read_cnt_max)
				read_cnt_max	<=	read_cnt;
			else
				read_cnt_max	<=	read_cnt_max;
		end
		else
			read_cnt_max	<=	read_cnt_max;
	end
	
	always@(posedge clk_pcie)begin
		if(rst_pcie)
			read_interval_max	<=0;
		else if(dma_write_start && time_cstate==T_INTERVAL)begin
			if(read_interval>read_interval_max)
				read_interval_max	<=	read_interval;
			else
				read_interval_max	<=	read_interval_max;
		end
		else
			read_interval_max	<=	read_interval_max;
	end
	
	
	
	assign test_interval=read_cnt_max==0 && read_interval_max==0;



endmodule
