
module tstbench;
    reg [6:0] inp;
    reg tstclk;
    reg tstrst;
    reg tstein_val;
    wire tstdout_val;
    wire [3:0] out;

    dec #(4) dut(.clk(tstclk),
                 .rst(tstrst),
                 .ein(inp),
                 .ein_val(tstein_val),
                 .dout(out),
                 .dout_val(tstdout_val));

    always
    begin
        tstclk <= 1;
        #1;
        tstclk <= 0;
        #1;
    end

    initial
    begin
        $dumpvars;
        inp <= 7'b0000000;
        tstrst <= 1'b0;
        #2;
        tstrst <= 1'b1;
        tstein_val <= 1'b1;
        inp <= 7'b0000001;
        #2;
        inp <= 7'b1000111;
        #2;
        inp <= 7'b0011001;
        #2;
        inp <= 7'b0011110;
        #2;
        inp <= 7'b0101010;
        #2;
        inp <= 7'b0111101;
        #2;
        inp <= 7'b0010011;
        #2;
        inp <= 7'b0010100;
        #2;
        inp <= 7'b1000011;
        #2;
        inp <= 7'b1001100;
        #2;
        inp <= 7'b1010010;
        #2;
        inp <= 7'b1010001;
        #2;
        inp <= 7'b1000001;
        #2;
        inp <= 7'b0100110;
        #2;
        inp <= 7'b1101000;
        #2;
        inp <= 7'b1011111;
        #2;
        $finish;
    end
endmodule
