module ALU(
    input logic[3:0] aluControl,
    input logic[31:0] val1,
    input logic[31:0] val2,
    output logic zero,
    output logic[31:0] aluResult
);

    always_comb begin : alu
        case(aluControl)
        4'b0000: aluResult = val1 & val2;
        4'b0001: aluResult = val1 | val2;
        4'b0010: aluResult = val1 + val2;
        4'b0110: aluResult = val1 - val2;
        default: aluResult = 32'b0;
        endcase
    end

    assign zero = (aluResult==32'b0);

endmodule