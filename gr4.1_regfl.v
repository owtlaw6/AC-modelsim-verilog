module regfl(
  input clk, rst_b,we,
  input [2:0] s,
  input [63:0] d,
  output [511:0] q
);
  wire [7:0] dout;
  dec #(.w(3)) inst1(.e(we),.s(s),.o(dout));
  generate
    genvar i;
    for (i=0;i<8;i=i+1) begin:g
      rgst #(.w(64)) ig(.clk(clk),.rst_b(rst_b),.clr(1'd0),
        .ld(dout[0]),.d(d),.q(q[511-i*64:511-i*64-63]));
    end
  endgenerate
endmodule

module regfl_tb;
  reg clk, rst_b,we;
  reg [2:0] s;
  reg [63:0] d;
  wire [511:0] q;
  
  regfl inst1(.clk(clk),.rst_b(rst_b),.we(we),.s(s),.d(d),.q(q));
  
  task urand64(output reg [63:0] r);
    begin
      r[63:32] = $urandom;
      r[31:0] = $urandom;
    end
  endtask
  
  localparam CLK_PERIOD=100;
  localparam RUNNING_CYCLES=13;
  initial begin
    clk=0;
    repeat (2*RUNNING_CYCLES) #(CLK_PERIOD/2) clk=~clk;
  end
  localparam RST_DURATION=25;
  initial begin
    rst_b=0;
    #RST_DURATION rst_b=1;
  end
  initial begin
    we=1;
    #(6*CLK_PERIOD) we=~we;
    #(1*CLK_PERIOD) we=~we;
  end
  integer k;
  initial begin
    s=$urandom;
    for (k=1; k<13; k=k+1)
      #(1*CLK_PERIOD) s=$urandom;
  end
  initial begin
    urand64(d);
    for (k=1; k<13; k=k+1)
      #(1*CLK_PERIOD) urand64(d);
  end
endmodule