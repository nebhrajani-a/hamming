#!/bin/zsh

for item in `ls ../tests | sort -V`
do
    iverilog -g2005-sv ../tests/$item ../sim/hd_simenv.v ../rtl/hd_top.v ../sim/hd_clk_rst_ctrl.v ../sim/hd_latency_match.v ../../he/rtl/he_top.v ../../he/rtl/he_parity_gen.v ../sim/hd_data_chk.v ../sim/hd_noisy_channel.v ../../he/sim/he_data_gen.v && ./a.out
done
