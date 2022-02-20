`timescale 1ns/1ns

module testbench ();

    reg clk = 0 , start = 0;
    wire done;
    reg [4:0]n = 5'd2;
    reg [4:0]m = 5'd1;
    wire [12:0]result;

    comb test(.clk(clk),.start(start),.n(n),.m(m),.done(done),.result(result));

    always #1 clk = ~clk;

    initial begin

        #20 start = 1;
        #20 start = 0;
        #200

        n = 5'd7;
        m = 5'd3;
        #20 start = 1;
        #20 start = 0;
        #800

        n = 5'd10;
        m = 5'd4;
        #20 start = 1;
        #20 start = 0;
        #4000

        n = 5'd15;
        m = 5'd15;
        #20 start = 1;
        #20 start = 0;
        #100

        n = 5'd15;
        m = 5'd7;
        #20 start = 1;
        #20 start = 0;
        #200000

        #100 $stop;
    end
    
endmodule
