`include "CPU/def.v"
`include "CPU/PC.v"
`include "CPU/adder.v"
`include "CPU/MUX_32.v"
`include "CPU/MUX_pc.v"
`include "CPU/IF_ID_reg.v"
`include "CPU/regfile.v"
`include "CPU/sign_extend.v"
`include "CPU/compare.v"
`include "CPU/MUX_8.v"
`include "CPU/controller.v"
`include "CPU/hazard_detection_unit.v"
`include "CPU/ID_EX_reg.v"
`include "CPU/MUX4_32.v"
`include "CPU/ALU.v"
`include "CPU/ALUcontrol.v"
`include "CPU/MUX_5.v"
`include "CPU/forwarding_unit.v"
`include "CPU/EX_MEM_reg.v"
`include "CPU/MEM_WB_reg.v"
`include "ROM/I_memory.v"
`include "RAM/D_memory.v"
`timescale 1ns/100ps

`ifdef syn
`include "CPU/CPU_syn_12.v"
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
  
  CPU CPU(.clk_i           (clk),
          .rst_n_i         (rst_n),
		  .ins_i           (ins),
		  .data_from_mem_i (read_data),
		  .pc_o            (pc_o),
		  .MEM_ctrl_o      ({MemWrite, MemRead}),
		  .mem_write_addr_o(result),
		  .mem_write_data_o(read_data2));

  I_memory I_memory(.addr_d     (pc_o),
					.read_data_q(ins));
  
  D_memory D_memory(.clk_i       (clk),
                    .mem_write_d (MemWrite),
					.mem_read_d  (MemRead),
					.addr_d      (result),
					.write_data_d(read_data2),
					.read_data_q (read_data));

  always #(`CYCLE/2) clk = ~clk;
  
  `ifdef syn
    initial $sdf_annotate("CPU/CPU_syn_12.sdf", CPU);
  `endif

  initial begin
    $readmemb("sisc.prog",I_memory.MEMORY);
           clk = 1'b0;
	       rst_n = 1'b1;
    #2     rst_n = 1'b0;
	#100   rst_n = 1'b1;
	#8000  
		   $display("");
		   $display("");
		   if((D_memory.MEMORY[20]<=D_memory.MEMORY[21])&&
		      (D_memory.MEMORY[21]<=D_memory.MEMORY[22])&&
			  (D_memory.MEMORY[22]<=D_memory.MEMORY[23])&&
			  (D_memory.MEMORY[23]<=D_memory.MEMORY[24])&&
			  (D_memory.MEMORY[24]<=D_memory.MEMORY[25]))
			                               $display("                     bubble sort.s------------->pass");
		   else                            $display("                     bubble sort.s------------->error");
		   
	       if(CPU.regfile.REGFILE[13]==233)$display("                     fibonacci.s--------------->pass");
		   else                            $display("                     fibonacci.s--------------->error");
		   
	       if(CPU.regfile.REGFILE[14]==1000)$display("                     double data hazard.s------>pass");
		   else                             $display("                     double data hazard.s------>error");
		   
	       if(CPU.regfile.REGFILE[15]==2000)$display("                     load use hazard.s--------->pass");
		   else                             $display("                     load use hazard.s--------->error");
		   
	       if(CPU.regfile.REGFILE[16]==2800)$display("                     load branch hazard.s------>pass");
		   else                             $display("                     load branch hazard.------->error");
		   
	       if(CPU.regfile.REGFILE[17]==6800)$display("                     use branch hazard.s------->pass");
		   else                             $display("                     use branch hazard.s------->error");
		   
		   if(CPU.regfile.REGFILE[19]==12833)$display("                     jump.s-------------------->pass");
		   else                              $display("                     jump.s-------------------->error");
		   
	       if((D_memory.MEMORY[20]<=D_memory.MEMORY[21])&&
		      (D_memory.MEMORY[21]<=D_memory.MEMORY[22])&&
			  (D_memory.MEMORY[22]<=D_memory.MEMORY[23])&&
			  (D_memory.MEMORY[23]<=D_memory.MEMORY[24])&&
			  (D_memory.MEMORY[24]<=D_memory.MEMORY[25])&&
			  (CPU.regfile.REGFILE[19]==12833))begin
		     $display("");
		     $display("");
		     $display("              /////////////////////////////////////////////");
			 $display("              //                                         //");
			 $display("              //            CONGRATULATION!!             //");
			 $display("              //          All data is correct!!          //");
			 $display("              //                                         //");
		     $display("              /////////////////////////////////////////////");
		     $display("");
		     $display("");
		   end
		   else begin
		     $display("");
		     $display("");
		     $display("              /////////////////////////////////////////////");
			 $display("              //                                         //");
			 $display("              //                 SOORY!!                 //");
			 $display("              //        The result is incorrect!!        //");
			 $display("              //                                         //");
		     $display("              /////////////////////////////////////////////");
		     $display("");
		     $display("");
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
