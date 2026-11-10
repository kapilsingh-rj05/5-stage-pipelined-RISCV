`timescale 1ns / 1ps

module top_tb();

    logic clock;
    logic reset;

    top dut (
        .clk(clock),
        .reset(reset)
    );

    // Clock Generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10ns period
    end

    // Waveform Dump
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_tb);
    end

    // Stimulus & Verification
    initial begin
        reset = 0;
        #20;
        reset = 1; 
        
        // Wait enough time for the C program to set up, loop 10 times, and return
        #4000; 

        $display("\n========================================================");
        $display("   SOFTWARE TEST: C CODE 'FOR' LOOP EXECUTION");
        $display("========================================================");
        
        // Check register x10 (a0) for the sum of 1 to 10 (55)
        if (dut.id_stg.regfile.registers[10] == 32'd55) begin
            $display("[PASS] x10 = 55 (For-loop executed correctly!)"); 
            $display(">>> ALL TESTS PASSED! <<<");
        end else begin 
            $display("[FAIL] x10 = %0d (Expected 55)", dut.id_stg.regfile.registers[10]); 
            $display(">>> TEST FAILED <<<");
        end
        $display("========================================================\n");

        $finish;
    end

endmodule