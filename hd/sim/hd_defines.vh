`define INIT_SIM `SIMENV_INST.INIT_SIM
`define SIM_END `SIMENV_INST.SIM_END
`define HE_DATA_GEN `SIMENV_INST.u7_data_gen.HE_DATA_GEN
`define HE_ALIGN_DATA_GEN `SIMENV_INST.u7_data_gen.HE_ALIGN_DATA_GEN

`ifdef DEBUG
  `define CONTINUE_ON_FAIL
  `define DUMP_ON
`endif
