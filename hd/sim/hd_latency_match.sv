//--------------------------------------------------------------------------------
// (c) 2022 OA
//
// Module Description: Latency Matcher for Hamming Encoder SimEnv
//
// $Author: nebu $
// $LastChangedDate: 2022-06-23 17:45:23 +0530 (Thu, 23 Jun 2022) $
// $Rev: 12 $
//--------------------------------------------------------------------------------


module hd_latency_match
  (clk,
   rst,
   din,
   dvld,
   qout,
   qvld
  );

  `include "/Users/aditya/summer_22/hamming/hd/sim/hd_params.v"
  `include "/Users/aditya/summer_22/hamming/hd/sim/hd_timing_params.v"

  input                    clk;
  input                    rst;
  input [k - 1 : 0]        din;
  input                    dvld;
  output [k - 1 : 0]       qout;
  output                   qvld;

  reg [k-1:0]              qout_shift[design_latency];
  reg [design_latency-1:0] qvld_shift;

  integer                  i;

  assign qout = qout_shift[0];
  assign qvld = qvld_shift[0];

  always @(posedge clk or negedge rst)
    if (rst == 1'b0)
      begin
        for (i = 0; i < design_latency; i = i + 1)
          begin
            qout_shift[i] <= 'h0;
          end
        qvld_shift    <= 'h0;
      end

    else
      begin
        for (i = 0; i < design_latency - 1; i = i + 1)
          begin
            qout_shift[i] <= qout_shift[i+1];
          end
        qout_shift[design_latency - 1] <= din;
        qvld_shift <= {dvld, qvld_shift[design_latency-1:1]};
      end

endmodule

//--------------------------------------------------------------------------------
// Module level test for hd_latency_match. Use +define+UNHIDE to run this test
// bench
//--------------------------------------------------------------------------------

`ifdef UNHIDE
module helm_test;

  hd_latency_match dut
    (.clk(clk),
     .rst(rst),
     .din(din),
     .dvld(dvld),
     .qout(qout),
     .qvld(qvld)
     );

  reg                    clk;
  reg                    rst;
  reg [7:0]              din;
  reg                    dvld;
  wire [7:0]             qout;
  wire                   qvld;

  //----------------------------------------------------------------------
  // Simulation Control
  //----------------------------------------------------------------------
  initial
    begin
      $dumpvars;
      #100;
      $finish;
    end

  //----------------------------------------------------------------------
  // Initializations
  //----------------------------------------------------------------------
  initial
    begin
      din = 'h0;
      dvld = 1'b0;
    end

  //----------------------------------------------------------------------
  // Clock generation
  //----------------------------------------------------------------------
  always
    begin
      clk = 0;
      #5;
      clk = 1;
      #5;
    end

  //----------------------------------------------------------------------
  // Reset
  //----------------------------------------------------------------------
  initial
    begin
      rst <= 0;
      @(posedge clk);
      @(posedge clk);
      rst <= 1;
    end

  always @(posedge clk)
    begin
      din <= din + 1'b1;
      dvld <= ~dvld;
    end

endmodule // helm_test
`endif
