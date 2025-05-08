`timescale 1ns/1ps  
module program_counter(  
    input clk,  
    input reset,  
    input [3:0] jmp_addr,  
    input pc_inc,  
    input pc_jmp,  
    output reg [3:0] pc_out  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) pc_out <= 4'b0;  
    else if (pc_jmp) pc_out <= jmp_addr;  
    else if (pc_inc) pc_out <= pc_out + 1;  
end  

endmodule