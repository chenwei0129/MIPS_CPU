`timescale 1ns/100ps
module ALU(src1, src2, ALU_control, zero, result);

  input signed [`WIDTH - 1:0] src1;
  input signed [`WIDTH - 1:0] src2;
  input [`ALUCONTROL_WIDTH - 1:0] ALU_control;
  
  output zero;
  output reg [`WIDTH - 1:0] result;
  
  assign zero = ((src1 - src2)==32'b0)?1'b1:1'b0;
  
  always@(*)begin
    case(ALU_control)
      4'b0010:
	    result = src1 + src2;
	  4'b0110:
	    result = src1 - src2;
	  4'b0000:
	    result = src1 & src2;
	  4'b0001:
	    result = src1 | src2;
	  4'b0111:
        result = (src1 - src2<0)?`WIDTH'd1:`WIDTH'b0;
	  default:
	    result = 32'b0;
    endcase
  end

endmodule
