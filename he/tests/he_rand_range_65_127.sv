//--------------------------------------------------------------------------------
// (c) 2022 OA
//
// Module Description: Test for he_rand_range_65_127
//
// $Author: nebu $
// $LastChangedDate: 2022-06-27 20:13:10 +0530 (Mon, 27 Jun 2022) $
// $Rev: 25 $
//--------------------------------------------------------------------------------

`include "../sim/he_defines.vh"

module he_rand_range_65_127;

  //----------------------------------------------------------------------
  // Includes
  //----------------------------------------------------------------------
  `include "../sim/he_timing_params.v"
  `include "../run/he_rand_heredoc.v"
  //----------------------------------------------------------------------
  // Instantiates Simulation Environment
  //----------------------------------------------------------------------
  `define SIMENV_INST u1_he_simenv
  he_simenv `SIMENV_INST();

  parameter k              = heredoc_k;
  defparam  u1_he_simenv.k = k;

  //----------------------------------------------------------------------
  // Test body
  //----------------------------------------------------------------------

  // Local variable definitions
  integer i;
  integer pack_ctr;
  integer seed;
  localparam rem = k % 32;
  localparam muls = k / 32;

  reg [k-1:0] curr_data;

  // integer to hold unused return values to silence warnings
  integer trash;


  initial
    begin
     // Initialize sim environment etc.
      `INIT_SIM();

      seed = heredoc_seed;
      // initialize prng
      trash = $urandom(seed);

      // Start with data generation; one call to align is required
      // followed by a loop to call HE_DATA_GEN.
      `HE_ALIGN_DATA_GEN();

      for (i = 0; i < 100; i = i + 1)
        begin
          for (pack_ctr = 0; pack_ctr < muls; pack_ctr = pack_ctr + 1)
            begin
              curr_data[(pack_ctr + 1)*32 - 1 -: 32] = $urandom();
            end
          if (rem != 0)
            begin
              curr_data[k-1 -: rem]  = $urandom();
            end
          `HE_DATA_GEN(curr_data[k-1:0]);
        end

      // Call SIM_END task to properly terminate test.
      `SIM_END("he_rand_range_65_127");

    end
endmodule

