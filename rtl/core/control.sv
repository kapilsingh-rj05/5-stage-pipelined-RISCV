module control(
    input logic[6:0] opcode,
    output logic ALUSrc,
    output logic MemToReg,
    output logic RegWrite,
    output logic MemRead,
    output logic MemWrite,
    output logic Branch,
    output logic ALUOp1,
    output logic ALUOp0
);

    always_comb begin : control
        {ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 8'b00000000;
        case(opcode)
        //R-type
        7'b0110011: begin
            {ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 8'b00100010;
        end
        //ld
        7'b0000011: begin
            {ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 8'b11110000;
        end
        //store
        7'b0100011: begin
            {ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 8'b10001000;
        end
        //branch
        7'b1100011: begin
            {ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 8'b00000101;
        end
        //i-type
        7'b0010011: begin
            {ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 8'b10100010;
        end
        default: {ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 8'b00000000;
        endcase
    end
endmodule