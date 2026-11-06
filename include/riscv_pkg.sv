package riscv_pkg;

    typedef enum logic[3:0] {
        ALU_AND=4'b0000,
        ALU_OR=4'b0001,
        ALU_ADD=4'b0010,
        ALU_SUB=4'b0110
    } alu_op_t;

    typedef enum logic[1:0] {
        ALUOP_LDST=2'b00,
        ALUOP_BRANCH=2'b01,
        ALUOP_RTYPE=2'b10
    } alu_opcode_t;

endpackage