//------------------------------------------------------------------------------
//----------------file:        pcr_cnt.v      ----------------------------------
//----------------module:      pcr_cnt        ----------------------------------
//----------------project:     pcr_correction     ------------------------------
//----------------platform:    xilinx 10.1.02     ------------------------------
//----------------simulator:   modelsim se plus 6.2i ---------------------------
//----------------author:      machenghai machenghai@126.com    ----------------
//----------------lastupdate:  2008/08/01         ------------------------------
//----------------description: count the pulses of the clk_27m to correct  ------
//-------------------------    pcr_base and pcr_ext in ts ----------------------
//------------------------------------------------------------------------------

module  pcr_cnt  (
    // input
    clk_main_a,
    clk_27m,
//    rst_gen,

    // output
    pcr_base_cnt,             //pcr_base_cnt and pcr_ext_cnt output all the time
    pcr_ext_cnt               // but we may not read them all the time
);
//------------------------------------------------------------------------------

    input           clk_main_a ;
    input           clk_27m ;
//    input           rst_gen ;

    output  [32:0]  pcr_base_cnt ;
    output  [ 8:0]  pcr_ext_cnt ;

//------------------------------------------------------------------------------

    wire            clk_main_a ;
    wire            clk_27m ;
//    wire            rst_gen ;

    reg     [32:0]  pcr_base_cnt ;
    reg     [ 8:0]  pcr_ext_cnt ;

    reg             clk_27m_buf1 ;
    reg             clk_27m_buf2 ;
    reg				clk_27m_buf3;
/*
    reg             pedg_clk_27m ;       //indicate positive edge of clk_27m comes
*/

//------------------------------- generate pedg_clk_27m -------------------------

    always @ ( posedge clk_main_a ) 
    begin
        clk_27m_buf1 	<= clk_27m ;
       	clk_27m_buf2 	<= clk_27m_buf1 ;
      	clk_27m_buf3	<= clk_27m_buf2;
	end
//----------------- counter used to correct pcr_base and pcr_ext ---------------

    always @ ( posedge clk_main_a )
    begin
        if ((!clk_27m_buf3) && (clk_27m_buf2)/*pedg_clk_27m*/) 
        begin
            if ( pcr_ext_cnt >= 9'd299 ) 
            begin
                pcr_base_cnt <= pcr_base_cnt + 1 ;
                pcr_ext_cnt  <= 9'd0 ;
            end
            else 
            begin
                pcr_ext_cnt <= pcr_ext_cnt + 1 ;
                pcr_base_cnt	<= pcr_base_cnt;
            end
        end
    end

//------------------------------------------------------------------------------

endmodule                               //of pcr_cnt