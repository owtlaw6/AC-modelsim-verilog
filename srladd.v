module srladd(  //mealy
  input clk,
  input rst_b,
  input x,
  input y,
  output z
  
);

  localparam S0_ST=0;
  localparam S1_ST=1;
  
  reg st;
  reg st_nxt;
  
  always @(*)
    case (st)
      S0_ST: if(x && y) st_nxt=S1_ST;
             else       st_nxt=S0_ST;
      S1_ST: if(!x && !y) st_nxt=S0_ST;
             else         st_nxt=S1_ST;
    endcase
  assign z = x^y^st;
  always @(posedge clk, negedge rst_b)
          if(!rst_b) st<=S0_ST;
            else st<=st_nxt;
endmodule

module srladd_tb;
  reg clk, rst_b, x, y;
  wire z;
  
  srladd inst1(.clk(clk),.rst_b(rst_b),.x(x),.y(y),.z(z));
  
  localparam CLK_PERIOD=100;
  localparam RUNNING_CYCLES=5;
  
  initial begin
    clk=0;
    repeat (2*RUNNING_CYCLES) #(CLK_PERIOD/2) clk=~clk;
  end
  
  localparam RST_DURATION=20;
  initial begin
    rst_b=0;
    #RST_DURATION rst_b=1;
    // #10 rst_b=1;
  end
  
  initial begin
    x=0;
    #(1*CLK_PERIOD) x=~x; //1
    #(1*CLK_PERIOD) x=~x; //0
    #(1*CLK_PERIOD) x=~x; //1
    #(1*CLK_PERIOD) x=~x; //0
    #(1*CLK_PERIOD) x=~x; //1
  end
  
   initial begin
    y=0;
    #(2*CLK_PERIOD) y=~y; //1
    #(2*CLK_PERIOD) y=~y; //1
    
  end
endmodule
  