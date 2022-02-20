`timescale 1ns/1ns

module auto_testbench ();

    reg clk = 0 , reset = 1 , start = 0, test_clk = 0;
    wire done;
    reg [4:0]n;
    wire [120:0]ans;
	reg [120 : 0] expected_ans;
	reg [31 : 0] vector_ind;
	reg [5 : 0] errors;
	reg [5 : 0] tests;
	reg [125 : 0] test_vectors[31 : 0];

    fibonacci test(.clk(clk),.start(start),.reset(reset),.n(n),.done(done),.ans(ans));

    always #1 clk = ~clk;

	initial begin
		$readmemb("E:/Files/University/Term5/CAD/HW/2/trunk/sim/file/fib.tv", test_vectors);
		vector_ind = 0;
		errors = 0;
		tests = 15;
		reset = 1;
		#4 reset = 0;
	end

    always begin
		test_clk = 1;
		#50000;
		test_clk = 0;
		#50;
	end

	always @(posedge test_clk)
	begin
		#1;
		reset = 1;
		#9;
		reset = 0;
		{n, expected_ans} = test_vectors[vector_ind];
		start = 1;
		#6;
		start = 0;
	end

	always @(negedge test_clk)
	begin
		if ($time > 10)
		begin
			if (ans != expected_ans)
			begin
				errors = errors + 1;
				$display("Wrong, Input: %d", n);
				$display("Output: %d, Expected: %d", ans, expected_ans);
			end
			else
			begin
				$display("Right answer, n = %d, ans = %d", n, ans);
			end
			vector_ind = vector_ind + 1;
			if (vector_ind == tests)
			begin
				$display("%d tests complited with %d errors", vector_ind, errors);
				$stop;
			end
		end
	end

endmodule
