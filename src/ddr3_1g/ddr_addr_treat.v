`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:53:12 06/17/2010 
// Design Name: 
// Module Name:    ddr_addr_treat 
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
module ddr_addr_treat(

	clk,
	rst,
	
	psi_addr_din,
	psi_addr_din_en,
	ecm_addr_din,
	ecm_addr_din_en,
	rd_fifo_wfull,
	
	ddr_addr_dout,
	ddr_addr_dout_en
    );
    
    input			clk;
    input			rst;
    
    input	[35:0]	psi_addr_din;
    input			psi_addr_din_en;
    
    input	[35:0]	ecm_addr_din;
    input			ecm_addr_din_en;
    
    input			rd_fifo_wfull;
    
    output	[35:0]	ddr_addr_dout;
    output			ddr_addr_dout_en;
    
    
    reg		[35:0]	ddr_addr_dout;
    reg				ddr_addr_dout_en;
    
    
    reg				psi_fifo_rd;
    wire	[35:0]	psi_fifo_dout;
    wire			psi_fifo_empty;
    reg				ecm_fifo_rd;
    wire	[35:0]	ecm_fifo_dout;
    wire			ecm_fifo_empty;
    
    reg		[3:0]	read_cnt;
    
    reg		[2:0]	addr_state;
    
    parameter		IDLE		= 3'b001,
    				PSI_READ	= 3'b010,
    				ECM_READ	= 3'b100;
    
    always @(posedge clk)
    begin
    	if(rst)
    	begin
    		addr_state	<= IDLE;
    	end
    	else
    	begin
    		case(addr_state)
    			IDLE:
    				begin
    					if(psi_fifo_empty == 1'b0 && rd_fifo_wfull == 1'b0)
    					begin
    						addr_state	<= PSI_READ;
    					end
    					else if(ecm_fifo_empty == 1'b0 && rd_fifo_wfull == 1'b0)
    					begin
    						addr_state	<= ECM_READ;
    					end
    					else
    					begin
    						addr_state	<= IDLE;
    					end
    				end
    			PSI_READ:
    				begin
    					if(read_cnt == 5)
    					begin
    						addr_state	<= IDLE;
    					end
    					else
    					begin
    						addr_state	<= PSI_READ;
    					end
    				end
    			ECM_READ:
    				begin
    					if(read_cnt == 5)
    					begin
    						addr_state	<= IDLE;
    					end
    					else
    					begin
    						addr_state	<= ECM_READ;
    					end
    				end
    			default:
    				begin
    					addr_state	<= IDLE;
    				end
    		endcase
    	end
    end
    
    always @(posedge clk)
    begin
    	if(addr_state == PSI_READ || addr_state == ECM_READ)
    	begin
    		read_cnt	<= read_cnt + 1;
    	end
    	else
    	begin
    		read_cnt	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(addr_state == PSI_READ && read_cnt == 0)
    	begin
    		psi_fifo_rd	<= 1'b1;
    	end
    	else
    	begin
    		psi_fifo_rd	<= 1'b0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(addr_state == ECM_READ && read_cnt == 0)
    	begin
    		ecm_fifo_rd	<= 1'b1;
    	end
    	else
    	begin
    		ecm_fifo_rd	<= 1'b0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(read_cnt == 3)
    	begin
    		if(addr_state == PSI_READ)
    		begin
    			ddr_addr_dout	<= psi_fifo_dout;
    			ddr_addr_dout_en	<= 1'b1;
    		end
    		else if(addr_state == ECM_READ)
    		begin
    			ddr_addr_dout	<= ecm_fifo_dout;
    			ddr_addr_dout_en	<= 1'b1;
    		end
    		else
    		begin
    			ddr_addr_dout	<= 0;
    			ddr_addr_dout_en	<= 0;
    		end
    	end
    	else
    	begin
    		ddr_addr_dout	<= 0;
    		ddr_addr_dout_en	<= 0;
    	end
    end
    
    ddr_addr_fifo	psi_addr_fifo(
		.rst				(rst),
		.wr_clk				(clk),
		.rd_clk				(clk),
		.din				(psi_addr_din),
		.wr_en				(psi_addr_din_en),
		.rd_en				(psi_fifo_rd),
		.dout				(psi_fifo_dout),
		.full				(),
		.empty              (psi_fifo_empty)
		);
		
	ddr_addr_fifo	ecm_addr_fifo(
		.rst				(rst),
		.wr_clk				(clk),
		.rd_clk				(clk),
		.din				(ecm_addr_din),
		.wr_en				(ecm_addr_din_en),
		.rd_en				(ecm_fifo_rd),
		.dout				(ecm_fifo_dout),
		.full				(),
		.empty              (ecm_fifo_empty)
		);


endmodule
