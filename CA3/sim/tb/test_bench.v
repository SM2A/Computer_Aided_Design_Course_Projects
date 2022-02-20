`timescale 1ns/1ns

module test_bench ();

    reg clk = 1;
	reg start = 0;
	reg [9 : 0]index = 0;

	wire done;
	wire [9 : 0]max;
	wire [79 : 0]ans;

    MLP test(clk, start, index, max, done, ans);

    always #1 clk = ~clk;

    integer file, i;

    initial begin
        file = $fopen("iop/predict.txt", "w");
        #10 start = 1;
		for (i = 1 ; i < 751 ; i = i + 1) begin
            #550 index = i;
            $fwriteb(file, "%d\n", max);
        end
        #550 $stop;
    end
    
endmodule
