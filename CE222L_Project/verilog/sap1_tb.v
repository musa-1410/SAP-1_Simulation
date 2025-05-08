`timescale 1ns/1ps
module sap1_tb;

// Clock and Reset
reg clk;
reg reset;

// Wires for interconnections
wire [3:0] pc_out;
wire [3:0] mar_out;
wire [7:0] mem_data_out;
wire [3:0] ir_opcode;
wire [3:0] ir_operand;
wire [7:0] acc_out;
wire [7:0] b_reg_out;
wire [7:0] alu_result;
wire [7:0] out_reg;
wire zero_flag;
wire [1:0] control_state;
wire [3:0] mar_addr_in = (control_state == 2'b00) ? pc_out : {4'b0, ir_operand};

// Control signals
wire pc_inc, pc_jmp, mem_read, acc_load, out_load, b_load;
wire [2:0] alu_op;

// Instantiate all modules with explicit connections
program_counter pc(
    .clk(clk),
    .reset(reset),
    .jmp_addr({4'b0, ir_operand}),
    .pc_inc(pc_inc),
    .pc_jmp(pc_jmp),
    .pc_out(pc_out)
);

mar mar_inst(
    .clk(clk),
    .addr_in(mar_addr_in),
    .mar_load(mem_read),
    .addr_out(mar_out)
);

memory mem(
    .clk(clk),
    .addr(mar_out[3:0]),
    .mem_read(mem_read),
    .mem_write(1'b0),
    .data_in(8'b0),
    .data_out(mem_data_out)
);

ins_reg ir(
    .clk(clk),
    .instr_in(mem_data_out),
    .ir_load(mem_read),
    .opcode(ir_opcode),
    .operand(ir_operand)
);

control_unit control(
    .clk(clk),
    .reset(reset),
    .opcode(ir_opcode),
    .zero_flag(zero_flag),
    .pc_inc(pc_inc),
    .pc_jmp(pc_jmp),
    .mem_read(mem_read),
    .acc_load(acc_load),
    .b_load(b_load),
    .alu_op(alu_op),
    .out_load(out_load),
    .state(control_state)
);

b_reg b_register(
    .clk(clk),
    .data_in(mem_data_out),
    .b_load(b_load),
    .data_out(b_reg_out)
);

alu alu_inst(
    .a(acc_out),
    .b(b_reg_out),
    .op(alu_op),
    .result(alu_result)
);

accumulator acc(
    .clk(clk),
    .data_in(alu_result),
    .acc_load(acc_load),
    .acc_out(acc_out),
    .zero_flag(zero_flag)
);

output_reg out_reg_inst(
    .clk(clk),
    .data_in(acc_out),
    .out_load(out_load),
    .data_out(out_reg)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Main test sequence
initial begin
    $dumpfile("sap1_wave.vcd");
    $dumpvars(0, sap1_tb);
    
    // Initialize signals
    reset = 1;
    #20 reset = 0;
    
    $display("Starting SAP-1 Simulation");
    
    // Run simulation for sufficient time
    #400 $finish;
end

endmodule