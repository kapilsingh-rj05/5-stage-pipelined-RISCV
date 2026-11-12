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
        
        // Wait enough time for the MAC pipeline to execute all instructions.
        // If your MDU takes ~32 cycles per multiply, 500ns (50 cycles) is safe.
        #1500; 

        $display("\n========================================================");
        $display("   HARDWARE TEST: CUSTOM MAC INSTRUCTION VALIDATION");
        $display("========================================================");
        
        // Check register x10 (a0) for the expected accumulated value (55)
        // Note: Update "dut.id_stg.regfile.registers[10]" if your register file path differs.
        if (dut.id_stg.regfile.registers[10] == 32'd55) begin
            $display("[PASS] x10 = 55 (ACC updated and moved correctly!)"); 
            $display(">>> ALL TESTS PASSED! <<<");
        end else begin 
            $display("[FAIL] x10 = %0d (Expected 55)", dut.id_stg.regfile.registers[10]); 
            $display(">>> TEST FAILED <<<");
        end
        $display("========================================================\n");

        $finish;
    end

endmodule