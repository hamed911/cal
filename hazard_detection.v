module hazard_detection(opcode,r1_decode,r2_decode,w_decode,w_exec,w_mem,w_wb,stall);
input [2:0] r1_decode,r2_decode,w_decode,w_exec,w_mem,w_wb;
input [3:0] opcode;
output stall;

assign stall = ( opcode >=1 && opcode <= 8)?
				(((r1_decode!=0) &&(r1_decode == w_exec || r1_decode==w_mem || r1_decode == w_wb))||
				((r2_decode!=0)&&( r2_decode == w_exec || r2_decode==w_mem || r2_decode == w_wb))?1:0):
				(( opcode== 9 || opcode==12|| opcode==10)?(((r1_decode!=0)&&(r1_decode == w_exec || r1_decode==w_mem || r1_decode == w_wb))?1:0):
				(( opcode == 11)?((((w_decode!=0)&&(w_decode == w_exec || w_decode==w_mem || w_decode == w_wb))||((r1_decode!=0)&&(r1_decode == w_exec || r1_decode==w_mem || r1_decode == w_wb)))?1:0):0));

endmodule
