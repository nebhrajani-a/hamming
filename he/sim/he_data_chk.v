//--------------------------------------------------------------------------------
// (c) 2022 OA
//
// Module Description: Data checker module for Hamming Encoder SimEnv.
//
// $Author: nebu $
// $LastChangedDate: 2022-06-30 17:56:31 +0530 (Thu, 30 Jun 2022) $
// $Rev: 39 $
//--------------------------------------------------------------------------------

module he_data_chk

  (clk,
   rst,
   cin,     // received codeword
   cvld,    // vld for recd. cw
   din,     // latency matched reference data
   dvld     // vld for din
  );

  `include "/Users/aditya/summer_22/hamming/he/sim/he_params.v"
  `include "/Users/aditya/summer_22/hamming/he/sim/he_timing_params.v"

   input                 clk;
   input                 rst;
   input [k + m - 1 : 0] cin;
   input                cvld;
   input [k - 1 : 0]     din;
   input                dvld;

   reg [k + m - 1 : 0] recd_cw;
   reg [k + m - 1 : 0] comp_cw;

   always @(posedge clk or negedge rst)
     if (rst == 1'b0)
       begin
       end
     else
       begin
         // don't check at all if dvld is off?
         // since hammenc _must_ return some value that'll be c&red
          if (cvld == 1'b1 && dvld == 1'b1)
            begin
               recd_cw = cin;
               comp_cw = hammenc(din);
               candr(recd_cw, comp_cw, din);
            end
       end

   function [k+m-1:0] hammenc;
     input [k-1:0]  din;

     reg [m-1:0]    parity_bits;
     reg [k+m-1:0]  placed_data;
     integer        i;
     integer        j;

      begin
        parity_bits = 0;
        placed_data = 0;

         j = 0;
         for (i = 0; i < k+m; i = i + 1)
           if (2**$clog2(i + 1) != (i + 1))
             begin
                placed_data[i] = din[j];
                j = j + 1;
             end

        for (i = 0; i < m; i++)
          begin
            for (j = 0; j < k + m; j++)
              begin
                if ((2**(i) & (j + 1)))
                  begin
                    // issue! generates XOR lists instead of XOR trees in yosys
                    parity_bits[i] = parity_bits[i] ^ placed_data[j];
                  end
              end
          end

        hammenc = {parity_bits, din};

      end
   endfunction // hammenc

   task candr;

     input [k+m-1:0] rcw;
     input [k+m-1:0] ccw;
     input [k-1:0]   din;
     integer         fd;

      begin
         if (rcw !== ccw)
           begin
              // display and either set error flag or finish
             fd = $fopen("curr_logfile.log", "a");
             $fdisplay(fd, "Error: In %m, at time %t, in encoding %b: Expected %b, got %b", $time, din, ccw, rcw);
             `SIMENV_INST.data_chk_passing = 0;
             `SIMENV_INST.error_cnt++;
             -> `SIMENV_INST.error;

             `ifndef CONTINUE_ON_FAIL
                $display("Error count: %0d", `SIMENV_INST.error_cnt);
                $fdisplay(fd, "Error count: %d", `SIMENV_INST.error_cnt);
                $fclose(fd);
                $finish;
             `endif
             $fclose(fd);
           end
      end
   endtask // candr




endmodule
