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
        forever #5 clock = ~clock;
    end

    // Waveform Dump
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_tb);
    end

    // Stimulus & Verification
    initial begin
        int errors = 0;

        reset = 0;
        #20;
        reset = 1; 
        
        // Wait 1000ns to allow memory writing and all loop iterations to complete
        #1000; 

        $display("\n========================================================");
        $display("   GRAND FINALE: MEMORY ARRAY SUMMATION TEST");
        $display("========================================================");
        
        // 1. Accumulator Check
        if (dut.id_stg.regfile.registers[3] == 32'd100) 
            $display("[PASS] x3 = 100 (Array summed correctly: 10+20+30+40)"); 
        else begin $display("[FAIL] x3 = %0d (Expected 100)", dut.id_stg.regfile.registers[3]); errors++; end
        
        // 2. Pointer Exit Check
        if (dut.id_stg.regfile.registers[1] == 32'd16) 
            $display("[PASS] x1 = 16  (Memory pointer exited loop perfectly)"); 
        else begin $display("[FAIL] x1 = %0d (Expected 16)", dut.id_stg.regfile.registers[1]); errors++; end

        // 3. Last Loaded Value Check
        if (dut.id_stg.regfile.registers[5] == 32'd40) 
            $display("[PASS] x5 = 40  (Load-Use hazard handled perfectly on last element)"); 
        else begin $display("[FAIL] x5 = %0d (Expected 40)", dut.id_stg.regfile.registers[5]); errors++; end

        // 4. Completion Flag
        if (dut.id_stg.regfile.registers[6] == 32'd1) 
            $display("[PASS] x6 = 1   (Program executed to completion cleanly)"); 
        else begin $display("[FAIL] x6 = %0d (Expected 1)", dut.id_stg.regfile.registers[6]); errors++; end

        $display("========================================================");
        if (errors == 0)
            $display(">>> ALL TESTS PASSED! YOU HAVE A WORKING RV32I CORE! <<<");
        else
            $display(">>> TEST COMPLETED WITH %0d FAILURE(S) <<<", errors);
        $display("========================================================\n");

        $finish;
    end

endmodule