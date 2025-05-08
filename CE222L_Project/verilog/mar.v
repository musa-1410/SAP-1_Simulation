`timescale 1ns/1ps
module mar(
    input clk,
    input [3:0] addr_in,
    input mar_load,
    output reg [3:0] addr_out
);
always @(posedge clk) begin
    if (mar_load)
        addr_out <= addr_in;
end
endmodule