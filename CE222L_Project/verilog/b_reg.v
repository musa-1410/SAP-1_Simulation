module b_reg(
    input clk,
    input [7:0] data_in,
    input b_load,
    output reg [7:0] data_out
);

initial data_out = 8'h00;

always @(posedge clk) begin
    if (b_load)
        data_out <= data_in;  // Load data when b_load=1
end
endmodule