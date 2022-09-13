#!/usr/bin/env python3

for length in range(4, 17):
    test_name = "he_exh_" + str(length)

    contents = '''\
//--------------------------------------------------------------------------------
// (c) 2022 OA
//
// Module Description: Test for {test_name}
//
// $Author$
// $LastChangedDate$
// $Rev$
//--------------------------------------------------------------------------------

`include "../sim/he_defines.vh"

module {test_name};

  //----------------------------------------------------------------------
  // Includes
  //----------------------------------------------------------------------
  `include "../sim/he_timing_params.v"

  //----------------------------------------------------------------------
  // Instantiates Simulation Environment
  //----------------------------------------------------------------------
  `define SIMENV_INST u1_he_simenv
  he_simenv `SIMENV_INST();

  parameter k              = {length};
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
      `SIM_END("{test_name}");

    end
endmodule
'''.format(test_name=test_name, length=length)

    filename = test_name + ".v"
    fptr = open(filename, "x")
    fptr.write(contents)
    fptr.close()
