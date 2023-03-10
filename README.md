# MIPS CPU

### There is an assembler to transfer assembly code to machine code, and a CPU to execute these instruction.
The assembly code prepared to be transfered to machine code is in the folder "assembly_code", and the machine code is the file "sisc.prog".

PS : The format of assembly code is something difference from typical MIPS format.

## Introduction of each version

* V1 : According to the typical MIPS architecture.
* V2 : Move the output of the forwarding unit and the two MUXs from EX to ID, reducing the probability of branch hazard.
* V3 : When execute branch, predict "taken", rather than "NOT taken", reducing the penalty.
* V4 : Add new instruction "jump".
* V5 : Simulate the delay of D_memory(RAM), the delay cycle(RAM_DELAY) is defined in def.v.

## The instruction supported by V4

* R-type\
***INS RS RT RD***
	* ***ADD***     
	
			RD = RS + RT
	* ***SUB***     
	
			RD = RS - RT
	* ***AND***     
	
			RD = RS && RT
	* ***OR***      
	
			RS = RS || RT
	* ***SLT***     
	
			RD = (RS<RT)?1:0
	* ***DSLLV***   
	
			RD = RT << RS
         
* I-type\
***INS RS RT CONST(signed)***
	* ***ADDI***    
	
			RT = RS + CONSTANT
	* ***LW***      
	
			RT = D_MEMORY[RS+ADDR]
	* ***SW***      
	
			D_MEMORY[RS+ADDR] = RT
         
* Branch-tpye\
***INS RS RT CONST(signed)***
	* ***BEQ***     
	
			pc = (RS==RT)?pc + 1 + CONSTANT:pc + 1
       
* Jump-type\
***INS CONST***
	* ***J***       
	
			1. pc = {pc[31:28], 2'b00, ins[25:0]}
			2. pc = {pc[31:28], ins[25:0]<<2}

## The latency of machine code(cycle)
                                V1             V2                 V3               V4              V5
     bubble_sort.s           313.5          255.5(-58)         256.5(+1)        256.5(0)       6025.5
     fibonacci.s             154.5          134.5(-20)         124.5(-10)       124.5(0)       3592.5
     double_hazard.s          18.5           18.5(0)            18.5(0)          18.5(0)         18.5
     load_use.s               22.5           22.5(0)            22.5(0)          22.5(0)        221.5
     load_branch.s            32.5           30.5(-2)           30.5(0)          30.5(0)        428.5
     use_branch.s             32.5           28.5(-4)           28.5(0)          28.5(0)         28.5
     jump.s                  -----          -----(-)           -----(-)          20.5(-)       ------
     no_hazard.s             132.5          132.5(0)           132.5(0)         132.5(0)        132.5

## Synthesis result of V4

	process                180 nm
	frequency           166.67 MHz
	cell area        212899.58 um^2
	power              20.2610 mW
	power=             121.566 uW/MHz
