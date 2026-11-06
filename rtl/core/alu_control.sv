import riscv_pkg::*;

module alu_control(
    input logic[2:0] func3,
    input logic bit30,
    input logic[1:0] ALUOp,
    output alu_op_t aluControl
);

    always_comb begin
        case(ALUOp)
            ALUOP_LDST: begin
                aluControl = ALU_ADD;
            end

            ALUOP_BRANCH: begin
                aluControl = ALU_SUB;
            end

            ALUOP_RTYPE: begin
                case(func3)
                    3'b000: aluControl = (bit30==1'b0) ? ALU_ADD : ALU_SUB;
                    3'b111: aluControl = ALU_AND;
                    3'b110: aluControl = ALU_OR;
                    default: aluControl = ALU_ADD;
                endcase
            end

            default: aluControl = ALU_ADD;
        endcase
    end

endmodule