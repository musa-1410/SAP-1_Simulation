`timescale 1ns/1ps  
module accumulator(  
    input clk,  
    input [7:0] data_in,  
    input acc_load,  
    output reg [7:0] acc_out,  
    output zero_flag  
);  

// Initialize to prevent X values in simulation
initial begin
    acc_out = 8'h00;
end

assign zero_flag = (acc_out == 8'b0);  

always @(posedge clk) begin  
    if (acc_load) 
        acc_out <= data_in;  
end

endmodule