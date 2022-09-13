//--------------------------------------------------------------------------------
// (c) 2022 OA
//
// Module Description: Top level SimEnv for Hamming Encoder.
//
// $Author: nebu $
// $LastChangedDate: 2022-06-28 21:39:53 +0530 (Tue, 28 Jun 2022) $
// $Rev: 28 $
//--------------------------------------------------------------------------------


module he_simenv;
  `include "/Users/aditya/summer_22/hamming/he/sim/he_params.v"
  `include "/Users/aditya/summer_22/hamming/he/sim/he_timing_params.v"

   defparam `SIMENV_INST.m = get_m(k);

   wire                 tst_clk;
   wire			tst_rst;
   wire [k - 1 : 0]	tst_din;
   wire			tst_dvld;
   wire [k + m - 1 : 0]	tst_cout;
   wire			tst_cvld;
   wire [k - 1 : 0]	tst_din_d;
   wire			tst_dvld_d;

  //----------------------------------------------------------------------
  // Global variables for simulation environment
  //----------------------------------------------------------------------
  integer               exit_status = 0;
  integer               data_chk_passing = 1;
  integer               data_gen_called = 0;
  integer               error_cnt = 0;

  event                 error;

  //----------------------------------------------------------------------
  // Instantiations
  //----------------------------------------------------------------------

  he_top #(k) u1_dut
    (.clk(tst_clk),
     .rst(tst_rst),
     .din(tst_din),
     .dvld(tst_dvld),
     .cout(tst_cout),
     .cvld(tst_cvld)
    );

  he_clk_rst_ctrl u2_clk_rst_ctrl
    (.clkout(tst_clk),
     .rstout(tst_rst)
    );

  he_data_gen
    #(.k(k),
      .m(m)
     ) u3_data_gen
    (.clk(tst_clk),
     .rst(tst_rst),
     .dout(tst_din),
     .dvld(tst_dvld)
    );

   he_data_chk
     #(.k(k),
       .m(m)
      ) u4_data_chk
     (.clk(tst_clk),
      .rst(tst_rst),
      .cin(tst_cout),
      .cvld(tst_cvld),
      .din(tst_din_d),
      .dvld(tst_dvld_d)
     );

   he_latency_match
     #(.k(k),
       .m(m)
      ) u5_latency_match
     (.clk(tst_clk),
      .rst(tst_rst),
      .din(tst_din),
      .dvld(tst_dvld),
      .qout(tst_din_d),
      .qvld(tst_dvld_d)
     );

  `include "/Users/aditya/summer_22/hamming/he/sim/he_simtasks.v"

endmodule // he_simenv
