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
    output logic ALUOp0,
    output logic jump
);

    always_comb begin : control
        {jump,mdu_enable, ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 10'b0000000000;
        case(opcode)
        //R-type
        7'b0110011: begin
            if(func7==7'b0000001) begin
                {jump,mdu_enable,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 10'b0100100010;
            end
            else begin
                {jump,mdu_enable,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 10'b0000100010;
            end
        end
        //ld
        7'b0000011: begin
            {jump,mdu_enable,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 10'b0011110000;
        end
        //store
        7'b0100011: begin
            {jump,mdu_enable,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 10'b0010001000;
        end
        //branch
        7'b1100011: begin
            {jump,mdu_enable,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 10'b0000000101;
        end
        //i-type
        7'b0010011: begin
            {jump,mdu_enable,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 10'b0010100011;
        end
        //J-type
        7'b1101111: begin
            {jump,mdu_enable,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 10'b1000100000;
        end
        default: {jump,mdu_enable,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 10'b0000000000;
        endcase
    end
endmodule