//--------------------------------------------------------------------------------
// (c) 2022 OA
//
// Module Description: Top level SimEnv for Hamming Encoder.
//
// $Author: nebu $
// $LastChangedDate: 2022-06-26 18:45:18 +0530 (Sun, 26 Jun 2022) $
// $Rev: 21 $
//--------------------------------------------------------------------------------


module he_clk_rst_ctrl
  (output clkout,
   output rstout
  );

  reg     clkout;
  reg     rstout;

  `include "/Users/aditya/summer_22/hamming/he/sim/he_params.v"
  `include "/Users/aditya/summer_22/hamming/he/sim/he_timing_params.v"

  localparam on_time        = t_ck * duty_cycle;
  localparam off_time       = t_ck - on_time;

  integer     i;

  //----------------------------------------------------------------------
  // Active low rst for 4 clocks
  //----------------------------------------------------------------------
  initial
    begin
      rstout <= 1'b0;

      for (i = 1; i < 5; i = i + 1)
        begin
          @(posedge clkout);
        end

      #t_cq; // equivalent of reset removal time
       
      rstout <= 1'b1;
    end // initial begin

  //----------------------------------------------------------------------
  // Generate clock
  //----------------------------------------------------------------------
  always
    begin
      clkout = 0;
      #off_time;
      clkout = 1;
      #on_time;
    end

endmodule // he_clk_rst_ctrl
