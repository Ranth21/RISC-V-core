# Minimal RISC-V Core

This project implements a basic, single-threaded RISC-V core that executes a subset of the RISC-V instruction set. The design demonstrates the complete instruction execution flow from fetching to writing back results. It was developed and simulated using Xilinx Vivado.

## Key Components

- **Program Counter (PC):**  
  Maintains the current instruction address and updates based on control signals.

- **Instruction Fetch:**  
  Retrieves instructions from a preloaded memory using the current PC (converting byte address to word address).

- **Instruction Decode:**  
  Extracts fields (opcode, register addresses, funct3, funct7, and various immediates) from the fetched 32-bit instruction.

- **Control Unit:**  
  Analyzes the instruction (opcode, funct3, funct7) to generate control signals for the datapath (ALU, register file, memory access, PC update, and immediate selection).

- **Register File:**  
  Stores 32 general-purpose registers (each 32 bits wide) with asynchronous read ports and synchronous write port, ensuring x0 is always zero.

- **Arithmetic Logic Unit (ALU):**  
  Performs arithmetic operations (ADD, SUB, MUL, DIV) and generates a zero flag for branch decisions.

- **Memory Module:**  
  Provides data storage with asynchronous read and synchronous write capabilities for both instruction and data memory.

- **Top-Level Integration:**  
  All modules are interconnected to form a complete datapath that executes instructions from fetch, decode, execute, memory, and write-back stages.

## Tools Used

- **Xilinx Vivado:**  
  The design was implemented and simulated using Xilinx Vivado for synthesis, simulation, and debugging.

## Testing

Each module was verified with dedicated testbenches covering corner cases and error conditions. A system-level testbench ensured proper integration and functioning of the complete core.

---

This project lays a solid foundation for further enhancements, such as adding multithreading or advanced scheduling techniques. Enjoy exploring and extending the design!


### **I haven't written the parser to this project, coz this was my base version for the higher iteration..feel free to add the file, if you are interested.**

