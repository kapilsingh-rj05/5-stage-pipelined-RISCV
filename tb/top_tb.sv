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
        $dumpfile("wave.vcd"); // Saves to sim/wave.vcd[cite: 4]
        $dumpvars(0, top_tb);
    end

    // Stimulus & Verification
    initial begin
        reset = 0;
        #20;
        reset = 1; 
        
        // Extended wait time for 3 nested FFT loops and custom MAC execution
        #2000000; 

        $display("\n========================================================");
        $display("   SOFTWARE TEST: RADIX-2 FFT EXECUTION (Q15 FIXED-POINT)");
        $display("========================================================");
        
        // Verify x10 (a0) for the FFT output of bin 0
        if (dut.id_stg.regfile.registers[10] == 32'd300) begin
            $display("[PASS] x10 = 300 (FFT Bin 0 calculated correctly!)"); 
            $display(">>> ALL TESTS PASSED! <<<");
        end else begin 
            $display("[FAIL] x10 = %0d (Expected 300)", dut.id_stg.regfile.registers[10]); 
            $display(">>> TEST FAILED <<<");
        end
        $display("========================================================\n");

        $finish;
    end

endmodule