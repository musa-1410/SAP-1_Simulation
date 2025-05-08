`timescale 1ns/1ps  
module memory(  
    input clk,  
    input [3:0] addr,  
    input mem_read,  
    input mem_write,  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  

reg [7:0] mem [0:15]; // 16 x 8-bit memory  

// Initialize data_out to prevent X values
initial begin
    data_out = 8'h00;
end

always @(posedge clk) begin  
    if (mem_write) 
        mem[addr] <= data_in;
    if (mem_read) 
        data_out <= mem[addr];  
end  

initial begin  
    // Instructions  
    mem[0] = 8'b0000_1010; // LDA [0Ah]  
    mem[1] = 8'b0001_1011; // ADD [0Bh]  
    mem[2] = 8'b0010_1100; // SUB [0Ch]  
    mem[3] = 8'b0011_1101; // AND [0Dh]  
    mem[4] = 8'b0100_1110; // OR  [0Eh]  
    mem[5] = 8'b0101_1111; // XOR [0Fh]  
    mem[6] = 8'b0110_1000; // JMP [08h]  
    mem[7] = 8'b0111_0000; // JZ  [00h]  
    mem[8] = 8'b1110_0000; // OUT  
    mem[9] = 8'b1111_0000; // HLT  

    // Data - Use correct hex indices
    mem[10] = 8'h0A; // 0Ah = 10  
    mem[11] = 8'h05; // 0Bh = 5
    mem[12] = 8'h03; // 0Ch = 3
    mem[13] = 8'h0C; // 0Dh = 12
    mem[14] = 8'h03; // 0Eh = 3
    mem[15] = 8'h05; // 0Fh = 5
end
endmodule