import sys
import os
import shutil
import re
import random
import datetime
import argparse


def argument_parser(desc):
    parser = argparse.ArgumentParser(description=desc)
    parser.add_argument('--debug',
                        action='store_true',
                        help='Turn +define+DEBUG on for SimEnv.')
    parser.add_argument(
        '--dump-on',
        action='store_true',
        help='Enables +define+DUMP_ON for SimEnv, creates VCD for each test.')
    parser.add_argument('--cont-fail',
                        action='store_true',
                        help='Continue after finding one error.\
        Turns +define+CONTINUE_ON_FAIL on in the SimEnv.')
    if "single" in desc:
        parser.add_argument('test_name', type=str, help='Name of the test')
    return parser.parse_args()


def run(directory, test, test_name, args):
    flags = " "
    if args.debug:
        flags += " -DDEBUG "
    if args.dump_on:
        flags += " -DDUMP_ON "
    if args.cont_fail:
        flags += " -DCONTINUE_ON_FAIL "

    cmd = "iverilog -g2005-sv" + flags + "../tests/" + test + " ../sim/he_simenv.v\
    ../sim/he_clk_rst_ctrl.v ../sim/he_data_gen.v ../sim/he_data_chk.v\
    ../sim/he_latency_match.v ../rtl/he_top.v ../rtl/he_parity_gen.v && ./a.out"

    os.system(cmd)
    place_logfile(directory, test_name, args)


def check_and_rm(filename_list):
    for filename in filename_list:
        if os.path.exists(filename):
            os.remove(filename)


def make_heredoc(test_name, s: set, gen_heredoc_k: False):
    heredoc_seed = random.randrange(2**32)
    contents = "localparam heredoc_seed = " + str(heredoc_seed) + ";\n"
    if gen_heredoc_k:
        rng = tuple(map(int, re.findall('\d+', test_name)))
        while True:
            heredoc_k = random.randint(rng[0], rng[1])
            if heredoc_k not in s:
                break
        s.add(heredoc_k)
        contents += "localparam heredoc_k = " + str(heredoc_k) + ";\n"
        test_name = test_name[:-2]
        test_name = test_name + "_" + str(heredoc_k)
    fptr = open("he_rand_heredoc.v", "w")
    fptr.write(contents)
    fptr.close()
    return test_name


def make_log_dir():
    directory = "run-" + datetime.datetime.now().astimezone().strftime(
        "%Y-%m-%d-%H:%M:%S%z")
    if not os.path.exists(directory):
        os.makedirs(directory)
        return directory + '/'
    sys.exit(1)


def place_logfile(directory, test, args):
    shutil.move('curr_logfile.log', directory + test + '.log')
    if args.debug or args.dump_on:
        shutil.move('dump.vcd', directory + test + '_dump.vcd')
