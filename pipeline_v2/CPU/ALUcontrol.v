`timescale 1ns/100ps
module ALUcontrol(func_i, ALUOp_i, ALU_control_o);

  input [`FUNC_WIDTH - 1:0] func_i;
  input [`ALUOp_WIDTH - 1:0] ALUOp_i;
  
  output reg [`ALUCONTROL_WIDTH - 1:0] ALU_control_o;
  
  always@(*)begin
      case(ALUOp_i)
	    2'b00://SW LW ADDI
		  ALU_control_o = `ALUCONTROL_WIDTH'b0010;
		2'b01://BR
		  ALU_control_o = `ALUCONTROL_WIDTH'b0110;
		2'b10:begin
          case(func_i)
		    6'b100000://ADD
			  ALU_control_o = `ALUCONTROL_WIDTH'b0010;
			6'b100010:////SUB
			  ALU_control_o = `ALUCONTROL_WIDTH'b0110;
			6'b100100://AND
			  ALU_control_o = `ALUCONTROL_WIDTH'b0000;
			6'b100101://OR
			  ALU_control_o = `ALUCONTROL_WIDTH'b0001;
			6'b101010://SLT
			  ALU_control_o = `ALUCONTROL_WIDTH'b0111;
			6'b010100://DSLLV
			  ALU_control_o = `ALUCONTROL_WIDTH'b1000;
			default:
			  ALU_control_o = `ALUCONTROL_WIDTH'b1111;
		  endcase
        end
        default:
          ALU_control_o = `ALUCONTROL_WIDTH'b1111;		
	  endcase
  end

endmodule
