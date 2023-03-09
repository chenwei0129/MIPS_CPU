`include "def.v"
`include "I_memory.v"
`include "D_memory.v"
`include "CPU/PC.v"
`include "CPU/regfile.v"
`include "CPU/ALU.v"
`include "CPU/adder.v"
`include "CPU/sign_extend.v"
`include "CPU/MUX_5.v"
`include "CPU/MUX_32.v"
`include "CPU/control.v"
`include "CPU/ALUcontrol.v"
`timescale 1ns/100ps

`ifdef syn
`include "CPU/CPU_syn_22.v"
`include "CPU/tsmc18.v"
`else
`include "CPU/CPU.v"
`endif

module testbench;

  reg clk;
  reg rst_n;
  
  wire [`WIDTH - 1:0] ins;
  wire [`WIDTH - 1:0] read_data;
  wire [`WIDTH - 1:0] pc_o;
  wire [`WIDTH - 1:0] result;
  wire [`WIDTH - 1:0] read_data2;
  
  CPU CPU(.clk       (clk),
          .rst_n     (rst_n),
		  .ins       (ins),
		  .read_data (read_data),
		  .pc_o      (pc_o),
		  .MemWrite  (MemWrite),
		  .MemRead   (MemRead),
		  .result    (result),
		  .read_data2(read_data2));

  I_memory I_memory(.clk (clk),
                    .addr(pc_o),
					.ins (ins));
  
  D_memory D_memory(.clk         (clk),
                    .memory_write(MemWrite),
					.memory_read (MemRead),
					.addr        (result),
					.write_data  (read_data2),
					.read_data   (read_data));

  always #11 clk = ~clk;

  `ifdef syn
    initial $sdf_annotate("CPU_syn_22.sdf", CPU);
  `endif

  initial begin
    $readmemb("sisc.prog",I_memory.I_MEM);
           clk = 1'b0;
	       rst_n = 1'b1;
    #2     rst_n = 1'b0;
	#100   rst_n = 1'b1;
	#15000 
	       if((D_memory.MEMORY[20]<=D_memory.MEMORY[21])&&
		      (D_memory.MEMORY[21]<=D_memory.MEMORY[22])&&
			  (D_memory.MEMORY[22]<=D_memory.MEMORY[23])&&
			  (D_memory.MEMORY[23]<=D_memory.MEMORY[24])&&
			  (D_memory.MEMORY[24]<=D_memory.MEMORY[25])&&
			  (CPU.regfile.REGFILE[16]==7733))begin
		     $display("              /////////////////////////////////////////////");
			 $display("              //                                         //");
			 $display("              //            CONGRATULATION!!             //");
			 $display("              //          All data is correct!!          //");
			 $display("              //                                         //");
		     $display("              /////////////////////////////////////////////");
		   end
		   else begin
		     $display("              /////////////////////////////////////////////");
			 $display("              //                                         //");
			 $display("              //                 SOORY!!                 //");
			 $display("              //        The result is incorrect!!        //");
			 $display("              //                                         //");
		     $display("              /////////////////////////////////////////////");
		   end
	       $finish;
	/*
	$fsdbDumpfile("CPU.fsdb");
	$fsdbDumpMDA;
	$fsdbDumpvars;
	*/
	//bubble sort
	//$monitor("%d %d %d %d %d %d %d", $time, D_memory.MEMORY[20], D_memory.MEMORY[21], D_memory.MEMORY[22], D_memory.MEMORY[23], D_memory.MEMORY[24], D_memory.MEMORY[25]);
    //fibonacci
	//$monitor("%d %d", $time, CPU.regfile.REGFILE[3]);
	//double data hazard
	//$monitor("%d %d", $time, CPU.regfile.REGFILE[1]);
	//load use hazard
	//$monitor("%d %d", $time, CPU.regfile.REGFILE[5]);
	//load branch hazard
	//$monitor("%d %d", $time, CPU.regfile.REGFILE[5]);
	//use branch
	//$monitor("%d %d", $time, CPU.regfile.REGFILE[1]);
	//no hazard
	//$monitor("%d %d", $time, CPU.regfile.REGFILE[11]);
  end

endmodule
