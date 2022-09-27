
//--------------------------------------------------------------------------------
// (c) 2022 OA
//
// Module Description: Test for he_exh_6
//
// $Author: nebu $
// $LastChangedDate: 2022-06-26 19:31:47 +0530 (Sun, 26 Jun 2022) $
// $Rev: 24 $
//--------------------------------------------------------------------------------

`include "../sim/he_defines.vh"

module he_exh_6;

  //----------------------------------------------------------------------
  // Includes
  //----------------------------------------------------------------------
  `include "../sim/he_timing_params.v"

  //----------------------------------------------------------------------
  // Instantiates Simulation Environment
  //----------------------------------------------------------------------
  `define SIMENV_INST u1_he_simenv
  he_simenv `SIMENV_INST();

  parameter k              = 6;
  defparam  u1_he_simenv.k = k;

  //----------------------------------------------------------------------
  // Test body
  //----------------------------------------------------------------------

  // Local variable definitions
  integer i;

  initial
    begin
      // Initialize sim environment etc.
      `INIT_SIM();

      // Start with data generation; one call to align is required
      // followed by a loop to call HE_DATA_GEN.
      `HE_ALIGN_DATA_GEN();

      for (i = 0; i < 2**k; i = i + 1)
        begin
          `HE_DATA_GEN(i[k-1:0]);
        end

      // Call SIM_END task to properly terminate test.
      `SIM_END("he_exh_6");

    end
endmodule
