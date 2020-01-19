`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:20:59 07/08/2011 
// Design Name: 
// Module Name:    crc_32_check 
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
module crc_32_check_gtx(
	input				clk	,
	input	[7:0]		gmii_rxd	,
	input				gmii_rx_dv	,
	
	output	reg			crc_en		,
	output	reg			crc_err		
    );
    
    reg					gmii_rx_dv_r	;
	reg		[31:0]		CRC_out			;
	reg		[3:0]		cnt				;
	reg					sel				;
	
    
    always @(posedge clk)
    begin
    	gmii_rx_dv_r	<= gmii_rx_dv;
    end
    
    always @(posedge clk)
    begin
    	if (gmii_rx_dv == 1'b0)
    		cnt	<= 4'd0;
    	else if (cnt == 4'd8)
    		cnt	<= cnt;
    	else
    		cnt	<= cnt + 4'd1;
    end
    
    always @(posedge clk)
    begin
    	if (gmii_rx_dv)
    	begin
	    	if ((cnt <= 4'd7)&&(gmii_rxd == 8'hD5))
    			sel	<= 1'b1;
	    	else
	    		sel	<= sel;
    	end
    	else
    	begin
    		sel	<= 1'b0;
    	end
    end
    
  always @(posedge clk)
  begin
  	if (sel && gmii_rx_dv)
    begin
	    CRC_out[0]       <= CRC_out[8]  ^ CRC_out[2] ^ gmii_rxd[2];
	    CRC_out[1]       <= CRC_out[9]  ^ CRC_out[3] ^ CRC_out[0] ^ gmii_rxd[3] ^ gmii_rxd[0];
	    CRC_out[2]       <= CRC_out[10] ^ CRC_out[4] ^ CRC_out[1] ^ CRC_out[0] ^ gmii_rxd[4]  ^  gmii_rxd[1] ^ gmii_rxd[0];
	    CRC_out[3]       <= CRC_out[11] ^ CRC_out[5] ^ CRC_out[2] ^ CRC_out[1] ^ gmii_rxd[5]  ^  gmii_rxd[2]  ^ gmii_rxd[1];
	    CRC_out[4]       <= CRC_out[12] ^ CRC_out[6] ^ CRC_out[3] ^ CRC_out[2] ^ CRC_out[0]^ gmii_rxd[6] ^ gmii_rxd[3] ^ gmii_rxd[2] ^ gmii_rxd[0] ;
	    CRC_out[5]       <= CRC_out[13] ^ CRC_out[7] ^ CRC_out[4] ^ CRC_out[3] ^ CRC_out[1]  ^ gmii_rxd[7]^ gmii_rxd[4]^ gmii_rxd[3] ^ gmii_rxd[1] ;
	    CRC_out[6]       <= CRC_out[14] ^ CRC_out[5] ^ CRC_out[4] ^ gmii_rxd[5] ^ gmii_rxd[4]   ;
	    CRC_out[7]       <= CRC_out[15] ^ CRC_out[6] ^ CRC_out[5] ^ CRC_out[0] ^ gmii_rxd[6]^ gmii_rxd[5]^ gmii_rxd[0] ;
	    CRC_out[8]       <= CRC_out[16] ^ CRC_out[7] ^ CRC_out[6] ^ CRC_out[1] ^ gmii_rxd[7] ^ gmii_rxd[6]    ^ gmii_rxd[1] ;
	    CRC_out[9]       <= CRC_out[17] ^ CRC_out[7] ^ gmii_rxd[7];
	    CRC_out[10]      <= CRC_out[18] ^ CRC_out[2] ^ gmii_rxd[2];
	    CRC_out[11]      <= CRC_out[19] ^ CRC_out[3] ^ gmii_rxd[3];
	    CRC_out[12]      <= CRC_out[20] ^ CRC_out[4] ^ CRC_out[0] ^ gmii_rxd[4] ^ gmii_rxd[0]  ;
	    CRC_out[13]      <= CRC_out[21] ^ CRC_out[5] ^ CRC_out[1] ^ CRC_out[0] ^ gmii_rxd[5] ^ gmii_rxd[1] ^ gmii_rxd[0]     ;
	    CRC_out[14]      <= CRC_out[22] ^ CRC_out[6] ^ CRC_out[2] ^ CRC_out[1] ^ gmii_rxd[6] ^ gmii_rxd[2] ^ gmii_rxd[1]       ;
	    CRC_out[15]      <= CRC_out[23] ^ CRC_out[7] ^ CRC_out[3] ^ CRC_out[2] ^ gmii_rxd[7] ^ gmii_rxd[3] ^ gmii_rxd[2]      ;
	    CRC_out[16]      <= CRC_out[24] ^ CRC_out[4] ^ CRC_out[3] ^ CRC_out[2] ^ CRC_out[0] ^ gmii_rxd[4] ^ gmii_rxd[3]^ gmii_rxd[2]^ gmii_rxd[0]     ;
	    CRC_out[17]      <= CRC_out[25] ^ CRC_out[5] ^ CRC_out[4] ^ CRC_out[3] ^ CRC_out[1] ^ CRC_out[0] ^ gmii_rxd[5] ^ gmii_rxd[4] ^ gmii_rxd[3] ^ gmii_rxd[1] ^ gmii_rxd[0]                             													;
	    CRC_out[18]      <= CRC_out[26] ^ CRC_out[6] ^ CRC_out[5] ^ CRC_out[4] ^ CRC_out[2] ^ CRC_out[1] ^ CRC_out[0] ^ gmii_rxd[6] ^ gmii_rxd[5] ^ gmii_rxd[4] ^ gmii_rxd[2] ^ gmii_rxd[1] ^ gmii_rxd[0]                                                 ;
	    CRC_out[19]      <= CRC_out[27] ^ CRC_out[7] ^ CRC_out[6] ^ CRC_out[5] ^ CRC_out[3] ^ CRC_out[2] ^ CRC_out[1] ^ gmii_rxd[7] ^ gmii_rxd[6] ^ gmii_rxd[5] ^ gmii_rxd[3] ^ gmii_rxd[2] ^ gmii_rxd[1]               ;
	    CRC_out[20]      <= CRC_out[28] ^ CRC_out[7] ^ CRC_out[6] ^ CRC_out[4] ^ CRC_out[3] ^ gmii_rxd[7] ^ gmii_rxd[6] ^ gmii_rxd[4] ^ gmii_rxd[3]                      ;
	    CRC_out[21]      <= CRC_out[29] ^ CRC_out[7] ^ CRC_out[5] ^ CRC_out[4] ^ CRC_out[2] ^ gmii_rxd[7] ^ gmii_rxd[5] ^ gmii_rxd[4] ^ gmii_rxd[2]                                                 ;
	    CRC_out[22]      <= CRC_out[30] ^ CRC_out[6] ^ CRC_out[5] ^ CRC_out[3] ^ CRC_out[2] ^ gmii_rxd[6] ^ gmii_rxd[5] ^ gmii_rxd[3] ^ gmii_rxd[2]                                              ;
	    CRC_out[23]      <= CRC_out[31] ^ CRC_out[7] ^ CRC_out[6] ^ CRC_out[4] ^ CRC_out[3] ^ gmii_rxd[7] ^ gmii_rxd[6] ^ gmii_rxd[4] ^ gmii_rxd[3]                ;
	    CRC_out[24]      <= CRC_out[7]  ^ CRC_out[5] ^ CRC_out[4] ^ CRC_out[2] ^ CRC_out[0] ^ gmii_rxd[7] ^ gmii_rxd[5] ^ gmii_rxd[4] ^ gmii_rxd[2] ^ gmii_rxd[0]                                      ;
	    CRC_out[25]      <= CRC_out[6]  ^ CRC_out[5] ^ CRC_out[3] ^ CRC_out[2] ^ CRC_out[1] ^ CRC_out[0] ^ gmii_rxd[6] ^ gmii_rxd[5] ^ gmii_rxd[3] ^ gmii_rxd[2] ^ gmii_rxd[1] ^ gmii_rxd[0]                                                       ;
	    CRC_out[26]      <= CRC_out[7]  ^ CRC_out[6] ^ CRC_out[4] ^ CRC_out[3] ^ CRC_out[2] ^ CRC_out[1] ^ CRC_out[0] ^ gmii_rxd[7] ^ gmii_rxd[6] ^ gmii_rxd[4] ^ gmii_rxd[3] ^ gmii_rxd[2] ^ gmii_rxd[1] ^ gmii_rxd[0]                                                  ;
	    CRC_out[27]      <= CRC_out[7]  ^ CRC_out[5] ^ CRC_out[4] ^ CRC_out[3] ^ CRC_out[1] ^ gmii_rxd[7] ^ gmii_rxd[5] ^ gmii_rxd[4] ^ gmii_rxd[3] ^ gmii_rxd[1]                                                                     ;
	    CRC_out[28]      <= CRC_out[6]  ^ CRC_out[5] ^ CRC_out[4] ^ CRC_out[0] ^ gmii_rxd[6] ^ gmii_rxd[5] ^ gmii_rxd[4] ^ gmii_rxd[0]                                                                                      ;
	    CRC_out[29]      <= CRC_out[7]  ^ CRC_out[6] ^ CRC_out[5] ^ CRC_out[1] ^ CRC_out[0] ^ gmii_rxd[7] ^ gmii_rxd[6] ^ gmii_rxd[5] ^ gmii_rxd[1] ^ gmii_rxd[0]                                                                       ;
	    CRC_out[30]      <= CRC_out[7]  ^ CRC_out[6] ^ CRC_out[1] ^ CRC_out[0] ^ gmii_rxd[7] ^ gmii_rxd[6] ^ gmii_rxd[1] ^ gmii_rxd[0]                                                               ;
	    CRC_out[31]      <= CRC_out[7]  ^ CRC_out[1] ^ gmii_rxd[7] ^ gmii_rxd[1];
    end
  	else 
		CRC_out	<= 32'hffffffff;
  end

  	always @(posedge clk) 
  	begin
	    if ((gmii_rx_dv == 0)&&(gmii_rx_dv_r == 1)&&(CRC_out != 32'hdebb20e3))
		 	 crc_err	<= 1'b1;
		else if (gmii_rx_dv == 1)
			 crc_err	<= 1'b0;
	end
	
	always @(posedge clk)
	begin
		if ((gmii_rx_dv == 0)&&(gmii_rx_dv_r == 1))
			crc_en	<= 1'b1;
		else
			crc_en	<= 1'b0;
	end


endmodule
