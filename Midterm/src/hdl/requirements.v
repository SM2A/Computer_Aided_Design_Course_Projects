module sub_1 (in,out);
    
    parameter N = 8;
    input  [N-1:0]in;
    output [N-1:0]out;
    
    assign out = (in - 1);

endmodule

module register (clk,pin,ld,rst,pout);
    
    parameter N = 8;
    input clk;
    input ld;
    input rst;
    input [N-1:0]pin;
    output reg [N-1:0]pout;

    always @(posedge clk) begin
        if(rst) pout <= 0;
        else pout <= pin;
    end

endmodule

module incrementer (clk,rst,inc,out);
    
    parameter N = 8;
    input clk;
    input rst;
    input inc;
    output reg [N-1:0]out;

    always @(posedge clk) begin
        if(rst) out <= 0;
        else if (inc) out <= (out + 1);
    end

endmodule

module mux2to1 (a,b,s,w);

    parameter N = 8;
    input [N-1:0]a;
    input [N-1:0]b;
    input s;
    output [N-1:0]w;

    assign w = (s == 1'b0) ? a : b; 
    
endmodule

module stack (clk,push,pop,tos,rst,d_in,empty,d_out);

    parameter N = 8;
    input [N-1:0]d_in;
    input clk,push,pop,tos,rst;
    output empty;
    output reg [N-1:0]d_out;

    reg [12:0]top;
    reg [N-1:0]data[8191:0];

    integer i;

    always @(clk) begin
        if (rst) begin
            top <= 7'b0;
            for (i = 0 ; i < 128 ; i = i + 1) begin
                data[i] <= 0;
            end
        end else begin
            if (tos) d_out <= data[top-1];
            if (push) begin data[top] <= d_in; top <= top + 1; end
            if (pop & (top > 0))  begin  d_out <= data[top - 1]; top <= top - 1; end
        end
    end

    assign empty = (top == 13'd0) ? 1'b1 : 1'b0;

    initial begin
        top = 13'd0;
        for (i = 0 ; i < 8192 ; i = i + 1) begin
            data[i] <= 0;
        end
    end
    
endmodule
