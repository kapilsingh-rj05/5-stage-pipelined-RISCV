package pipeline_pkg;

    typedef struct packed {
        logic [31:0] pc;
        logic [31:0] instr;
    } if_id_t;

    typedef struct packed {
        logic [31:0] pc;
        logic [31:0] rv1;
        logic [31:0] rv2;
        logic [31:0] imm;
        logic [4:0] rs1;
        logic [4:0] rs2;
        logic [4:0] rd;
        logic [3:0] func3;
        logic [7:0] control;
    } id_ex_t;

    typedef struct packed {
        logic [31:0] pc;
        logic [31:0] aluR;
        logic [31:0] rv2;
        logic [4:0] rd;
        logic zero;
        logic [4:0] control;
    } ex_mem_t;

    typedef struct packed {
        logic [31:0] r_data;
        logic [31:0] aluR;
        logic [4:0] rd;
        logic [1:0] control;
    } mem_wb_t;

endpackage