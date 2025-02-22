`define NOOP 5'b00000
`define MOV 5'b00001
`define ADD 5'b00010
`define ADC 5'b00011
`define SUB 5'b00100
`define INC 5'b00101
`define DEC 5'b00110
`define CMP 5'b00111
`define AND 5'b01000
`define OR 5'b01001
`define XOR 5'b01010
`define NOT 5'b01011
`define LDR 5'b01100
`define STR 5'b01101
`define LDI 5'b01110
`define JMP 5'b01111
`define JZ 5'b10000
`define JNZ 5'b10001
`define JC 5'b10010
`define JNC 5'b10011
`define PUSH 5'b10100
`define POP 5'b10101
`define CALL 5'b10110
`define RET 5'b10111
`define HLT 5'b11000
/////////
/*
`define LSHL 5'b10011 ->logical shift
`define LSHR 5'b10100
`define ASHL 5'b10101->arithmetic shift
`define ASHR 5'b10110
`define INT 5'b11110->interrupt
`define MUL
`define DIV
ALU:[OPCODE] [DEST] [REG]// [REG]
MOV:[OPCODE] [ADDR MODE] [DEST] [SOURCE]
LDI:[OPCODE] [VALUE(2^11)]
LDR:[OPCODE] [DEST] [ADDRESS]
STR:[OPCODE] [SOURCE] [DEST_ADDRESS]
NOOP:[OPCODE]
JMP:[OPCODE] [JMP_ADDRESS]
*OPCODE=5BIT
*DEST/REG/ADDRM=3BIT
*ADRESS/DEST_ADDR=8BIT
*/