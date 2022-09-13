//--------------------------------------------------------------------------------
// (c) 2022 OA
//
// Module Description: Defines for Hamming Encoder.
//
// $Author: nebu $
// $LastChangedDate: 2022-06-28 21:39:53 +0530 (Tue, 28 Jun 2022) $
// $Rev: 28 $
//--------------------------------------------------------------------------------

`define SIM_END `SIMENV_INST.SIM_END
`define INIT_SIM `SIMENV_INST.INIT_SIM
`define HE_DATA_GEN `SIMENV_INST.u3_data_gen.HE_DATA_GEN
`define HE_ALIGN_DATA_GEN `SIMENV_INST.u3_data_gen.HE_ALIGN_DATA_GEN
`define GET_UNIX_TIME `SIMENV_INST.GET_UNIX_TIME

`ifdef DEBUG
  `define CONTINUE_ON_FAIL
  `define DUMP_ON
`endif
