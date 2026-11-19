# ==========================================
# UART TX - Static Timing Analysis
# Technology: Nangate45
# Clock: 50 MHz
# ==========================================

# 1. Load technology LEF
read_lef ../OpenROAD-flow-scripts/flow/platforms/nangate45/lef/NangateOpenCellLibrary.tech.lef

# 2. Load standard cell LEF
read_lef ../OpenROAD-flow-scripts/flow/platforms/nangate45/lef/NangateOpenCellLibrary.macro.lef

# 3. Load Liberty
read_liberty ../OpenROAD-flow-scripts/flow/platforms/nangate45/lib/NangateOpenCellLibrary_typical.lib

# 4. Load synthesized netlist
read_verilog netlist/uart_tx_nangate.v

# 5. Link design
link_design uart_tx

# 6. Load timing constraints
read_sdc constraints/uart_tx.sdc

# 7. Setup timing
report_checks -path_delay max \
    -group_path_count 10 \
    -fields {slew cap fanout} \
    > reports/setup_timing.rpt

# 8. Hold timing
report_checks -path_delay min \
    -group_path_count 10 \
    -fields {slew cap fanout} \
    > reports/hold_timing.rpt

# 9. Worst setup slack
report_worst_slack -max \
    > reports/wns_setup.rpt

# 10. Worst hold slack
report_worst_slack -min \
    > reports/wns_hold.rpt

# 11. Design rule violations
report_check_types \
    -max_slew -max_capacitance -max_fanout \
    -violators \
    > reports/design_violations.rpt


# ==========================================
# REGISTER-TO-REGISTER SETUP ANALYSIS
# ==========================================

set regs [all_registers]

report_checks \
    -from $regs \
    -to $regs \
    -path_delay max \
    -group_path_count 10 \
    -fields {slew cap fanout} \
    > reports/setup_reg2reg.rpt

# Register-to-register hold analysis
report_checks \
    -from $regs \
    -to $regs \
    -path_delay min \
    -group_path_count 10 \
    -fields {slew cap fanout} \
    > reports/hold_reg2reg.rpt