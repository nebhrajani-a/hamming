module he_parity_gen
  (rst,
   clk,
   din,
   parity
   );

  parameter K = 4;
  parameter M = 3;


  input                         clk;
  input                         rst;
  input  [K - 1 : 0]            din;
  output [M - 1 : 0]            parity;

  reg    [M - 1 : 0]             parity;

  // local vars
  integer                       i;
  integer                       j;
  integer                       tj;
  integer                       offset;

  always @(posedge clk or negedge rst)
    begin
      if (rst == 1'b0)
        begin
          parity <= 'h0;
        end

      else
        begin
          for (i = 0; i < M; i = i + 1)
            begin
              offset = 2;
              parity[i] = 1'b0;

              // Index from 3 to K+M+1
              for (j = 3; j < K + M + 1; j = j + 1)
                begin
                  if ((j & (j - 1)) === 32'd0) // Check that j is a power of 2
                    begin
                      offset = offset + 1;
                    end
                  else
                    begin
                      if ((j[i] == 1'b1))
                        begin
                          tj = j - offset - 1;
                          parity[i] = parity[i] ^ din[tj];
                        end
                    end
                end
            end // for (i = 0; i < M; i = i + 1)
        end // else: !if(rst == 1'b0)
    end // always @ (posedge clk or negedge rst)

endmodule // he_parity_gen
