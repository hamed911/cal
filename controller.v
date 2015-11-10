module controller(opcode,alu_com,w_en,pc_sel,reg1_data,reg2sel,alu_src,mem_write_en,mem_to_reg);
input [3:0] opcode;
input [15:0] reg1_data;
output reg w_en;
output pc_sel,reg2sel,alu_src,mem_write_en,mem_to_reg;
output reg [2:0] alu_com;
assign pc_sel= (opcode==4'b1100 &&reg1_data==0)?1:0;
assign reg2sel = (opcode==11)?1:0;
assign alu_src = (opcode>=9 && opcode <=11)?1:0;
assign mem_write_en = (opcode==11)?1:0;
assign mem_to_reg = (opcode==10)?0:1;
always@(opcode)begin
	case(opcode)
		0: alu_com=3'bxxx;
		1: alu_com=0;
		2: alu_com=1;
		3: alu_com=2;
		4: alu_com=3;
		5: alu_com=4;
		6: alu_com=5;
		7: alu_com=6;
		8: alu_com=7;
		9: alu_com=0;
		10: alu_com=0;
		11: alu_com=0;
	endcase
	if(opcode>=1 && opcode <=10)
		w_en=1'b1;
	else
		w_en=1'b0;
end
endmodule