//--------------------------------------------------------------------------------
// (c) 2022 OA
//
// Module Description: Demo for Hamming encoder.
//
// $Author$
// $LastChangedDate$
// $Rev$
//--------------------------------------------------------------------------------

`include "../sim/he_defines.vh"

module he_demo;

  //----------------------------------------------------------------------
  // Includes
  //----------------------------------------------------------------------
  `include "./h_demo_params.v"

  localparam k = 7;
  localparam m = 4;

  //----------------------------------------------------------------------
  // Local variables and instances
  //----------------------------------------------------------------------

  reg [k-1:0]           chars [0:LEN-1];
  integer               i;
  integer               ctr;
  integer               fd;

  wire                  tst_clk;
  wire                  tst_rst;
  wire [k - 1 : 0]      tst_din;
  wire                  tst_dvld;
  wire [k + m - 1 : 0]  tst_cout;
  wire                  tst_cvld;

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

  //----------------------------------------------------------------------
  // Demo
  //----------------------------------------------------------------------

  initial
    begin
      $readmemh("enc_test_vectors.txt", chars);
      ctr = 0;
      fd = $fopen("encoder_output.txt", "w");

      wait (tst_rst == 1'b0);
      wait (tst_rst == 1'b1);
      u3_data_gen.HE_ALIGN_DATA_GEN();
      for (i = 0; i < LEN; i = i + 1)
        begin
          u3_data_gen.HE_DATA_GEN(chars[i][k-1:0]);
        end
    end

  always @(posedge tst_clk)
    begin
      if (tst_cout !== {k+m{1'bx}} && tst_cvld === 1'b1)
        begin
          $fdisplay(fd, "%b", tst_cout);
          ctr++;
        end
      if (ctr == LEN)
        $finish;
    end

endmodule
