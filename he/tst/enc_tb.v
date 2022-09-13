module tstbench;
    reg [3:0] inp;
    reg tstclk;
    reg tstrst;
    reg tstdin_val;
    wire [6:0] out;
    enc #(4) dut(.clk(tstclk),
                                .rst(tstrst),
                                .din(inp),
                                .din_val(tstdin_val),
                                .eout(out));
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
        inp <= 4'b0000;
        tstrst <= 1'b0;
        #2;
        tstrst <= 1'b1;
        inp <= 4'b0000;
        tstdin_val <= 1'b1;
        #2;
        inp <= 4'b0001;
        #2;
        inp <= 4'b0010;
        #2;
        inp <= 4'b0011;
        #2;
        inp <= 4'b0100;
        #2;
        inp <= 4'b0101;
        #2;
        inp <= 4'b0110;
        #2;
        inp <= 4'b0111;
        #2;
        inp <= 4'b1000;
        #2;
        inp <= 4'b1001;
        #2;
        inp <= 4'b1010;
        #2;
        inp <= 4'b1011;
        #2;
        inp <= 4'b1100;
        #2;
        inp <= 4'b1101;
        #2;
        inp <= 4'b1110;
        #2;
        inp <= 4'b1111;
        #2;
        $finish;
    end
endmodule
