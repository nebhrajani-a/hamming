//--------------------------------------------------------------------------------
// (c) 2022 OA
//
// Module Description: Top level module for Hamming Encoder.
//
// $Author: nebu $
// $LastChangedDate: 2022-06-30 17:56:31 +0530 (Thu, 30 Jun 2022) $
// $Rev: 39 $
//--------------------------------------------------------------------------------

module he_top
  (clk,
   rst,
   dvld,
   din,
   cvld,
   cout
   );

  parameter  K  = 8;
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

  input                         clk;
  input                         rst;
  input                         dvld;
  input [K - 1 : 0]             din;
  output                        cvld;
  output [K + M - 1 : 0]        cout;

  // module body
  reg [K-1:0]                   din_reg;
  reg                           dvld_reg;
  reg                           cvld;
  reg [K-1:0]                   cout_data;

  wire [M-1:0]                  cout_parity;

  //----------------------------------------------------------------------
  // Flop-ins
  //----------------------------------------------------------------------
  always @(posedge clk or negedge rst)
    if (rst == 1'b0)
      begin
        din_reg <= 'h0;
        dvld_reg <= 1'b0;
      end
    else
      begin
        din_reg <= din;
        dvld_reg <= dvld;
      end

  always @(posedge clk or negedge rst)
    begin
      if (rst == 1'b0)
        begin
          cout_data <=  'h0;
          cvld      <= 1'b0;
        end

      else
        begin
          // Assign the data bits
          cout_data <= din_reg;
          cvld      <= dvld_reg;

        end // else: !if(rst == 1'b0)
    end // always @ (posedge clk or negedge rst)

  assign cout = {cout_parity, cout_data};

  he_parity_gen
    #(.K(K),
      .M(M)
     ) u1_parity_gen
    (.rst(rst),
     .clk(clk),
     .din(din_reg),
     .parity(cout_parity)
     );


endmodule
