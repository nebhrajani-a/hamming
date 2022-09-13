#!/usr/bin/env python3

import sys

num_errs = 1
if len(sys.argv) > 1:
    num_errs = sys.argv[1]


for length in range(4, 17):
    test_name = "hd_exh_" + str(length)

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

`include "../sim/hd_defines.vh"

module {test_name};

  //----------------------------------------------------------------------
  // Instantiates Simulation Environment
  //----------------------------------------------------------------------
  `define SIMENV_INST u1_hd_simenv
  hd_simenv `SIMENV_INST();

  parameter k              = {length};
  defparam  `SIMENV_INST.k = k;

  // for noisy channel
  defparam  `SIMENV_INST.num_errs   = {num_errs};

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
'''.format(test_name=test_name, length=length, num_errs=num_errs)

    filename = test_name + ".v"
    fptr = open(filename, "x")
    fptr.write(contents)
    fptr.close()
