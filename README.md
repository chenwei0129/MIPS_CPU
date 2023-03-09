# MIPS CPU

## 各版本簡介

* V1 : 按照計算機組織MIPS的架構
* V2 : 將forwarding的輸出以及兩個MUX移到ID級，降低branch hazard的發生率
* V3 : 遇到branch，V1、V2猜測NOT taken, V3改為猜測taken，降低猜錯的penalty
* V4 : 新增指令jump
* V5 : 到D_memory(RAM)讀值以及寫值有延遲，延遲時間在def.v中設定(RAM_DELAY)

## V4 支援指令

* R-type
	* ADD     RD=RS+RT
	* SUB     RD=RS-RT
	* AND     RD=RS&&RT
	* OR      RS=RS||RT
	* SLT     RD=(RS<RT)?1:0
	* DSLLV   RD=RT<<RS
         
* I-type
	* ADDI    RT=RS+CONSTANT
	* LW      RT=D_MEMORY[RS+ADDR]
	* SW      D_MEMORY[RS+ADDR]=RT
         
* Branch-tpye
	* beq     pc=(RS==RT)?pc+1+CONSTANT:pc+1
       
* Jump-type
	* J       pc={pc[31:28], 2'b00, ins[25:0]} or  pc={pc[31:28], ins[25:0]<<2}

## 各個machine code的執行時間(cycle)
                                V1             V2                 V3              V4              V5
     bubble_sort.s           313.5          255.5(-58)         256.5(+1)        256.5(0)       6025.5
     fibonacci.s             154.5          134.5(-20)         124.5(-10)       124.5(0)       3592.5
     double_hazard.s          18.5           18.5(0)            18.5(0)          18.5(0)         18.5
     load_use.s               22.5           22.5(0)            22.5(0)          22.5(0)        221.5
     load_branch.s            32.5           30.5(-2)           30.5(0)          30.5(0)        428.5
     use_branch.s             32.5           28.5(-4)           28.5(0)          28.5(0)         28.5
     jump.s                  -----          -----(-)           -----(-)          20.5(-)       ------
     no_hazard.s             132.5          132.5(0)           132.5(0)         132.5(0)        132.5

## V4 合成結果

	process                180 nm
	frequency           166.67 MHz
	cell area        212899.58 um^2
	power              20.2610 mW
	power=             121.566 uW/MHz
