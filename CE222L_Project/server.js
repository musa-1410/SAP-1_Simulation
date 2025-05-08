// server.js
const express = require('express');
const { execSync } = require('child_process');
const cors = require('cors');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// Simulation state
let simulationState = {
  currentStep: 0,
  signals: null,
  memory: [
    { address: "0x00", instruction: "00001010", mnemonic: "LDA" },
    { address: "0x01", instruction: "00011011", mnemonic: "ADD" },
    { address: "0x02", instruction: "00101100", mnemonic: "SUB" },
    { address: "0x03", instruction: "00111101", mnemonic: "AND" },
    { address: "0x04", instruction: "01001110", mnemonic: "OR" },
    { address: "0x05", instruction: "01011111", mnemonic: "XOR" },
    { address: "0x06", instruction: "01100110", mnemonic: "JMP" },
    { address: "0x07", instruction: "01110000", mnemonic: "JZ" },
    { address: "0x08", instruction: "11100000", mnemonic: "OUT" },
    { address: "0x09", instruction: "11110000", mnemonic: "HLT" },
    { address: "0x0A", instruction: "00001010", mnemonic: "DATA" },
    { address: "0x0B", instruction: "00000101", mnemonic: "DATA" },
    { address: "0x0C", instruction: "00000011", mnemonic: "DATA" },
    { address: "0x0D", instruction: "00001100", mnemonic: "DATA" },
    { address: "0x0E", instruction: "00000011", mnemonic: "DATA" },
    { address: "0x0F", instruction: "00000101", mnemonic: "DATA" }
  ]
};

function getCurrentStep() {
  if (!simulationState.signals) return null;
  const step = simulationState.currentStep % simulationState.signals.pc_out.length;
  return {
    pc_out:     simulationState.signals.pc_out[step],
    acc_out:    simulationState.signals.acc_out[step],
    ir_opcode:  simulationState.signals.ir_opcode[step],
    ir_operand: simulationState.signals.ir_operand[step],
    alu_op:     simulationState.signals.alu_op[step],
    b_reg:      simulationState.signals.b_reg[step],
    mar:        simulationState.signals.mar[step],
    out_reg:    simulationState.signals.out_reg[step]
  };
}

function runVerilogSimulation() {
  // stubbed signal arrays
  return {
    pc_out:     ["00","01","02","03","04","05","06","07","08","09","0A","0B","0C","0D","0E","0F"],
    acc_out:    ["00","0A","0F","0C","04","0F","0A","0A","0A","00","00","00","00","00","00","00"],
    ir_opcode:  ["0000","0001","0010","0011","0100","0101","0110","0111","1110","1111","0000","0001","0010","0011","0100","0101"],
    ir_operand: ["1010","1011","1100","1101","1110","1111","0110","0000","0000","0000","0000","0000","0000","0000","0000","0000"],
    alu_op:     ["000","000","001","010","011","100","000","000","000","000","000","000","000","000","000","000"],
    b_reg:      ["00","05","03","0C","03","05","00","00","00","00","00","00","00","00","00","00"],
    mar:        ["00","01","02","03","04","05","06","07","08","09","0A","0B","0C","0D","0E","0F"],
    out_reg:    ["00","00","00","00","00","00","00","00","0A","00","00","00","00","00","00","00"]
  };
}

app.post('/api/simulate', (req, res) => {
  const { action } = req.body;

  switch (action) {
    case 'run':
      simulationState.signals = runVerilogSimulation();
      simulationState.currentStep = 0;
      return res.json({
        status: 'success',
        signals: getCurrentStep(),
        memory: simulationState.memory
      });

    case 'step':
      if (!simulationState.signals) {
        return res.status(400).json({ error: 'Run simulation first' });
      }
      simulationState.currentStep++;
      return res.json({
        status: 'success',
        signals: getCurrentStep(),
        memory: simulationState.memory
      });

    case 'reset':
      simulationState.currentStep = 0;
      return res.json({
        status: 'success',
        signals: getCurrentStep(),
        memory: simulationState.memory
      });

    default:
      return res.status(400).json({ error: 'Invalid action' });
  }
});

app.get('/api/memory', (req, res) => {
  const data = simulationState.memory.map(item => ({
    ...item,
    address: item.address.startsWith('0x0')
      ? item.address
      : `0x0${item.address.slice(2)}`
  }));
  res.json(data);
});

app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});
