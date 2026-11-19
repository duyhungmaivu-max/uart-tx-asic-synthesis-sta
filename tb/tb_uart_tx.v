`timescale 1ns/1ps

module tb_uart_tx;

reg clk = 0;
reg rst_n = 0;
reg tx_start = 0;
reg [7:0] tx_data = 0;

wire tx;
wire tx_busy;

localparam CLK_PERIOD = 20;
localparam CLKS_PER_BIT = 50000000 / 115200;
localparam BIT_TIME = CLKS_PER_BIT * CLK_PERIOD;

integer i;
integer errors = 0;

uart_tx dut (
    .clk(clk),
    .rst_n(rst_n),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);

always #(CLK_PERIOD/2) clk = ~clk;

// Check UART bit
task check_bit;
    input expected;
    begin
        if (tx !== expected) begin
            $display("FAIL: Expected %b, got %b at %0t",
                     expected, tx, $time);
            errors = errors + 1;
        end
    end
endtask

initial begin
    $dumpfile("uart_tx.vcd");
    $dumpvars(0, tb_uart_tx);

    // Reset
    repeat (5) @(negedge clk);
    rst_n = 1;

    // Send 0xA5
    @(negedge clk);
    tx_data = 8'hA5;
    tx_start = 1;

    @(negedge clk);
    tx_start = 0;

    // Wait for start bit
    @(negedge tx);
    #(BIT_TIME/2);
    check_bit(1'b0);

    // Check 8 data bits, LSB first
    for (i = 0; i < 8; i = i + 1) begin
        #(BIT_TIME);
        check_bit(tx_data[i]);
    end

    // Check stop bit
    #(BIT_TIME);
    check_bit(1'b1);

    // Wait for transmission completion
    wait(tx_busy == 0);

    if (errors == 0)
        $display("PASS: UART TX transmitted 0xA5 correctly");
    else
        $display("FAIL: %0d errors detected", errors);

    #100;
    $finish;
end

initial begin
    #200000;
    $display("FAIL: Simulation timeout");
    $finish;
end

endmodule
