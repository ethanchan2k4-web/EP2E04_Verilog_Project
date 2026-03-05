module student_number_fsm (
    input wire clk,
    input wire rst_n,      // Active low reset
    output reg [6:0] seg,  // Segments a,b,c,d,e,f,g
    output wire [3:0] anode // Anode control (if using a board like Basys3)
);

    // ---------------------------------------------------------
    // INTERNAL SIGNALS
    // ---------------------------------------------------------
    // State bits corresponding to your Table 2[cite: 28]:
    // q1 (8), q2 (4), q3 (2), q4 (1), c5 (counter), c6 (counter)
    reg q1, q2, q3, q4, c5, c6;

    // J and !K (K_bar) signals for each flip-flop
    wire J1, K1_bar, J2, K2_bar, J3, K3_bar;
    wire J4, K4_bar, J5, K5_bar, J6, K6_bar;

    // ---------------------------------------------------------
    // COMBINATIONAL LOGIC (From Table 18) 
    // ---------------------------------------------------------
    // Note: The logic below implements the "Input Boolean Expressions"
    // you derived for the design.

    // Flip-Flop 1 (q1 - MSB 8)
    assign J1     = c5;
    assign K1_bar = 1'b0; // Driven low as per table

    // Flip-Flop 2 (q2 - 4)
    assign J2     = q1 | c6;
    assign K2_bar = c6;

    // Flip-Flop 3 (q3 - 2)
    assign J3     = q2 & c6;
    assign K3_bar = q2;

    // Flip-Flop 4 (q4 - LSB 1)
    assign J4     = c5 | (q2 & c6);
    assign K4_bar = q3;

    // Flip-Flop 5 (c5 - Counter Bit A)
    assign J5     = (~q1) & (~q3) & q4;
    assign K5_bar = 1'b0;

    // Flip-Flop 6 (c6 - Counter Bit B)
    assign J6     = (~q2) & (~q4) & (~c5);
    assign K6_bar = ~q2;

    // ---------------------------------------------------------
    // SEQUENTIAL LOGIC (JK Flip-Flop Emulation)
    // ---------------------------------------------------------
    // The 74HC109 behavior: Q_next = J*(!Q) + (!K)*Q
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset to State '4a' (Start of student number 4...)
            // From Source 23/29: 4 is 0100. C5,C6 are 00.
            // q1=0, q2=1, q3=0, q4=0, c5=0, c6=0
            q1 <= 0; q2 <= 1; q3 <= 0; q4 <= 0; c5 <= 0; c6 <= 0;
        end else begin
            q1 <= (J1 & ~q1) | (K1_bar & q1);
            q2 <= (J2 & ~q2) | (K2_bar & q2);
            q3 <= (J3 & ~q3) | (K3_bar & q3);
            q4 <= (J4 & ~q4) | (K4_bar & q4);
            c5 <= (J5 & ~c5) | (K5_bar & c5);
            c6 <= (J6 & ~c6) | (K6_bar & c6);
        end
    end

    // ---------------------------------------------------------
    // OUTPUT DECODER (7-Segment Display)
    // ---------------------------------------------------------
    // Decodes q1, q2, q3, q4 (BCD) to 7-segment cathodes (0 is ON)
    // Mapping based on 74LS47 behavior mentioned in Source 135
    always @(*) begin
        case ({q1, q2, q3, q4})
            4'b0000: seg = 7'b1000000; // 0
            4'b0001: seg = 7'b1111001; // 1
            4'b0010: seg = 7'b0100100; // 2
            4'b0011: seg = 7'b0110000; // 3
            4'b0100: seg = 7'b0011001; // 4
            4'b0101: seg = 7'b0010010; // 5
            4'b0110: seg = 7'b0000010; // 6
            4'b0111: seg = 7'b1111000; // 7
            4'b1000: seg = 7'b0000000; // 8
            4'b1001: seg = 7'b0010000; // 9
            default: seg = 7'b1111111; // Off
        endcase
    end

    // Keep one digit active (if using a multi-digit display board)
    assign anode = 4'b1110; 

endmodule