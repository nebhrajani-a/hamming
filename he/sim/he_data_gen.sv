//--------------------------------------------------------------------------------
// (c) 2022 OA
//
// Module Description: Data generator for Hamming Encoder SimEnv.
//
// $Author: nebu $
// $LastChangedDate: 2022-06-30 17:56:31 +0530 (Thu, 30 Jun 2022) $
// $Rev: 39 $
//--------------------------------------------------------------------------------

module he_data_gen
  (clk,
   rst,
   dout,
   dvld
   );

`include "/Users/aditya/summer_22/hamming/he/sim/he_params.v"
`include "/Users/aditya/summer_22/hamming/he/sim/he_timing_params.v"

  input                  clk;
  input                  rst;
  output reg             dvld;
  output reg [k - 1 : 0] dout;

  task HE_ALIGN_DATA_GEN;
    begin
      dvld = 1'b0;
      @(posedge clk);
      #(t_ck - t_s);
    end
  endtask

  task HE_DATA_GEN
    (input [k-1:0] data
    );
    begin
      // Set a flag in simulation environment that ensures
      // that a test won't pass until this function is called
      // at least one time. When called it sets a flag which
      // must be checked at sim termination.
      `ifdef SIMENV_INST
        `SIMENV_INST.data_gen_called = 1;
      `endif

      dvld = 1'b1;
      dout = data;
      @(posedge clk);
      #t_h;
      dout = {k{1'bx}};
      dvld = 1'b0;
      #(t_ck - t_h - t_s);

    end // initial begin
  endtask // HE_DATA_GEN


endmodule
