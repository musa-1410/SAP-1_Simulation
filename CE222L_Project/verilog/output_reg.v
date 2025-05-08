`timescale 1ns/1ps
module output_reg(
    input clk,
    input [7:0] data_in,
    input out_load,
    output reg [7:0] data_out
);
always @(posedge clk) begin
    if (out_load)
        data_out <= data_in;
end
endmodule