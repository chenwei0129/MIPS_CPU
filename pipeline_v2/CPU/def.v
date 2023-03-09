`define CYCLE    12

`define WIDTH            32
`define ADDRWIDTH        32

`define OP_WIDTH         6
`define R_WIDTH          5
`define SHAMT_WIDTH      5
`define FUNC_WIDTH       6
`define CONS_ADDR_WIDTH  16
`define ALUOp_WIDTH      2
`define ALUCONTROL_WIDTH 4

`define MEMSIZE        128
`define MEM_ADDR_WIDTH 7
`define REGSIZE        32

`define OP            31:26
`define RS            25:21
`define RT            20:16
`define RD            15:11
`define SHAMT         10:6
`define FUNC          5:0
`define CONS_ADDR     15:0

`define ALL_CTRL_WIDTH  8
`define WB_CTRL_WIDTH   2
`define MEM_CTRL_WIDTH  2
`define EX_CTRL_WIDTH   4

`define FORWARD_WIDTH   3

`define CACHE_INDEX      2:0
`define CACHE_TAG        31:3
`define CACHE_SIZE       8
`define CACHE_ADDRWIDTH  3