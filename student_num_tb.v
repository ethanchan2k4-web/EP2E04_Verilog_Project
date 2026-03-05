`timescale 1ns / 1ps

module student_num_tb;

    // 1. Inputs to the module (Regs because we drive them)
    reg clk;
    reg rst_n;

    // 2. Outputs from the module (Wires because we read them)
    wire [6:0] seg;
    wire [3:0] anode;

    // 3. Instantiate the Unit Under Test (UUT)
    student_number_fsm uut (
        .clk(clk), 
        .rst_n(rst_n), 
        .seg(seg), 
        .anode(anode)
    );

    // 4. Clock Generation (Mimics your 40Hz Clock)
    // Toggling every 10 time units
    always #10 clk = ~clk;

    // 5. Test Stimulus
    initial begin
        // Initialize Inputs
        clk = 0;
        rst_n = 0; // Hold reset initially (Active Low)

        // Wait 100ns for global reset to finish
        #100;
        
        // Release Reset (Go High) - This starts the sequence
        rst_n = 1;
        
        // Display headers for the text output
        $display("Time | Reset | State (Binary) | Decoded Digit");
        $display("----------------------------------------------");
        
        // Monitor changes: This prints whenever signals change
        // We look at the internal signals 'q1-q4' inside the instance 'uut'
        // Note: Accessing internal signals usually requires supported simulators
        $monitor("%4t |   %b   |      %b      |      %h", 
                 $time, rst_n, {uut.q1, uut.q2, uut.q3, uut.q4}, {uut.q1, uut.q2, uut.q3, uut.q4});

        // Run simulation for enough time to see the full cycle (400473109)
        #500;
        
        // End simulation
        $finish;
    end
      
endmodule