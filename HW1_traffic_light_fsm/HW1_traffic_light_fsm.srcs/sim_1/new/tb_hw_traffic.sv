module tb_hw_traffic;

logic clk;
logic reset;
logic taorb;
logic [1:0] la;
logic [1:0] lb;

hw_traffic dut (
    .clk(clk),
    .reset(reset),
    .taorb(taorb),
    .la(la),
    .lb(lb)
);

initial begin
    clk = 0;
end

always #5 clk = ~clk;

initial begin
    reset = 1;
    taorb = 0;
    #20;
    reset = 0;

    #40;
    taorb = 1;

    #120;
    taorb = 0;

    #120;
    taorb = 1;

    #120;
    taorb = 0;

    #150;
    $finish;
end

endmodule