Here is the complete README with the information you provided:

---

# My-CPU

## Overview

My-CPU is a 16-bit CPU with a simple instruction set, implemented using a non-pipelined design and Harvard architecture. This project was a personal endeavor to learn about the inner workings of a CPU.

## Features

- 16-bit CPU: The CPU processes 16-bit instructions and data.
- Simple Instruction Set: The instruction set is designed to be simple and easy to understand.
- Non-Pipelined Design: The CPU executes one instruction at a time, without pipelining.
- Harvard Architecture: Separate memory spaces for instructions and data.

##TODO: CLEANUP

## Instruction Set

The CPU uses a 5-bit opcode to represent different instructions. Below is a list of the supported instructions and their corresponding opcodes.

| Instruction | Opcode  | Description |
|-------------|---------|-------------|
| NOOP        | 00000   | No operation. The CPU moves to the next instruction. |
| MOV         | 00001   | Move data from one register to another. |
| ADD         | 00010   | Add the values of two registers and store the result in a register. |
| ADC         | 00011   | Add the values of two registers along with the carry flag and store the result in a register. |
| SUB         | 00100   | Subtract the value of one register from another and store the result in a register. |
| INC         | 00101   | Increment the value of a register by one. |
| DEC         | 00110   | Decrement the value of a register by one. |
| CMP         | 00111   | Compare the values of two registers and set the condition flags accordingly. |
| AND         | 01000   | Perform a bitwise AND operation between the values of two registers and store the result in a register. |
| OR          | 01001   | Perform a bitwise OR operation between the values of two registers and store the result in a register. |
| XOR         | 01010   | Perform a bitwise XOR operation between the values of two registers and store the result in a register. |
| NOT         | 01011   | Perform a bitwise NOT operation on a register and store the result in the same register. |
| LDR         | 01100   | Load data from memory into a register. |
| STR         | 01101   | Store data from a register into memory. |
| LDI         | 01110   | Load an immediate value into a register. |
| JMP         | 01111   | Unconditionally jump to a specified address. |
| JZ          | 10000   | Jump to a specified address if the zero flag is set. |
| JNZ         | 10001   | Jump to a specified address if the zero flag is not set. |
| JC          | 10010   | Jump to a specified address if the carry flag is set. |
| JNC         | 10011   | Jump to a specified address if the carry flag is not set. |
| PUSH        | 10100   | Push the value of a register onto the stack. |
| POP         | 10101   | Pop the top value from the stack into a register. |
| CALL        | 10110   | Call a subroutine at a specified address. |
| RET         | 10111   | Return from a subroutine. |
| HLT         | 11000   | Halt the CPU. |

## Learning Experience

This project was my first attempt at designing a CPU. It was a great way to learn about:

- The architecture and design of CPUs.
- The differences between Harvard and von Neumann architectures.
- The challenges and considerations in non-pipelined CPU designs.
- The use of hardware description languages like Verilog and VHDL.
