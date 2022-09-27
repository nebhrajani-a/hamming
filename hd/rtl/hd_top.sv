module hd_top
  (clk,
   rst,
   cin,
   cvld,
   dout,
   dvld
   );

  parameter K = 8;
  localparam M = (K ==    1)  ?  2 :
                 (K <=    4)  ?  3 :
                 (K <=   11)  ?  4 :
                 (K <=   26)  ?  5 :
                 (K <=   57)  ?  6 :
                 (K <=  120)  ?  7 :
                 (K <=  247)  ?  8 :
                 (K <=  502)  ?  9 :
                 (K <= 1013)  ? 10 :
                 11;

  input                clk;
  input                rst;
  input [K+M-1:0]      cin;
  input                cvld;
  output [K-1:0]       dout;
  output               dvld;

  reg [K+M-1:0]        cin_reg;  // flopin
  reg                  cvld_reg; // flopin
  reg [K+M-1:0]        cin_d1;   // pipe stage
  reg [K+M-1:0]        cin_d2;   // pipe stage
  reg                  cvld_d1;  // pipe stage
  reg                  cvld_d2;  // pipe stage
  reg [K+M-1:0]        ep_reg;
  reg [K-1:0]          dout;
  reg                  dvld;

  wire [M-1:0]         cparity;  // computed parity
  wire [M-1:0]         rparity;  // received parity
  wire [M-1:0]         synd;     // syndrome


  // local vars
  integer              i;
  integer              offset;

  //----------------------------------------------------------------------
  // Flopins
  //----------------------------------------------------------------------
  always @(posedge clk or negedge rst)
    begin
      if (rst == 1'b0)
        begin
          cin_reg  <=  'h0;
          cvld_reg <= 1'b0;
        end
      else
        begin
          cin_reg  <= cin;
          cvld_reg <= cvld;
        end
    end // always @ (posedge clk or negedge rst)

  //----------------------------------------------------------------------
  // Data pipeline
  //----------------------------------------------------------------------
  always @(posedge clk or negedge rst)
    begin
      if (rst == 1'b0)
        begin
          cin_d1 <= 'h0;
          cin_d2 <= 'h0;
          cvld_d1 <= 1'b0;
          cvld_d2 <= 1'b0;
        end
      else
        begin
          cin_d1 <= cin_reg;
          cin_d2 <= cin_d1;
          cvld_d1 <= cvld_reg;
          cvld_d2 <= cvld_d1;
        end
    end // always @ (posedge clk or negedge rst)


  //----------------------------------------------------------------------
  // Final data correction and output
  //----------------------------------------------------------------------
  always @(posedge clk or negedge rst)
    begin
      if (rst == 1'b0)
        begin
          dout <= 'h0;
        end
      else
        begin
          dout <= (ep_reg ^ cin_d2);
          dvld <= cvld_d2;
        end
    end // always @ (posedge clk or negedge rst)


  he_parity_gen
    #(.K(K),
      .M(M)
      ) u1_parity_gen
      (.rst(rst),
       .clk(clk),
       .din(cin_reg[K-1:0]),
       .parity(cparity)
       );


  assign rparity = cin_d1[K+M-1:K];
  assign synd    = rparity ^ cparity;

  always @(posedge clk or negedge rst)
    begin
      if (rst == 1'b0)
        begin
          ep_reg <= 'h0;
        end
      else
        begin
          ep_reg <= 'h0;
          if (|synd)
            begin
              if ((synd & (synd - 1)) != 0) // check that synd is NOT a power of 2
                begin
                  offset = 0;
                  for (i = 0; i < synd; i = i + 1)
                    begin
                      if ($countones(i) == 1)
                      // if ((i & (i - 1)) == 0) // check if i is power of 2
                        begin
                          offset = offset + 1;
                        end
                    end
                  ep_reg[synd - offset - 1] <= 1'b1;
                end // if ((synd & (synd - 1)) != 0)
            end // if (|synd)
        end
    end // always @ (posedge clk or negedge rst)

endmodule
