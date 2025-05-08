# SAP-1 Processor - Verilog Implementation

A Verilog implementation of the SAP-1 (Simple-As-Possible) computer architecture, featuring a basic 8-bit processor with an advanced instruction set with a frontend visualization.

---

## 👥 Contributors
- Mohammad Musa Ali
- Muhammad Umer
- Sarosh Ishaq
- 
---

## 🖥️ Project Overview
The SAP-1 is an 8-bit educational processor designed to demonstrate fundamental computer architecture concepts. This project includes:  
- **3-stage operation**: Fetch, Decode, Execute  
- **8-bit data bus** and **4-bit address bus**  
- **9-instruction set** (LDA, ADD, SUB, JMP, etc.)  
- Key components: ALU, Accumulator, Program Counter, Memory, and Control Unit  

---

## 📂 Project Structure
| File               | Description                                  |
|--------------------|----------------------------------------------|
| `sap1_tb.v`        | Testbench for full system simulation         |
| `program_counter.v`| 8-bit program counter with jump logic        |
| `mar.v`            | Memory Address Register (MAR)               |
| `memory.v`         | 16-byte RAM with preloaded instructions/data |
| `control_unit.v`   | Finite State Machine for instruction decoding|
| `alu.v`            | Arithmetic Logic Unit (supports +, -, &, \|, ^) |
| `accumulator.v`    | 8-bit accumulator with zero-flag detection   |
| `b_reg.v`          | Temporary data storage register             |

---

## 💻 How to Run

### Prerequisites
- **Icarus Verilog** (iverilog) - [Install Guide](http://iverilog.icarus.com)  
- **GTKWave** (for waveform viewing) - [Download](http://gtkwave.sourceforge.net)

---

### Simulation Steps
1. **Compile the Design**  
   bash
   iverilog -o sap1_sim sap1_tb.v program_counter.v mar.v memory.v control_unit.v accumulator.v alu.v b_reg.v ins_reg.v output_reg.v
   
Run the Simulation:
bash
vvp sap1_sim

View Waveforms:
bash
gtkwave sap1_wave.vcd

Expected Output
- A VCD file (sap1_wave.vcd) will be generated, showing:
- Control unit states (Fetch/Decode/Execute)
- Register values (ACC, B_REG, PC, MAR)
- ALU operations
- Memory interactions

## Waveform Analysis Guide
Initial x Values: Registers start as unknown (x) until reset is released at 20ns.

Instruction Flow:

FETCH: MAR loads PC address, memory read occurs

DECODE: IR splits instruction into opcode/operand

EXECUTE: ALU computes results, registers update

Key Signals:

control_state: Tracks FSM state (00=FETCH, 01=DECODE, 10=EXECUTE)

zero_flag: Indicates ACC=0 for conditional jumps (JZ)

🛠️ Troubleshooting
x Values Persist: 
Ensure:

Reset signal (reset = 1) is applied in the first 20ns

All registers have proper initialization in initial blocks

Compilation Errors: Verify file names match module names exactly.
