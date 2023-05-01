module pat(  //moore
  input clk,
  input rst_b,
  input i,
  output o
  
);
  localparam S0_ST=0;
  localparam S1_ST=1;
  localparam S2_ST=2;
  localparam S3_ST=3;
  localparam S4_ST=4;
  localparam S5_ST=5;
  
  reg [2:0] st;
  reg [2:0] st_nxt;   //pe 3 bits din cauza ca ai pana la 5 care e pe 3 bits 
  
  always @(*)
    case (st)
      S0_ST: if (!i) st_nxt=S0_ST;
             else    st_nxt=S1_ST;
      S1_ST: if(i)   st_nxt=S1_ST;
             else    st_nxt=S2_ST;
      S2_ST: if(i)   st_nxt=S3_ST;
             else    st_nxt=S0_ST;
      S3_ST: if(i)   st_nxt=S4_ST;
             else    st_nxt=S2_ST;
      S4_ST: if(i)   st_nxt=S1_ST;
             else    st_nxt=S5_ST;
      S5_ST: if(i)   st_nxt=S3_ST;
             else    st_nxt=S0_ST;
      endcase
      
      assign o = (st == S5_ST);
      
      always @(posedge clk, negedge rst_b)
          if(!rst_b) st<=S0_ST;
            else st<=st_nxt;
endmodule

module pat_tb;
  reg clk, rst_b, i;
  wire o;
  
  pat inst1(.clk(clk),.rst_b(rst_b),.i(i),.o(o));
  localparam CLK_PERIOD=50;
  localparam RUNNING_CYCLES=12;
  
  initial begin
    clk=0;
    repeat (2*RUNNING_CYCLES) #(CLK_PERIOD/2) clk=~clk;
    //repeat (2*12) #(50/2) clk=~clk;
  end
  
  localparam RST_DURATION=10;
  initial begin
    rst_b=0;
    #RST_DURATION rst_b=1;
    // #10 rst_b=1;
  end
  
  initial begin
    i=1;
    #(2*CLK_PERIOD) i=~i; //  #100 i=~i; adica i trece pe 0
    repeat (3) begin
      #(1*CLK_PERIOD) i=~i;
      #(2*CLK_PERIOD) i=~i;
    end
  end
endmodule
  
  
  
  