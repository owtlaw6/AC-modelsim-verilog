//P.9.1 Implementați, utilizând limbajul Verilog, un numărător divide-by-5 descris în arhitectura de mai jos
module rgst #(parameter w=3)
(
    input [w-1:0]d,
    input ld,rst_b,clk,clr,
    output reg [w-1:0]q
);

always @(posedge clk, negedge rst_b) begin
    if(!rst_b || clr) q<= 0;
        else if(ld) q<=d;
end
endmodule

module d5_cntr( 
    input clr, c_up, rst_b, clk,
    output d_clk
);

wire mod;
wire [2:0]q;
assign mod = q[2] | clr;

rgst counter(.ld(c_up), .clr(mod), .clk(clk), .rst_b(rst_b), .d({(q[2]^(q[1]&q[0])), (q[1]^q[0]), (~q[0])}), .q(q));

assign d_clk =~(q[2] | q[1] | q[0]); 
endmodule
//P.9.2 Verificați modulul d5cntr cu un testbench care generează intrările precum este ilustrat în cronograma de mai jos

module d5_cntr_tb(
    output reg clk, rst_b, clr, c_up,
    output d_clk
);
d5_cntr DUT(.clk(clk), .rst_b(rst_b), .clr(clr), .c_up(c_up), .d_clk(d_clk));

initial begin
    clk = 1'd0;
    forever #20 clk = ~clk;
end
initial begin
    rst_b = 1'd0;
    #5 rst_b = 1'b1;
end
initial begin
    clr = 1'd0;
    #140 clr=1'd1;
    #20 clr = 1'd0;
end
initial begin
    c_up = 1'd1;
    #80 c_up = 1'd0;
    #20 c_up = 1'd1;
    #80 c_up = 1'd0;
    #40 c_up = 1'd1;
end
endmodule
//P.9.3 Construiți, folosind limbajul Verilog, diagrama de tranziții corespunzătoare numărătorului divide-by-5 descrisă în figura de mai jos
module d5_cntr_fsm(
    input clk, rst_b, clr, c_up,
    output d_clk
);
reg [4:0] din;
wire [4:0] din_nxt;

assign din_nxt[1] = (din[0] & c_up &(~clr)) | (din[1] & (~c_up) & (~clr));
assign din_nxt[2] = (din[1] & c_up & (~clr)) | (din[2] & (~c_up) & (~clr));
assign din_nxt[3] = (din[2] & c_up & (~clr)) | (din[3] & (~c_up) & (~clr));
assign din_nxt[4] = (din[3] & c_up &(~clr)) | (din[4] &(~c_up) & (~clr));
assign din_nxt[0] = (din[0] & (~c_up) & (~clr)) | (din[4] & c_up & (~clr)) | clr;

assign d_clk = din[0];

always @(posedge clk, negedge rst_b)
if(!rst_b) din <= 5'd1;
else din <= din_nxt;
endmodule