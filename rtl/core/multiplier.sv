module multiplier(
    input logic clk,
    input logic reset,
    input logic start,
    output logic done,
    input logic[2:0] func3,
    input logic[31:0] a,
    input logic[31:0] b,
    output logic[31:0] result
);

    typedef enum logic[1:0] {IDLE, COMPUTE, FINISH} state_t;
    state_t state, next_state;

    logic[63:0] accumulator, next_accumulator;
    logic[31:0] multiplicand, next_multiplicand;
    logic[5:0] count, next_count;
    logic invert_result, next_invert_result;

    always_ff @(posedge clk or negedge reset) begin
        if(!reset) begin
            state <= IDLE;
            accumulator <= 64'd0;
            multiplicand <= 32'd0;
            count <= 6'd0;
            invert_result <= 1'b0;
        end
        else begin
            state <= next_state;
            accumulator <= next_accumulator;
            multiplicand <= next_multiplicand;
            count <= next_count;
            invert_result <= next_invert_result;
        end
    end

    always_comb begin
        next_state = state;
        next_accumulator = accumulator;
        next_multiplicand = multiplicand;
        next_count = count;
        next_invert_result = invert_result;
        done = 1'b0;
        result = 32'd0;

        case(state)
            IDLE: begin
                if(start) begin
                    logic is_a_signed, is_b_signed;
                    logic sign_a, sign_b;
                    logic[31:0] abs_a, abs_b;

                    is_a_signed = (func3==3'b001) || (func3==3'b010);
                    is_b_signed = (func3==3'b001);

                    sign_a = is_a_signed & a[31];
                    sign_b = is_b_signed & b[31];

                    abs_a = sign_a ? (~a + 1'b1) : a;
                    abs_b = sign_b ? (~b + 1'b1) : b;

                    next_accumulator = {32'd0, abs_b};
                    next_multiplicand = abs_a;
                    next_invert_result = sign_a ^ sign_b;
                    next_count = 6'd32;
                    next_state = COMPUTE;
                end
            end

            COMPUTE: begin
                if(count>0) begin
                    if(accumulator[0]) begin
                        next_accumulator = {(accumulator[63:32]+multiplicand), accumulator[31:1]};
                    end
                    else begin
                        next_accumulator = {1'b0, accumulator[63:1]};
                    end
                    next_count = count-1;
                end
                else begin
                    next_state = FINISH;
                end
            end

            FINISH: begin
                done = 1'b1;
                logic[63:0] final_result;
                final_result = invert_result ? (~accumulator + 1'b1) : accumulator;
                if(func3==3'b000) begin
                    result = final_result[31:0];
                end
                else begin
                    result = final_result[63:32];
                end
                next_state = IDLE;
            end
        endcase
    end

endmodule