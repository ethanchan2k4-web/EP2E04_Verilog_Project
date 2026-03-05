# Custom Finite State Machine: 9-Digit Sequence Generator

[cite_start]**Author:** Ethan Chan [cite: 5]  
[cite_start]**Context:** McMaster University Engineering Physics (ENGPHYS 2E04: Analog and Digital Circuits) [cite: 1]  

## Project Overview
[cite_start]This project involves the analytical design and hardware-level implementation of a custom Finite State Machine (FSM)[cite: 11]. [cite_start]The circuit is designed using sequential logic to continuously cycle through a specific 9-digit sequence (400473109) [cite: 11, 16] [cite_start]and output the result to a 7-segment display[cite: 11]. 

[cite_start]The design was initially modeled using Multisim for timing verification [cite: 10, 144] and has been translated into Verilog to demonstrate hardware description language competencies.

## Hardware Specifications & Component Targeting
The physical and structural logic design was built targeting the following discrete logic ICs:
* [cite_start]**6x 74HC109N** Dual J-K Flip-Flops (with $\overline{K}$ and Preset/Clear) [cite: 113]
* [cite_start]**74HC00N / 74HC32N** Generic 2-Input AND/OR Gates [cite: 113, 114]
* [cite_start]**74LS47D** BCD to 7-Segment Decoder [cite: 135]

## Design Methodology

### 1. State Encoding & Analytical Solution
[cite_start]The sequence requires cycling through digits that repeat (e.g., three instances of '0', two instances of '4')[cite: 26, 30]. [cite_start]To differentiate these repeated states, two internal counter bits ($C_5$, $C_6$) were introduced alongside the four BCD bits ($Q_1, Q_2, Q_3, Q_4$) representing the digits[cite: 26]. 
* [cite_start]**State Transition:** A comprehensive transition table was developed to map current states to next states, ensuring the counters successfully distinguished identical BCD outputs[cite: 24, 25, 26].

### 2. Logic Minimization (K-Mapping)
[cite_start]Using the characteristic equations for J-$\overline{K}$ flip-flops, an excitation table was derived[cite: 31, 32]. 
* [cite_start]Six-variable Karnaugh maps were utilized to determine the Sum of Products (SOP) expressions for every $J$ and $\overline{K}$ input[cite: 40, 50, 51].
* [cite_start]Hardware optimization was prioritized; for instance, reusing the product term $(Q_2)(C_6)$ reduced the total required AND gate chips[cite: 100, 105, 108]. 

### 3. Verification
[cite_start]The combinational logic was verified via Multisim[cite: 121]. [cite_start]LED indicators tracked the internal state of the BCD and counter bits [cite: 128][cite_start], while a logic analyzer confirmed the $4a \rightarrow 0a \rightarrow 0b \rightarrow 4b \rightarrow 7a \rightarrow 3a \rightarrow 1a \rightarrow 0c \rightarrow 9a$ sequence perfectly matched the clock cycle's rising edges[cite: 146, 148, 153].

## Verilog Implementation
[cite_start]The accompanying `student_num.v` file contains the structural Verilog implementation of the derived Boolean expressions[cite: 89, 90, 91]. [cite_start]The `student_num_tb.v` testbench mimics the original 40Hz clock [cite: 133] used in the schematic design to verify the FSM transitions.