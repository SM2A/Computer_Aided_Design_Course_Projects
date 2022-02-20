`timescale 1ns/1ns

module testbench ();

    reg clk = 0 , rst = 1 , start = 0;
    wire done;
    reg [4:0]n = 5'd6;
    wire [120:0]ans;

    fibonacci test(.clk(clk),.start(start),.reset(rst),.n(n),.done(done),.ans(ans));

    always #1 clk = ~clk;

    initial begin

        #20 rst = 0;
        #20 start = 1;
        #20 start = 0;
        #10000 n = 5'd3;

        #20 rst = 1;
        #20 rst = 0;
        #20 start = 1;
        #20 start = 0;
        #10000 n = 5'd8;

        #20 rst = 1;
        #20 rst = 0;
        #20 start = 1;
        #20 start = 0;
        #10000 n = 5'd15;

        #20 rst = 1;
        #20 rst = 0;
        #20 start = 1;
        #20 start = 0;
        #250000 n = 5'd25;

        #20 rst = 1;
        #20 rst = 0;
        #20 start = 1;
        #20 start = 0;
        #5000000;

        #100 $stop;
    end
    
endmodule
