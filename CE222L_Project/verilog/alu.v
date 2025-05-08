`timescale 1ns/1ps  
module alu(  
    input [7:0] a,  
    input [7:0] b,  
    input [2:0] op,  
    output reg [7:0] result  
);  

always @(*) begin  
    case(op)  
        3'b000: result = a + b;    // ADD  
        3'b001: result = a - b;    // SUB  
        3'b010: result = a & b;    // AND  
        3'b011: result = a | b;    // OR  
        3'b100: result = a ^ b;    // XOR  
        default: result = a;       // Pass through  
    endcase  
end  

endmodule