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

module hd_demo;

  //----------------------------------------------------------------------
  // Includes
  //----------------------------------------------------------------------
  `include "./h_demo_params.v"
  `include "../sim/he_timing_params.v"

  localparam k = 7;
  localparam m = 4;

  //----------------------------------------------------------------------
  // Local variables and instances
  //----------------------------------------------------------------------

  reg [k+m-1:0]           enc_chars [0:LEN-1];
  integer                 i;
  integer                 ctr;
  integer                 fd;

  wire                    tst_clk;
  wire                    tst_rst;
  wire [k - 1 : 0]        tst_dout;
  wire                    tst_dvld;
  reg [k + m - 1 : 0]     tst_cin;
  reg                     tst_cvld;

  hd_top #(k) u1_dut
    (.clk(tst_clk),
     .rst(tst_rst),
     .cin(tst_cin),
     .cvld(tst_cvld),
     .dout(tst_dout),
     .dvld(tst_dvld)
    );

  he_clk_rst_ctrl u2_clk_rst_ctrl
    (.clkout(tst_clk),
     .rstout(tst_rst)
    );


  //----------------------------------------------------------------------
  // Demo
  //----------------------------------------------------------------------
 initial
    begin
      $readmemh("dec_test_vectors.txt", enc_chars);
      ctr = 0;
      fd = $fopen("decoder_output.txt", "w");

      wait (tst_rst == 1'b0);
      wait (tst_rst == 1'b1);

      HD_ALIGN_DATA_GEN();
      for (i = 0; i < LEN; i = i + 1)
        begin
          HD_DATA_GEN(enc_chars[i][k+m-1:0]);
        end
    end

  always @(posedge tst_clk)
    begin
      if (tst_dout !== {k{1'bx}} && tst_dvld === 1'b1)
        begin
          $fdisplay(fd, "%b", tst_dout);
          ctr++;
        end
      if (ctr == LEN)
        $finish;
    end


  task HD_ALIGN_DATA_GEN;
    begin
      @(posedge tst_clk);
      #(t_ck - t_s);
    end
  endtask

  task HD_DATA_GEN
    (input [k+m-1:0] data
    );
    begin
      if (!tst_rst)
        begin
          tst_cvld = 1'b0;
          tst_cin = {k+m{1'bx}};
        end
      else
        begin
          tst_cvld = 1'b1;
          tst_cin = data;
          @(posedge tst_clk);
          #t_h;
          tst_cin = {k+m{1'bx}};
          tst_cvld = 1'b0;
          #(t_ck - t_h - t_s);
        end // else: !if(!tst_rst)

    end // initial begin
  endtask // HE_DATA_GEN


endmodule
