import sys

def RS_RT_RD(source):
	d = int(source)
	if d>=0:
		b = bin(d)
		_str = str(b)[2:]
		R = "%05d"%int(_str)
		return R
	else:
		b_two_com = 2**16 + d
		b = bin(b_two_com)
		_str = str(b)[2:]
		R = "%05d"%int(_str)
		return R
	
def C_A(source):
	d = int(source)
	if d>=0:
		b = bin(d)
		_str = str(b)[2:]
		R = "%016d"%int(_str)
		return R
	else:
		b_two_com = 2**16 + d
		b = bin(b_two_com)
		_str = str(b)[2:]
		R = "%016d"%int(_str)
		return R

R_TYPE = ["ADD", "SUB", "AND", "OR", "SLT", "DSLLV"]
I_TYPE = ["ADDI", "LW", "SW"]
J_TYPE = ["J"]
FILE = open(sys.argv[1], "r")
FILE_w = open(sys.argv[2], "w")

for line in FILE:
	code = line.split(' ')
	if code[0] in J_TYPE:
		opcode = "000010"
		machine_code = opcode + "0000000000" + C_A(code[1]) + "\t\t" + "//" + line
		FILE_w.write(machine_code)
		continue
	RS = RS_RT_RD(code[1][1:])
	RT = RS_RT_RD(code[2][1:])
	if code[0] in R_TYPE:
		opcode = "000000"
		RD = RS_RT_RD(code[3][1:])
		SHAMT = "00000"
		if   code[0]=="ADD"  :FUNC = "100000"
		elif code[0]=="SUB"  :FUNC = "100010"
		elif code[0]=="AND"  :FUNC = "100100"
		elif code[0]=="OR"   :FUNC = "100101"
		elif code[0]=="SLT"  :FUNC = "101010"
		elif code[0]=="DSLLV" :FUNC = "010100"
		else:                 FUNC = "000000"
		machine_code = opcode + RS + RT + RD + SHAMT + FUNC + "\t\t" + "//" + line
		FILE_w.write(machine_code)
	else:
		if code[0] in I_TYPE:
			if code[0]=="ADDI":
				opcode = "001000"
			elif code[0]=="LW":
				opcode = "100011"
			else:
				opcode = "101011"
		else:
			opcode = "000100"
		CONS_ADDR = C_A(code[3])
		machine_code = opcode + RS + RT + CONS_ADDR + "\t\t" + "//" + line
		FILE_w.write(machine_code)
		
FILE.close()
FILE_w.close()