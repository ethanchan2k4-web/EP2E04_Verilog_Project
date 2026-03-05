# Custom Finite State Machine: 9-Digit Sequence Generator

**Author:** Ethan Chan  
**Context:** McMaster University Engineering Physics (ENGPHYS 2E04: Analog and Digital Circuits)

## Project Overview
This project involves the analytical design and hardware-level implementation of a custom Finite State Machine (FSM). The circuit is designed using sequential logic to continuously cycle through a specific 9-digit student number (400473109) and output the result to a 7-segment display.

The design was initially modeled using Multisim for timing verification and has been translated into Verilog to demonstrate hardware description language competencies.

## Hardware Specifications & Component Targeting
The physical and structural logic design was built targeting the following discrete logic ICs:
* **6x 74HC109N** Dual J-K Flip-Flops (with !K and Preset/Clear)
* **74HC00N / 74HC32N** Generic 2-Input AND/OR Gates
* **74LS47D** BCD to 7-Segment Decoder

## Design Methodology

### 1. State Encoding & Analytical Solution
The sequence requires cycling through digits that repeat (specifically the digit '0' three times and '4' twice). To differentiate these repeated states, two internal counter bits ($C_5$, $C_6$) were introduced alongside the four BCD bits ($Q_1, Q_2, Q_3, Q_4$).
* **State Transition:** A comprehensive transition table was developed to map current states to next states, ensuring the counters successfully distinguished identical BCD outputs.

### 2. Logic Minimization (K-Mapping)
Using the characteristic equations for J-!K flip-flops ($Q_{next} = J\bar{Q} + \bar{K}Q$), an excitation table was derived. 
* **Optimization:** Six-variable Karnaugh maps were utilized to determine the Sum of Products (SOP) expressions for every J and !K input.
* **Efficiency:** Hardware optimization was prioritized; for instance, the product term $(Q_2)(C_6)$ was reused to reduce the total count of required AND gate chips.

### 3. Verification
The combinational logic was verified via Multisim simulation. LED indicators tracked the internal state of the BCD and counter bits, while a logic analyzer confirmed the sequence: 
`4a -> 0a -> 0b -> 4b -> 7a -> 3a -> 1a -> 0c -> 9a` 
This sequence perfectly matched the clock cycle's rising edges.

## Verilog Implementation
The accompanying `student_num.v` file contains the structural Verilog implementation of the derived Boolean expressions. The `student_num_tb.v` testbench mimics the original 40Hz clock used in the schematic design to verify the FSM transitions.