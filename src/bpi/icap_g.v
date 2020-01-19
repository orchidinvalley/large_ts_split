`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:17:22 09/06/2008 
// Design Name: 
// Module Name:    icap 
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
module icap_gao
(
			clk,
    		
    		reset,
			
			start,
			
			dout,
			delay
    		);



	
    input			clk;
    input			reset;
	input			start;
	
	
	output	[31:0]	dout;
	output	[2:0]	delay;
	
	//////////////////////////////////////
	
	reg		[2:0]	delay;
	reg				start_buf;
	
//	wire			clk_buf,clk;
	
	reg				start_r;
	
	reg		[31:0]	data_in;
	wire	[31:0]	i_in;
	
	reg				wr_n;
	wire			wr;
	
	reg				ce_n;
	wire			ce;
	
	wire			con_done;
	
	reg		[4:0]	count;
	reg		[1:0]	state,next_state;
	
	parameter	IDLES = 2'b00,
				BEGINS = 2'b01,
				ENDS	= 2'b10;
	
	assign	i_in[31]	= data_in[24];
	assign	i_in[30]	= data_in[25];
	assign	i_in[29]	= data_in[26];
	assign	i_in[28]	= data_in[27];
	assign	i_in[27]	= data_in[28];
	assign	i_in[26]	= data_in[29];
	assign	i_in[25]	= data_in[30];
	assign	i_in[24]	= data_in[31];
	assign	i_in[23]	= data_in[16];
	assign	i_in[22]	= data_in[17];
	assign	i_in[21]	= data_in[18];
	assign	i_in[20]	= data_in[19];
	assign	i_in[19]	= data_in[20];
	assign	i_in[18]	= data_in[21];
	assign	i_in[17]	= data_in[22];
	assign	i_in[16]	= data_in[23];
	assign	i_in[15]	= data_in[8];
	assign	i_in[14]	= data_in[9];
	assign	i_in[13]	= data_in[10];
	assign	i_in[12]	= data_in[11];
	assign	i_in[11]	= data_in[12];
	assign	i_in[10]	= data_in[13];
	assign	i_in[9]	= data_in[14];
	assign	i_in[8]	= data_in[15];
	assign	i_in[7]	= data_in[0];
	assign	i_in[6]	= data_in[1];
	assign	i_in[5]	= data_in[2];
	assign	i_in[4]	= data_in[3];
	assign	i_in[3]	= data_in[4];
	assign	i_in[2]	= data_in[5];
	assign	i_in[1]	= data_in[6];
	assign	i_in[0]	= data_in[7];
	assign	con_done	= (count == 7) ? 1'b1 : 1'b0;
	assign	wr	= wr_n;
	assign	ce	= ce_n;
	
	
	///////////////////////////////////////////////
	
	// always @(posedge clk)
	// begin
		// start_buf	<=	start;
	// end
	
	// always @(posedge clk)
	// begin
	
		// if(reset)
			// begin
			// delay	<= 0;
			// start_r	<= 1;
			// end
			
		// else	if(start	&&	!start_buf	&&	delay	==	2)
	
				// begin
				// delay	<= 0;
				// start_r	<= 0;
				// end
		// else	if(start	&&	!start_buf)
				// begin
				// delay	<= delay	+	1;
				// start_r	<= 1;
				// end
			
		// else
			// begin
			// delay	<= delay;
			// start_r	<= 1;
			// end
	
	// end	
	
	
//	always @(posedge clk)
//	begin
//		if(reset)
//			start_r	<= 1'b1;
//		else
//			start_r	<= start;
//	end
	
	
	
	always @(posedge clk)
	begin
		if(reset)
			state	<= IDLES;
		else
			state	<= next_state;
	end
	
	always @(state or start or con_done)
	begin
		case(state)
			IDLES:
				begin
					if(start)
						next_state	= BEGINS;
					else
						next_state	= IDLES;
				end
			BEGINS:
				begin
					if(con_done == 1)
						next_state	= ENDS;
					else
						next_state	= BEGINS;
				end
			ENDS:
				begin
					next_state	= IDLES;
				end
			default:
				begin
					next_state	= IDLES;
				end
		endcase
	end
	
	
	always @(posedge clk)
	begin
		if(reset)
		begin
			count	<= 5'b0;
		end
		else
		begin
			if(state == BEGINS)
			begin
				count	<= count + 1;
			end
			else
			begin
				count	<= 5'b0;
			end
		end 
	end
	
	
	always @(posedge clk)
	begin
		if(state == BEGINS)
		begin
			ce_n	<= 1'b0;
		end
		else
		begin
			ce_n	<= 1'b1;
		end
	end
	
	always @(posedge clk)
	begin
		if(state == BEGINS)
		begin
			wr_n	<= 1'b0;
		end
		else
		begin
			wr_n	<= 1'b1;
		end
	end
	
	always @(posedge clk)
	begin
		if(reset)
		begin
			data_in	<= 32'h00000000;
		end
		else
		begin
			if(state == BEGINS)
			begin
				if(count == 0)
				begin
					data_in	<= 32'hFFFFFFFF;
				end
				else if(count == 1)
				begin
					data_in	<= 32'hAA995566;
				end
				else if(count == 2)
				begin
					data_in	<= 32'h20000000;
				end
				else if(count == 3)
				begin
					data_in	<= 32'h30020001;
				end
				else if(count == 4)
				begin
					data_in	<= 32'h0c800000;
//					data_in	<= 32'h00200000;//
				end
				else if(count == 5)
				begin
					data_in	<= 32'h30008001;
				end
				else if(count == 6)
				begin
					data_in	<= 32'h0000000F;
				end
				else
				begin
					data_in	<= 32'h20000000;
				end
				/*if(count == 0)
				begin
					data_in	<= 8'hFF;
				end
				else if(count == 1)
				begin
					data_in	<= 8'hFF;
				end
				else if(count == 2)
				begin
					data_in	<= 8'hFF;
				end
				else if(count == 3)
				begin
					data_in	<= 8'hFF;
				end*/
				/*if(count == 0)
				begin
					data_in	<= 8'hAA;
				end
				else if(count == 1)
				begin
					data_in	<= 8'h99;
				end
				else if(count == 2)
				begin
					data_in	<= 8'h55;
				end
				else if(count == 3)
				begin
					data_in	<= 8'h66;
				end
				/*else if(count == 4)
				begin
					data_in	<= 8'h20;
				end
				else if(count == 5)
				begin
					data_in	<= 8'h00;
				end
				else if(count == 6)
				begin
					data_in	<= 8'h00;
				end
				else if(count == 7)
				begin
					data_in	<= 8'h00;
				end*/
				/*else if(count == 4)
				begin
					data_in	<= 8'h30;
				end
				else if(count == 5)
				begin
					data_in	<= 8'h02;
				end
				else if(count == 6)
				begin
					data_in	<= 8'h00;
				end
				else if(count == 7)
				begin
					data_in	<= 8'h01;
				end
				else if(count == 8)
				begin
					data_in	<= 8'h00;
				end
				else if(count == 9)
				begin
					data_in	<= 8'h20;
				end
				else if(count == 10)
				begin
					data_in	<= 8'h00;
				end
				else if(count == 11)
				begin
					data_in	<= 8'h00;
				end
				else if(count == 12)
				begin
					data_in	<= 8'h30;
				end
				else if(count == 13)
				begin
					data_in	<= 8'h00;
				end
				else if(count == 14)
				begin
					data_in	<= 8'h80;
				end
				else if(count == 15)
				begin
					data_in	<= 8'h01;
				end
				else if(count == 16)
				begin
					data_in	<= 8'h00;
				end
				else if(count == 17)
				begin
					data_in	<= 8'h00;
				end
				else if(count == 18)
				begin
					data_in	<= 8'h00;
				end
				else if(count == 19)
				begin
					data_in	<= 8'h0F;
				end
				/*else if(count == 28)
				begin
					data_in	<= 8'h20;
				end
				else if(count == 29)
				begin
					data_in	<= 8'h00;
				end
				else if(count == 30)
				begin
					data_in	<= 8'h00;
				end
				else 
				begin
					data_in	<= 8'h00;
				end*/
			end
		end
	end
	
	
   
	ICAP_VIRTEX6 #(
      .DEVICE_ID(0'h4244093),     // Specifies the pre-programmed Device ID value
      .ICAP_WIDTH("X32"),          // Specifies the input and output data width to be used with the
                                  // ICAP_VIRTEX6.
      .SIM_CFG_FILE_NAME("NONE")  // Specifies the Raw Bitstream (RBT) file to be parsed by the simulation
                                  // model
   )
   ICAP_VIRTEX6_inst (
      .BUSY(),   // 1-bit Busy/Ready output
      .O(dout),         // 32-bit Configuration data output bus
      .CLK(clk),     // 1-bit Clock Input
      .CSB(ce),     // 1-bit Active-Low ICAP input Enable
      .I(i_in),         // 32-bit Configuration data input bus
      .RDWRB(wr)  // 1-bit Read/Write Select input
   );


endmodule
