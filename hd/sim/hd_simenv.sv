//--------------------------------------------------------------------------------
// (c) 2022 OA
//
// Module Description: Top level SimEnv for Hamming Decoder.
//
// $Author: nebu $
// $LastChangedDate: 2022-06-28 21:39:53 +0530 (Tue, 28 Jun 2022) $
// $Rev: 28 $
//--------------------------------------------------------------------------------


module hd_simenv;
  `include "/Users/aditya/summer_22/hamming/hd/sim/hd_params.v"
  `include "/Users/aditya/summer_22/hamming/hd/sim/hd_timing_params.v"

   defparam `SIMENV_INST.m = get_m(k);

   wire                 tst_clk;
   wire                 tst_rst;
   wire [k - 1 : 0]     tst_din;       // input to encoder
   wire                 tst_din_vld;   // vld for ^
   wire [k + m - 1 : 0] tst_cout;      // output from encoder
   wire                 tst_cvld;      // vld for ^
   wire [k + m - 1 : 0] tst_cout_err;  // output from noisy
   wire [k - 1 : 0]     tst_dout;      // output from decoder
   wire                 tst_dout_vld;  // vld for ^
   wire [k - 1 : 0]     tst_din_d;     // output from latency
   wire                 tst_din_vld_d; // vld for ^

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

  hd_top #(k) u1_dut
    (.clk(tst_clk),
     .rst(tst_rst),
     .cin(tst_cout_err),
     .cvld(tst_cvld),
     .dout(tst_dout),
     .dvld(tst_dout_vld)
    );


  he_top #(k) u2_he_top
    (.clk(tst_clk),
     .rst(tst_rst),
     .din(tst_din),
     .dvld(tst_din_vld),
     .cout(tst_cout),
     .cvld(tst_cvld)
    );

  hd_clk_rst_ctrl u3_clk_rst_ctrl
    (.clkout(tst_clk),
     .rstout(tst_rst)
    );

   hd_data_chk
     #(.k(k),
       .m(m)
      ) u4_data_chk
     (.clk(tst_clk),
      .rst(tst_rst),
      .din(tst_dout),
      .dvld(tst_dout_vld),
      .din_d(tst_din_d),
      .dvld_d(tst_din_vld_d)
     );

   hd_latency_match
     #(.k(k),
       .m(m)
      ) u5_latency_match
     (.clk(tst_clk),
      .rst(tst_rst),
      .din(tst_din),
      .dvld(tst_din_vld),
      .qout(tst_din_d),
      .qvld(tst_din_vld_d)
     );

  hd_noisy_channel
    #(.k(k),
      .m(m),
      .num_errs(num_errs)
      ) u6_noisy_channel
     (.cin(tst_cout),
      .cout_err(tst_cout_err)
     );

  he_data_gen
    #(.k(k),
      .m(m)
      ) u7_data_gen
     (.rst(tst_rst),
      .clk(tst_clk),
      .dout(tst_din),
      .dvld(tst_din_vld)
     );

  `include "/Users/aditya/summer_22/hamming/hd/sim/hd_simtasks.v"

endmodule // hd_simenv
