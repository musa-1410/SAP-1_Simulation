// script.js
class SAP1Simulator {
  constructor() {
    this.initializeEventListeners();
    this.initializeRegisters();
    this.initializeMemoryTable();
  }

  initializeEventListeners() {
    document.getElementById('run-btn')
      .addEventListener('click', () => this.runSimulation());
    document.getElementById('step-btn')
      .addEventListener('click', () => this.stepSimulation());
    document.getElementById('reset-btn')
      .addEventListener('click', () => this.resetSimulation());
  }

  initializeRegisters() {
    document.getElementById('pc-value').textContent = '00';
    document.getElementById('ir-value').textContent = '00000000';
    document.getElementById('ir-opcode').textContent = '0000';
    document.getElementById('ir-operand').textContent = '0000';
    document.getElementById('acc-value').textContent = '00';
    document.getElementById('alu-value').textContent = '000';
    document.getElementById('b-reg-value').textContent = '00';
    document.getElementById('mar-value').textContent = '00';
    document.getElementById('out-reg-value').textContent = '00';
  }

  // NEW: fetch & render the memory contents once on load
  async initializeMemoryTable() {
    try {
      const response = await fetch('/api/memory');
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      const memory = await response.json();
      this.updateMemoryTable(memory);
    } catch (err) {
      console.error('Could not load memory contents:', err);
      alert('Error loading memory contents');
    }
  }

  async runSimulation() {
    try {
      const res = await fetch('/api/simulate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'run' })
      });
      const data = await res.json();
      this.updateUI(data.signals, data.memory);
    } catch (error) {
      console.error('Simulation error:', error);
      alert('Failed to start simulation');
    }
  }

  async stepSimulation() {
    try {
      const res = await fetch('/api/simulate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'step' })
      });
      const data = await res.json();
      this.updateUI(data.signals, data.memory);
    } catch (error) {
      console.error('Step error:', error);
      alert('Failed to execute step');
    }
  }

  async resetSimulation() {
    try {
      const res = await fetch('/api/simulate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'reset' })
      });
      const data = await res.json();
      this.updateUI(data.signals, data.memory);
    } catch (error) {
      console.error('Reset error:', error);
      alert('Failed to reset simulation');
    }
  }

  updateUI(signals, memory) {
    if (!signals) return;

    // Update register values
    document.getElementById('pc-value').textContent = signals.pc_out;
    document.getElementById('ir-value').textContent = signals.ir_opcode + signals.ir_operand;
    document.getElementById('ir-opcode').textContent = signals.ir_opcode;
    document.getElementById('ir-operand').textContent = signals.ir_operand;
    document.getElementById('acc-value').textContent = signals.acc_out;
    document.getElementById('alu-value').textContent = signals.alu_op;
    document.getElementById('b-reg-value').textContent = signals.b_reg;
    document.getElementById('mar-value').textContent = signals.mar;
    document.getElementById('out-reg-value').textContent = signals.out_reg;
    
    // Animate component activation
    this.updateComponentStates(signals.ir_opcode);
    
    // Highlight the current instruction in memory
    this.highlightMemoryAddress(signals.pc_out);

    // Always re-render the full memory table (so it never disappears)
    if (memory) {
      this.updateMemoryTable(memory);
    }
  }

  updateMemoryTable(memoryData) {
    const tbody = document.querySelector('#memory-table tbody');
    tbody.innerHTML = memoryData.map(item => `
      <tr data-address="${item.address}">
        <td>${item.address}</td>
        <td>${item.instruction}</td>
        <td>${item.mnemonic}</td>
        <td>${this.getInstructionDescription(item.mnemonic)}</td>
      </tr>
    `).join('');
  }

  updateComponentStates(opcode) {
    document.querySelectorAll('.component').forEach(c => c.classList.remove('active'));

    switch (opcode) {
      case '0000': // LDA
        document.querySelector('.mar').classList.add('active');
        break;
      case '0001': // ADD
      case '0010': // SUB
      case '0011': // AND
      case '0100': // OR
      case '0101': // XOR
        document.querySelector('.alu').classList.add('active');
        document.querySelector('.b-reg').classList.add('active');
        break;
      case '1110': // OUT
        document.querySelector('.out-reg').classList.add('active');
        break;
      default:
        document.querySelector('.pc').classList.add('active');
    }
  }

  highlightMemoryAddress(pcValue) {
    const address = `0x0${parseInt(pcValue, 10).toString(16).toUpperCase()}`;

    document.querySelectorAll('#memory-table tr')
      .forEach(tr => tr.classList.remove('current-instruction'));

    const target = document.querySelector(`#memory-table tr[data-address="${address}"]`);
    if (target) target.classList.add('current-instruction');
  }

  getInstructionDescription(mnemonic) {
    switch (mnemonic) {
      case 'LDA': return 'Load value from memory';
      case 'ADD': return 'Add value to accumulator';
      case 'SUB': return 'Subtract value from accumulator';
      case 'AND': return 'Bitwise AND with accumulator';
      case 'OR':  return 'Bitwise OR with accumulator';
      case 'XOR': return 'Bitwise XOR with accumulator';
      case 'JMP': return 'Jump to memory address';
      case 'JZ':  return 'Jump if accumulator is zero';
      case 'OUT': return 'Output accumulator value';
      case 'HLT': return 'Halt execution';
      default:    return 'Data';
    }
  }
}

document.addEventListener('DOMContentLoaded', () => {
  new SAP1Simulator();
});
