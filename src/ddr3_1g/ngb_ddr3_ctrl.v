`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:27:11 01/20/2010 
// Design Name: 
// Module Name:    vod_ddr2_ctrl 
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
module ngb_ddr3_ctrl#(
	parameter DQ_WIDTH                = 64,
                                       // # of Data (DQ) bits.
	parameter ROW_WIDTH               = 14,
                                       // # of memory Row Address bits.
   	parameter BANK_WIDTH              = 3,
                                       // # of memory Bank Address bits.
	parameter CS_WIDTH                = 1,
                                       // # of unique CS outputs to memory.
    parameter nCS_PER_RANK            = 1,
                                       // # of unique CS outputs per Rank for
    parameter DM_WIDTH                = 8,
                                       // # of Data Mask bits.
    parameter DQS_WIDTH               = 8,
                                       // # of DQS/DQS# bits.
    parameter CK_WIDTH                = 1,
                                       // # of CK/CK# outputs to memory. 
    parameter PAYLOAD_WIDTH           = 64,
    
    parameter ADDR_WIDTH              = 28
                                       // # = RANK_WIDTH + BANK_WIDTH
                                       //     + ROW_WIDTH + COL_WIDTH;
)   
(   
//200mhz clock input
    input 				clk_ddr3,//200MHZ
//    input				sys_clk_n,
	input				reset,
	
	///////////ddr2 read interface////////////////////    
    input				rd_fifo_wclk,
    input	[35:0]		psi_addr_din,
    input				psi_addr_din_en,
    input	[35:0]		ecm_addr_din,
    input				ecm_addr_din_en,
///////////ddr2 write interface///////////////////   
	input				wr_fifo_wclk, 
	output				wr_fifo_wfull,
	input		[7:0]	ecm_din,
	input				ecm_din_en,
	input		[7:0]	si_din,
	input				si_din_en,

	

	output		[8:0]	dvb_ddr_dout,
	output				dvb_ddr_dout_en,
	//output				clk_user,

///////////mig interface////////////////////
	inout  [DQ_WIDTH-1:0]              				ddr3_dq,
	output [ROW_WIDTH-1:0]             				ddr3_addr,
	output [BANK_WIDTH-1:0]            				ddr3_ba,
	output                             				ddr3_ras_n,
	output                             				ddr3_cas_n,
	output                             				ddr3_we_n,
	output											ddr3_reset_n,
	output [(CS_WIDTH*nCS_PER_RANK)-1:0]            ddr3_cs_n,
	output [(CS_WIDTH*nCS_PER_RANK)-1:0]            ddr3_odt,
	output [CS_WIDTH-1:0]				            ddr3_cke,
	output [DM_WIDTH-1:0]              				ddr3_dm,
	inout  [DQS_WIDTH-1:0]             				ddr3_dqs_p,
	inout  [DQS_WIDTH-1:0]             				ddr3_dqs_n,
	output [CK_WIDTH-1:0]			                ddr3_ck_p,
	output [CK_WIDTH-1:0]             				ddr3_ck_n,
	output											phy_init_done
    );
    
	wire 				clk0;
    wire				clk_ref;
    wire				clkfbout_i;
    wire				mmcm_locked_out;
//	wire				phy_init_done;
    wire				clk_user;
    
   wire                                		app_wdf_wren;
   wire [(8*PAYLOAD_WIDTH)-1:0]             app_wdf_data;
   wire [(8*PAYLOAD_WIDTH)/8-1:0]           app_wdf_mask;
   wire                                		app_wdf_end;
   wire [ADDR_WIDTH-1:0]               		app_addr;
   wire [2:0]                          		app_cmd;
   wire                                		app_en;
   wire                               		app_rdy;
   wire                               		app_wdf_rdy;
   wire [(8*PAYLOAD_WIDTH)-1:0]            	app_rd_data;
   wire                               		app_rd_data_valid;
   wire                               		tb_rst;
   wire                               		tb_clk;
	
	wire			rd_fifo_rempty;
	wire			rd_fifo_rreq;
	wire	[35:0]	rd_fifo_rdata;
	
	wire			wr_fifo_rempty;
	wire			wr_fifo_rreq;
	wire	[512:0]	wr_fifo_rdata;
	wire	[8:0]	wr_fifo_rcnt;
	
	wire	[512:0]	wr_dout;
	
	wire			rd_fifo_wreq;  
    wire			rd_fifo_wfull;
    wire	[35:0]	rd_fifo_wdata;
    wire				dvb_data_valid;
	wire		[512:0]	C_data;
	wire				iptv_data_valid;
	

    
    wire		mig_rst;
  	 assign	mig_rst = reset;
           
           
	   
	ddr3_interface	ddr3_interface(
	//clk and sys_rst
		.clk(clk_user),
		.reset(!phy_init_done),
	//read fifo interface
		.rd_fifo_rempty(rd_fifo_rempty),
		.rd_fifo_rreq(rd_fifo_rreq),
		.rd_fifo_rdata(rd_fifo_rdata),
	//	.iptv_flag_overflow(iptv_flag_overflow),
		.dvb_flag_overflow(dvb_flag_overflow),
	//write fifo interface
		.wr_fifo_rempty(wr_fifo_rempty),
		.wr_fifo_rreq(wr_fifo_rreq),
		.wr_fifo_rdata(wr_fifo_rdata),
		.wr_fifo_rcnt(wr_fifo_rcnt),
	//read data interface
		.app_rd_data_valid(app_rd_data_valid),
		.app_rd_data(app_rd_data),
		.dvb_data_valid(dvb_data_valid),
		.C_data(C_data),
		.iptv_data_valid(iptv_data_valid),
	//mig interface
		.app_wdf_rdy(app_wdf_rdy),
		.app_rdy(app_rdy),
		.app_wdf_wren(app_wdf_wren),
		.app_en(app_en),
		.app_addr(app_addr),
		.app_cmd(app_cmd),
		.app_wdf_data(app_wdf_data),
		.app_wdf_mask(app_wdf_mask),
		.app_wdf_end(app_wdf_end)
		);
			
		    
	    	
    ddr_rd_treat	dvb_rd_treat(

		.wr_clk				(clk_user),
		.rd_clk				(rd_fifo_wclk),
		.rst				(mig_rst),
		
		.rd_din				(C_data),
		.rd_din_en			(dvb_data_valid),
		
		.rd_dout			(dvb_ddr_dout),
		.rd_dout_en         (dvb_ddr_dout_en),
		.flag_overflow		(dvb_flag_overflow)
    	);
    


mig_7series_v1_9 u_mig (
    .ddr3_dq(ddr3_dq), 
    .ddr3_dqs_n(ddr3_dqs_n), 
    .ddr3_dqs_p(ddr3_dqs_p), 
    .ddr3_addr(ddr3_addr), 
    .ddr3_ba(ddr3_ba), 
    .ddr3_ras_n(ddr3_ras_n), 
    .ddr3_cas_n(ddr3_cas_n), 
    .ddr3_we_n(ddr3_we_n), 
    .ddr3_reset_n(ddr3_reset_n), 
    .ddr3_ck_p(ddr3_ck_p), 
    .ddr3_ck_n(ddr3_ck_n), 
    .ddr3_cke(ddr3_cke), 
    .ddr3_cs_n(ddr3_cs_n), 
    .ddr3_dm(ddr3_dm), 
    .ddr3_odt(ddr3_odt), 
    .sys_clk_i(clk_ddr3), 
    .app_addr(app_addr), 
    .app_cmd(app_cmd), 
    .app_en(app_en), 
    .app_wdf_data(app_wdf_data), 
    .app_wdf_end(app_wdf_end), 
    .app_wdf_mask(app_wdf_mask), 
    .app_wdf_wren(app_wdf_wren), 
    .app_rd_data(app_rd_data), 
    .app_rd_data_end(app_rd_data_end), 
    .app_rd_data_valid(app_rd_data_valid), 
    .app_rdy(app_rdy), 
    .app_wdf_rdy(app_wdf_rdy), 
    .app_sr_req(1'b0), 
    .app_sr_active(app_sr_active), 
    .app_ref_req(1'b0), 
    .app_ref_ack(app_ref_ack), 
    .app_zq_req(1'b0), 
    .app_zq_ack(app_zq_ack), 
    .ui_clk(clk_user), 
    .ui_clk_sync_rst(ui_clk_sync_rst), 
    .ddr3_ila_wrpath(ddr3_ila_wrpath), 
    .ddr3_ila_rdpath(ddr3_ila_rdpath), 
    .ddr3_ila_basic(ddr3_ila_basic), 
    .ddr3_vio_sync_out(ddr3_vio_sync_out), 
    .dbg_byte_sel(dbg_byte_sel), 
    .dbg_sel_pi_incdec(dbg_sel_pi_incdec), 
    .dbg_pi_f_inc(dbg_pi_f_inc), 
    .dbg_pi_f_dec(dbg_pi_f_dec), 
    .dbg_sel_po_incdec(dbg_sel_po_incdec), 
    .dbg_po_f_inc(dbg_po_f_inc), 
    .dbg_po_f_stg23_sel(dbg_po_f_stg23_sel), 
    .dbg_po_f_dec(dbg_po_f_dec), 
    .dbg_pi_counter_read_val(dbg_pi_counter_read_val), 
    .dbg_po_counter_read_val(dbg_po_counter_read_val), 
    .init_calib_complete(phy_init_done), 
    .sys_rst(mig_rst)
    );	
	
	
//	mig_7series instance_name (
//    .ddr3_dq(ddr3_dq), 
//    .ddr3_dqs_n(ddr3_dqs_n), 
//    .ddr3_dqs_p(ddr3_dqs_p), 
//    .ddr3_addr(ddr3_addr), 
//    .ddr3_ba(ddr3_ba), 
//    .ddr3_ras_n(ddr3_ras_n), 
//    .ddr3_cas_n(ddr3_cas_n), 
//    .ddr3_we_n(ddr3_we_n), 
//    .ddr3_reset_n(ddr3_reset_n), 
//    .ddr3_ck_p(ddr3_ck_p), 
//    .ddr3_ck_n(ddr3_ck_n), 
//    .ddr3_cke(ddr3_cke), 
//    .ddr3_cs_n(ddr3_cs_n), 
//    .ddr3_dm(ddr3_dm), 
//    .ddr3_odt(ddr3_odt), 
//    .sys_clk_i(clk_ddr3), 
//    .clk_ref_i(clk_ddr3), 
//    .app_addr(app_addr), 
//    .app_cmd(app_cmd), 
//    .app_en(app_en), 
//    .app_wdf_data(app_wdf_data), 
//    .app_wdf_end(app_wdf_end), 
//    .app_wdf_mask(app_wdf_mask), 
//    .app_wdf_wren(app_wdf_wren), 
//    .app_rd_data(app_rd_data), 
//    .app_rd_data_end(app_rd_data_end), 
//    .app_rd_data_valid(app_rd_data_valid), 
//    .app_rdy(app_rdy), 
//    .app_wdf_rdy(app_wdf_rdy), 
//    .app_sr_req(1'b0), 
//    .app_sr_active(app_sr_active), 
//    .app_ref_req(1'b0), 
//    .app_ref_ack(app_ref_ack), 
//    .app_zq_req(1'b0), 
//    .app_zq_ack(app_zq_ack), 
//    .ui_clk(clk_user), 
//    .ui_clk_sync_rst(ui_clk_sync_rst), 
//    .init_calib_complete(phy_init_done), 
//    .sys_rst(sys_rst)
//    );
		

		
	ddr_addr_treat	addr_treat(

		.clk				(rd_fifo_wclk),
		.rst				(mig_rst),
		
		.psi_addr_din		(psi_addr_din),
		.psi_addr_din_en	(psi_addr_din_en),
		.ecm_addr_din		(ecm_addr_din),
		.ecm_addr_din_en	(ecm_addr_din_en),
		.rd_fifo_wfull		(rd_fifo_wfull),
		
		.ddr_addr_dout		(rd_fifo_wdata),
		.ddr_addr_dout_en   (rd_fifo_wreq)
    	);
		
	ddr_addr_fifo	rd_fifo(
		.rst				(mig_rst),
		.wr_clk				(rd_fifo_wclk),
		.rd_clk				(clk_user),
		.din				(rd_fifo_wdata),
		.wr_en				(rd_fifo_wreq),
		.rd_en				(rd_fifo_rreq),
		.dout				(rd_fifo_rdata),
		.full				(rd_fifo_wfull),
		.empty				(rd_fifo_rempty)
	);
		
	ddr_wr_treat	wr_treat(

		.clk				(wr_fifo_wclk),
		.rst				(mig_rst),
		
		.ecm_din			(ecm_din),
		.ecm_din_en			(ecm_din_en),
		.si_din				(si_din),
		.si_din_en			(si_din_en),
		
		.wr_dout			(wr_dout),
		.wr_dout_en			(wr_dout_en)
    	);
	
	wr_fifo	wr_fifo(
		.rst				(mig_rst),
		.wr_clk				(wr_fifo_wclk),
		.rd_clk				(clk_user),
		.din				(wr_dout),
		.wr_en				(wr_dout_en),
		.rd_en				(wr_fifo_rreq),
		.dout				(wr_fifo_rdata),
		.full				(wr_fifo_wfull),
		.empty				(wr_fifo_rempty),
		.rd_data_count		(wr_fifo_rcnt)
		);
		

endmodule
