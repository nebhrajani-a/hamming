//--------------------------------------------------------------------------------
// (c) 2022 OA
//
// Description: Tasks for Hamming Encoder SimEnv.
//
// $Author: nebu $
// $LastChangedDate: 2022-06-30 17:56:31 +0530 (Thu, 30 Jun 2022) $
// $Rev: 39 $
//--------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Function Name:
// Arguments:
// Returns:
// Description:
//----------------------------------------------------------------------
function integer get_m;
  input integer  k;
  integer        m;

  begin
    // k <= 2^m - m - 1
    m = 1;
    while (2**m - m - 1 < k)
      begin
        m = m + 1;
      end
    get_m = m;
  end
endfunction // get_m


//----------------------------------------------------------------------
// Task Name:
// Arguments:
// Description:
//----------------------------------------------------------------------
task SIM_END;
  input string test_name;
  integer      fd;

  begin
    // wait for about 20 clocks
    #20000;

    if (`SIMENV_INST.data_chk_passing == 1 &&
        `SIMENV_INST.data_gen_called  == 1)
      begin
        $write("[PASS] %s ", test_name);
      end
    else
      begin
        $write("[FAIL] %s ", test_name);
      end
    $display("Error count: %0d", `SIMENV_INST.error_cnt);
    fd = $fopen("curr_logfile.log", "a");
    $fdisplay(fd, "Error count: %d", `SIMENV_INST.error_cnt);
    $fclose(fd);

    $finish;
  end

endtask // SIM_END


//----------------------------------------------------------------------
// Task Name:
// Arguments:
// Description:
//----------------------------------------------------------------------
task INIT_SIM;
  integer fd;
  
  begin
    `SIMENV_INST.exit_status = 0;
    
    `ifdef DUMP_ON
     $dumpvars;
     `endif
    
    fd = $fopen("curr_logfile.log", "w");
    $fclose(fd);

    // Wait for reset being applied and removed
    wait (tst_rst == 1'b0);
    wait (tst_rst == 1'b1);
  end

endtask // INIT_SIM
