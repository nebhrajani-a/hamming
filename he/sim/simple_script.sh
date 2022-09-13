#!/bin/zsh

for item in `ls ../tests | sort -V`
do
    iverilog -g2005-sv ../tests/$item he_simenv.v he_clk_rst_ctrl.v he_data_gen.v he_data_chk.v he_latency_match.v ../rtl/he_top.v && ./a.out
done
