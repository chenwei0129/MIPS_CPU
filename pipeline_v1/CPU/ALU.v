`timescale 1ns/100ps
module ALU(src1_i, src2_i, ALU_control_i, result_o);

  input signed [`WIDTH - 1:0] src1_i;
  input signed [`WIDTH - 1:0] src2_i;
  input [`ALUCONTROL_WIDTH - 1:0] ALU_control_i;
  
  output reg [`WIDTH - 1:0] result_o;

  wire signed [`WIDTH - 1:0] result_temp;
  wire [`WIDTH - 1:0] src2_temp;
  wire C0_temp;

  assign src2_temp = (ALU_control_i==4'b0010)?src2_i:(~src2_i);
  assign C0_temp = (ALU_control_i==4'b0010)?1'b0:1'b1;

  CLA_adder CLA_adder(.src1  (src1_i),
                      .src2  (src2_temp),
                      .C0    (C0_temp),
                      .result(result_temp));
  
  always@(*)begin
    case(ALU_control_i)
      4'b0010:
	    result_o = result_temp;
	  4'b0110:
	    result_o = result_temp;
	  4'b0000:
	    result_o = src1_i & src2_i;
	  4'b0001:
	    result_o = src1_i | src2_i;
	  4'b0111:
        result_o = (result_temp<0)?`WIDTH'd1:`WIDTH'b0;
	  4'b1000:
	    result_o = (src2_i << src1_i);
	  default:
	    result_o = 32'b0;
    endcase
  end

endmodule
