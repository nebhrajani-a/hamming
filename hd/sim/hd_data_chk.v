
module hd_data_chk
  (clk,
   rst,
   din,
   dvld,
   din_d,
   dvld_d
   );

  `include "/Users/aditya/summer_22/hamming/hd/sim/hd_params.v"
  `include "/Users/aditya/summer_22/hamming/hd/sim/hd_timing_params.v"

  input         rst;
  input         clk;
  input [k-1:0] din;
  input         dvld;
  input [k-1:0] din_d;
  input         dvld_d;

   always @(posedge clk or negedge rst)
     if (rst == 1'b0)
       begin
       end
     else
       begin
          if (dvld == 1'b1 && dvld_d == 1'b1)
            begin
              candr(din_d, din);
            end
       end // else: !if(rst == 1'b0)


   task candr;

     input [k-1:0]   data_d;
     input [k-1:0]   dec;
     integer         fd;

      begin
         `ifdef DISPLAY_FOR_FUN
            $display("From he_data_gen: %b, from decoder: %b", data_d, dec);
         `endif
         if (data_d !== dec)
           begin
              // display and either set error flag or finish
             fd = $fopen("curr_logfile.log", "a");
             $fdisplay(fd, "Error: In %m, at time %0t, expected %b, got %b", $time, data_d, dec);
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



endmodule // hd_data_chk
