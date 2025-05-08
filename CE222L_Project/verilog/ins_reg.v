`timescale 1ns/1ps
module ins_reg(
    input clk,
    input [7:0] instr_in,
    input ir_load,
    output reg [3:0] opcode,  // Correct 4-bit width
    output reg [3:0] operand   // Correct 4-bit width
);

initial begin
    opcode = 4'b0;
    operand = 4'b0;
end

always @(posedge clk) begin
    if (ir_load) begin
        opcode <= instr_in[7:4];
        operand <= instr_in[3:0];
    end
end
endmodule