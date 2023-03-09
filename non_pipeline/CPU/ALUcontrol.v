`timescale 1ns/100ps
module ALUcontrol(func, ALUOp, ALU_control);

  input [`FUNC_WIDTH - 1:0] func;
  input [`ALUOp_WIDTH - 1:0] ALUOp;
  
  output reg [`ALUCONTROL_WIDTH - 1:0] ALU_control;
  
  always@(*)begin
      case(ALUOp)
	    2'b00:
		  ALU_control = `ALUCONTROL_WIDTH'b0010;
		2'b01:
		  ALU_control = `ALUCONTROL_WIDTH'b0110;
		2'b10:begin
          case(func)
		    6'b100000:
			  ALU_control = `ALUCONTROL_WIDTH'b0010;
			6'b100010:
			  ALU_control = `ALUCONTROL_WIDTH'b0110;
			6'b100100:
			  ALU_control = `ALUCONTROL_WIDTH'b0000;
			6'b100101:
			  ALU_control = `ALUCONTROL_WIDTH'b0001;
			6'b101010:
			  ALU_control = `ALUCONTROL_WIDTH'b0111;
			6'b110000:
			  ALU_control = `ALUCONTROL_WIDTH'b1000;
			default:
			  ALU_control = `ALUCONTROL_WIDTH'b1111;
		  endcase
        end
        default:
          ALU_control = `ALUCONTROL_WIDTH'b1111;		
	  endcase
  end

endmodule
