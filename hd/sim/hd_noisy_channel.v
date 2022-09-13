
module hd_noisy_channel
  (cin,
   cout_err
  );

  `include "/Users/aditya/summer_22/hamming/hd/sim/hd_params.v"
  `include "/Users/aditya/summer_22/hamming/hd/sim/hd_timing_params.v"
  `include "../run/hd_noisy_heredoc.v"

  input  [k+m-1:0]  cin;
  output [k+m-1:0]  cout_err;

  reg [k+m-1:0]     cout_err;

  // params
  // num_errs: 0, 1, 2, or 3
  // error_mode 0 = random
  // error_mode 1 = fixed_bit_err


  integer           i;
  integer           idx;
  integer           seed;
  integer           trash;


  initial
    begin
      seed = heredoc_seed;
      trash = $urandom(seed);
    end

  always @(cin)
    begin
      cout_err = cin;
      if (num_errs != 0)
        begin
          if (error_mode == 0)
            begin
              for (i = 0; i < num_errs; i = i + 1)
                begin
                  idx = $urandom_range(0, k + m - 1);
                  cout_err[idx] = !(cout_err[idx]);
                end
            end
          else
            begin
              if (num_errs >= 1)
                begin
                  cout_err[err_pos_0] = !(cout_err[err_pos_0]);
                end
              if (num_errs >= 2)
                begin
                  cout_err[err_pos_1] = !(cout_err[err_pos_1]);
                end
              if (num_errs == 3)
                begin
                  cout_err[err_pos_2] = !(cout_err[err_pos_2]);
                end
            end
        end
    end

endmodule // hd_noisy_channel
