`timescale 1ns/100ps
module compare(data1_i, data2_i, equal_o);

  input [`WIDTH - 1:0] data1_i;
  input [`WIDTH - 1:0] data2_i;
  
  output equal_o;
  
  assign equal_o = (data1_i==data2_i)?1'b1:1'b0;

endmodule