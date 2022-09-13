#!/usr/bin/env python3

import sys

num_errs = 1
if len(sys.argv) > 1:
    num_errs = sys.argv[1]

t = [(17, 31), (33, 63), (65, 127), (128, 255), (256, 511), (512, 1024),
     (32, 32), (64, 64)]

for start_range, end_range in t:
    if (start_range == end_range):
        test_name = "hd_rand_" + str(start_range)
    else:
        test_name = "hd_rand_range_" + str(start_range) + "_" + str(end_range)

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
  // Includes
  //----------------------------------------------------------------------
  `include "../run/hd_rand_heredoc.v"

  //----------------------------------------------------------------------
  // Instantiates Simulation Environment
  //----------------------------------------------------------------------
  `define SIMENV_INST u1_hd_simenv
  hd_simenv `SIMENV_INST();

  parameter k              = heredoc_k;
  defparam  u1_hd_simenv.k = k;

  // params for noisy channel
  defparam  `SIMENV_INST.num_errs   = {num_errs};

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
      `SIM_END("{test_name}");

    end
endmodule
'''.format(test_name=test_name, num_errs=num_errs)

    if (start_range == end_range):
        contents = contents.replace("heredoc_k", str(start_range))

    filename = test_name + ".v"
    fptr = open(filename, "x")
    fptr.write(contents)
    fptr.close()
