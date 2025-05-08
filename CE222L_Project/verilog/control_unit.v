module control_unit(
    input clk,
    input reset,
    input [3:0] opcode,
    input zero_flag,
    output reg pc_inc,
    output reg pc_jmp,
    output reg mem_read,
    output reg acc_load,
    output reg b_load,
    output reg [2:0] alu_op,
    output reg out_load,
    output [1:0] state  // Expose current state for debugging
);

parameter FETCH = 2'b00, DECODE = 2'b01, EXECUTE = 2'b10;
reg [1:0] current_state, next_state;

// Sequential state transition
always @(posedge clk or posedge reset) begin
    if (reset) current_state <= FETCH;
    else current_state <= next_state;
end

// Combinational output and next state logic
always @(*) begin
    // Default values
    pc_inc = 1'b0;
    pc_jmp = 1'b0;
    mem_read = 1'b0;
    acc_load = 1'b0;
    b_load = 1'b0;
    alu_op = 3'b000;
    out_load = 1'b0;
    next_state = current_state;

    case(current_state)
        FETCH: begin
            mem_read = 1'b1;
            next_state = DECODE;
        end
        
        DECODE: begin
            next_state = EXECUTE;
        end
        
        EXECUTE: begin
            case(opcode)
                4'b0000: begin // LDA
                    mem_read = 1'b1;
                    acc_load = 1'b1;
                    pc_inc = 1'b1;
                end
                
                4'b0001: begin // ADD
                    mem_read = 1'b1;
                    b_load = 1'b1;
                    alu_op = 3'b000;
                    acc_load = 1'b1;
                    pc_inc = 1'b1;
                end
                
                4'b0010: begin // SUB
                    mem_read = 1'b1;
                    b_load = 1'b1;
                    alu_op = 3'b001;
                    acc_load = 1'b1;
                    pc_inc = 1'b1;
                end
                
                4'b0011: begin // AND
                    mem_read = 1'b1;
                    b_load = 1'b1;
                    alu_op = 3'b010;
                    acc_load = 1'b1;
                    pc_inc = 1'b1;
                end
                
                4'b0100: begin // OR
                    mem_read = 1'b1;
                    b_load = 1'b1;
                    alu_op = 3'b011;
                    acc_load = 1'b1;
                    pc_inc = 1'b1;
                end
                
                4'b0101: begin // XOR
                    mem_read = 1'b1;
                    b_load = 1'b1;
                    alu_op = 3'b100;
                    acc_load = 1'b1;
                    pc_inc = 1'b1;
                end
                
                4'b0110: begin // JMP
                    pc_jmp = 1'b1;
                    pc_inc = 1'b0;
                end
                
                4'b0111: begin // JZ
                    pc_jmp = zero_flag;
                    pc_inc = ~zero_flag;
                end
                
                4'b1110: begin // OUT
                    out_load = 1'b1;
                    pc_inc = 1'b1;
                end
                
                default: begin // HLT and others
                    // No operation
                end
            endcase
            next_state = FETCH;
        end
    endcase
end

// Expose current state
assign state = current_state;

endmodule