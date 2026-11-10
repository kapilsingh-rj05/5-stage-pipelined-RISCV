module control(
    input logic[6:0] opcode,
    input logic[6:0] func7,
    output logic mdu_enable,
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
        {mdu_enable, ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 9'b000000000;
        case(opcode)
        //R-type
        7'b0110011: begin
            if(func7==7'b0000001) begin
                {mdu_enable,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 9'b100100010;
            end
            else begin
                {mdu_enable,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 9'b000100010;
            end
        end
        //ld
        7'b0000011: begin
            {mdu_enable,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 9'b011110000;
        end
        //store
        7'b0100011: begin
            {mdu_enable,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 9'b010001000;
        end
        //branch
        7'b1100011: begin
            {mdu_enable,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 9'b000000101;
        end
        //i-type
        7'b0010011: begin
            {mdu_enable,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 9'b010100011;
        end
        default: {mdu_enable,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 9'b000000000;
        endcase
    end
endmodule