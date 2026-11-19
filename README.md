# UART TX ASIC Synthesis & Static Timing Analysis

## Project Overview

This project implements and analyzes a UART transmitter using an open-source ASIC design flow.

The objective is to perform RTL verification, logic synthesis, technology mapping, and pre-layout static timing analysis using the Nangate45 standard-cell library.

## Tools and Technology

- RTL Language: Verilog HDL
- Simulation: Icarus Verilog
- Waveform Analysis: GTKWave
- Logic Synthesis: Yosys
- Static Timing Analysis: OpenROAD / OpenSTA
- Standard Cell Library: Nangate45
- Development Environment: Ubuntu WSL2 and VS Code

## Design Specifications

- Module: UART Transmitter
- Clock Frequency: 50 MHz
- Clock Period: 20 ns
- Reset: Active-low asynchronous reset

## Synthesis Results

| Metric | Result |
|---|---|
| Standard Cell Count | 207 |
| Total Cell Area | 431.984 µm² |
| Technology Library | Nangate45 |

## Static Timing Analysis Results

| Metric | Result |
|---|---|
| Overall Setup WNS | +17.64 ns |
| Register-to-Register Setup WNS | +18.90 ns |
| Register-to-Register Hold WNS | -0.12 ns |
| Timing Stage | Pre-layout |

### Setup Timing Analysis

The worst reported register-to-register setup path starts at flip-flop `_348_` and ends at `_379_`.

The path includes multiple levels of combinational logic, including AND4, NAND3, XOR2, and NOR2 standard cells.

The setup slack is +18.90 ns, satisfying the 20 ns clock-period constraint.

### Hold Timing Analysis

The worst reported register-to-register hold path is:

`DFFR_X1/QN → OAI22_X1/ZN → DFFS_X1/D`

- Startpoint: `_337_`
- Endpoint: `_334_`
- Data Arrival Time: 0.08 ns
- Data Required Time: 0.20 ns
- Hold Slack: -0.12 ns

The violation is associated with insufficient minimum data-path delay under the current timing constraints.

Hold repair is deferred to the physical implementation stage, where placement, clock-tree effects, and parasitic delays can be considered.

## Limitations

The current timing results are based on pre-layout analysis with an ideal clock network and without extracted interconnect parasitics.

The reported results are not post-route timing signoff.

## Conclusion

The UART TX design was synthesized and technology-mapped to Nangate45 standard cells.

Static timing analysis confirmed positive setup slack at the target clock frequency and identified a 120 ps register-to-register hold violation for future physical-design optimization.