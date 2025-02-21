# Accumulator Computer

## Summary
In this project, we design an accumulator computer that utilizes 16‑bit cell memory and a simple CPU. The CPU contains an accumulator register (AC), a program counter (PC), and an instruction register (IR). Instructions are encoded in a 16‑bit format consisting of a 4‑bit opcode, a 1‑bit mode indicator, and an 11‑bit operand field (representing either a memory address or an immediate constant). The system supports basic arithmetic and control instructions such as Load, Store, ADD, Sub, Mul, Div, Branch, and Branch-if-Zero (BRZ). The design is implemented in Verilog with separate modules for memory and the CPU, and then integrated at the top level. Simulation tests include executing a sample program and evaluating an arithmetic expression using values stored in specific memory cells.

## Specifications
- **Memory:**
  - **Type:** 16‑bit cell memory (each cell is 16 bits wide).
  - **Access:** Synchronous with the CPU; one cell is read or written per clock cycle.
  - **Interface:** Accessed via a Memory Address Register (MAR) and a Memory Buffer Register (MBR).
  - **Capacity:** Maximum memory size is determined by the available addressing bits (e.g., 64 cells for 128 bytes in the given example).

- **CPU:**
  - **Registers:**
    - **AC:** Accumulator register.
    - **PC:** Program counter.
    - **IR:** Instruction register.
  - **Instruction Format (16 bits):**
    - **Opcode (4 bits):** Specifies the operation.
    - **Mode Bit (M, 1 bit):**  
      - `M = 1` → Operand is a memory address.  
      - `M = 0` → Operand is an immediate signed constant (2’s complement).
    - **Operand (11 bits):** Memory address or constant.
  - **Supported Instructions (Opcodes):**
    - **1:** Load – Load value from memory into AC.
    - **2:** Store – Write AC to memory.
    - **3:** ADD – Add memory value to AC.
    - **4:** Sub – Subtract memory value from AC.
    - **5:** Mul – Multiply AC by memory value.
    - **6:** Div – Divide AC by memory value.
    - **7:** Branch – Jump to specified memory address.
    - **8:** BRZ – Branch if Zero flag (ZF) is set.
  - **Data Representation:** All data are signed 16‑bit integers in 2’s complement format.

- **Simulation & Testing:**
  - **Program Example:**  
    - A sample program is loaded into memory (instructions at addresses 0–3, data at addresses 10–12) to perform an operation (e.g., Load, ADD, Store) and verify that the correct result is stored.
  - **Arithmetic Expression:**  
    - Memory cells A, B, C, D, E, and Y are assigned to addresses 20–25.  
    - The expression implemented is:  
      **Y = A + (B × C) – 5 / (D + E + 1)**
    - Assembly instructions and machine code are derived from this expression, and simulation verifies that Y holds the correct result given initial values (e.g., A=2, B=3, C=5, D=8, E=–5).
  - **Waveform Generation:**  
    - Simulation waveforms are generated to confirm proper execution and correct results.

- **Implementation:**
  - **Modules:** Separate Verilog modules for main memory and the CPU.
  - **Integration:** A top-level design that instantiates and interconnects the memory and CPU modules.
  - **Testbenches:** Provided to simulate the computer’s operation and generate waveform outputs.

## Authors

Qusay Taradeh, Mosa Sbeih
