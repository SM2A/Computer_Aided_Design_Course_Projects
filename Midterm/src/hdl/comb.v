module datapath (clk,m_s,n_s,m_i,pop,push,rst,inc,ld,n,m,empty,cmp,res);

    input clk;
    input m_s;
    input n_s;
    input m_i;
    input pop;
    input push;
    input rst;
    input inc;
    input ld;
    input [3:0]n;
    input [3:0]m;

    output empty;
    output cmp;
    output [12:0]res;

    wire n_e , m_e;
    wire [3:0]n_s_o;
    wire [3:0]m_s_o;
    wire [3:0]n_s_i;
    wire [3:0]m_s_i;
    wire [3:0]n_r_o;
    wire [3:0]m_r_o;
    wire [3:0]n_sub_o;
    wire [3:0]m_sub_o;
    wire [3:0]m_push_val;

    stack #(4) n_stack(.clk(clk),.push(push),.pop(pop),.d_in(n_s_i),.empty(n_e),.d_out(n_s_o));
    stack #(4) m_stack(.clk(clk),.push(push),.pop(pop),.d_in(m_s_i),.empty(m_e),.d_out(m_s_o));

    register #(4) n_reg(.clk(clk),.pin(n_s_o),.ld(ld),.rst(rst),.pout(n_r_o));
    register #(4) m_reg(.clk(clk),.pin(m_s_o),.ld(ld),.rst(rst),.pout(m_r_o));

    sub_1 #(4) n_sub(.in(n_r_o),.out(n_sub_o));
    sub_1 #(4) m_sub(.in(m_r_o),.out(m_sub_o));

    mux2to1 #(4) n_s_i_(.a(n),.b(n_sub_o),.s(n_s),.w(n_s_i));
    mux2to1 #(4) m_s_i_(.a(m),.b(m_push_val),.s(m_s),.w(m_s_i));
    mux2to1 #(4) m_C  (.a(m_r_o),.b(m_sub_o),.s(m_i),.w(m_push_val));

    incrementer #(13) result(.clk(clk),.rst(rst),.inc(inc),.out(res));

    assign empty = n_e & m_e;

    assign cmp = ((m_s_o == 0) | (m_s_o == n_s_o));

endmodule

module controller (clk,start,empty,cmp,m_s,n_s,m_i,pop,push,rst,inc,ld,done);
    
    input clk;
    inout start;
    input empty;
    input cmp;

    output reg m_s;
    output reg n_s;
    output reg m_i;
    output reg pop;
    output reg push;
    output reg rst;
    output reg inc;
    output reg ld;
    output reg done;

    reg [3:0] ps , ns;

    parameter [3:0] idle = 0 , ready = 1 , in = 2 , check = 3 , pop_ = 4 , compare = 5 , acc = 6 , comb_0 = 7 , comb_1 = 8 , done_ = 9;

    always @(ps,start) begin
        ns = idle;
        case (ps)
            idle    : ns = start ? ready : idle; 
            ready   : ns = start ? ready : in; 
            in      : ns = check; 
            check   : ns = empty ? done_ : pop_; 
            pop_    : ns = compare; 
            compare : ns = cmp ? acc : comb_0; 
            acc     : ns = check; 
            comb_0  : ns = comb_1; 
            comb_1  : ns = check; 
            done_   : ns = idle; 
            default : ns = idle; 
        endcase
    end

    always @(ps) begin
        m_s = 0 ; n_s = 0 ; m_i = 0 ; pop = 0 ; push = 0 ; rst = 0 ; inc = 0 ; ld = 0 ; done = 0 ;
        case (ps)
            in      : begin rst = 1 ; push = 1 ; end
            pop_    : begin ld = 1 ; pop = 1 ; end
            acc     : inc = 1 ;
            comb_0  : begin n_s = 1 ; m_s = 1 ; push = 1 ; end
            comb_1  : begin n_s = 1 ; m_s = 1 ; m_i = 1 ; push = 1 ; end
            done_   : done = 1 ;
        endcase
    end

    always @(posedge clk) begin
        ps <= ns;
    end

endmodule

module comb (clk,start,n,m,done,result);

    input clk;
    input start;
    input [3:0]n;
    input [3:0]m;

    output done;
    output [12:0]result;

    wire m_s;
    wire n_s;
    wire m_i;
    wire pop;
    wire push;
    wire rst;
    wire inc;
    wire ld;
    wire done;
    wire cmp;
    wire empty;

    datapath dp(.clk(clk),.m_s(m_s),.n_s(n_s),.m_i(m_i),.pop(pop),.push(push),.rst(rst),.inc(inc),.ld(ld),.n(n),.m(m),
                .empty(empty),.cmp(cmp),.res(result));
    controller ct(.clk(clk),.start(start),.empty(empty),.cmp(cmp),.m_s(m_s),.n_s(n_s),.m_i(m_i),.pop(pop),.push(push),
                  .rst(rst),.inc(inc),.ld(ld),.done(done));

endmodule
