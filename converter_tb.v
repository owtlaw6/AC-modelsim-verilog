module converter_tb(
  output reg [7:0]i,
  output [7:0]o);
converter DUT(
  .i(i),
  .o(o));
integer j;
initial begin
  i = 8'd0;
  for(j=0; j<256; j=j+1)
    #30 i = j;
end
endmodule 