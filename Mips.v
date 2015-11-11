module Mips(CLOCK_50,SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,LEDR,LEDG);
defparam id_ex.n=58;
defparam ex_mem.n=38;
defparam mem_wb.n=37;

input CLOCK_50;
input [3:0] KEY;
input [17:0] SW;
output [17:0] LEDR;
output [7:0] LEDG;
output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
wire pc_sel,reg2sel,alu_src,mem_write_en,mem_to_reg;
wire [15:0] pc_out,pc_in,adder_out,sign_ex_out,branch_offset,monitor_regFile,aluIn2,mem_out,write_back_data;
wire [15:0] inst_out,inst_out_reg,rg_rd_data1,rg_rd_data2,alu_out,rg_wrt_data,branch_stall,monitor_mem;
wire [2:0] alu_com,rg_wrt_dest,reg2src;
wire [57:0] id_ex_reg_out,id_ex_input;
wire [37:0] ex_mem_reg_out;
wire [36:0] mem_wb_reg_out;
wire rst,w_en,rg_wrt_enable,stall,reg_enable;
sign_extend ex(inst_out_reg[5:0],sign_ex_out);
adder add_offset(sign_ex_out,pc_out,branch_offset);
////branch
adder add1(1,pc_out,adder_out);
MUX pc_mux(pc_sel,adder_out,branch_offset,pc_in);
pc p1(clk,rst,reg_enable,pc_in,pc_out);
instruction_mem ins_mem(clk,rst,pc_out,inst_out);
assign branch_stall=inst_out& {16{~pc_sel}};
fetch_id_reg fe_id_reg(clk,rst,reg_enable,branch_stall,inst_out_reg);
//////Fetch
controller control(inst_out_reg[15:12],alu_com,w_en,pc_sel,rg_rd_data1,reg2sel,alu_src,mem_write_en,mem_to_reg);
hazard_detection hazard_detect(inst_out_reg[15:12],inst_out_reg[8:6],inst_out_reg[5:3],
								inst_out_reg[11:9],id_ex_reg_out[37:35],ex_mem_reg_out[2:0],mem_wb_reg_out[2:0],stall);
MUX reg2mux(reg2sel,inst_out_reg[5:3],inst_out_reg[11:9],reg2src);
registerFile regFile(clk,rst,rg_wrt_enable,rg_wrt_dest,rg_wrt_data,inst_out_reg[8:6],
				rg_rd_data1,reg2src,rg_rd_data2,SW[17:15],monitor_regFile);
assign id_ex_input = {mem_to_reg,mem_write_en,alu_src,sign_ex_out,w_en,inst_out_reg[11:9],alu_com,rg_rd_data1,rg_rd_data2};
register id_ex(clk,rst,1,id_ex_input&{58{reg_enable}},id_ex_reg_out);
//////Decode
MUX aluMux(id_ex_reg_out[55],id_ex_reg_out[15:0],id_ex_reg_out[54:39],aluIn2);
ALU alu(id_ex_reg_out[31:16],aluIn2,id_ex_reg_out[34:32],alu_out);
register ex_mem(clk,rst,1,{id_ex_reg_out[57:56],id_ex_reg_out[15:0],alu_out,id_ex_reg_out[38],id_ex_reg_out[37:35]},ex_mem_reg_out);
//////Execute
dataMemory mem(clk,rst,ex_mem_reg_out[11:4],ex_mem_reg_out[35:20],ex_mem_reg_out[36],mem_out,
							SW[14:11],monitor_mem);
register mem_wb(clk,rst,1,{ex_mem_reg_out[37],mem_out,ex_mem_reg_out[19:0]},mem_wb_reg_out);
/////mem
MUX wb_mux(mem_wb_reg_out[36],mem_wb_reg_out[35:20],mem_wb_reg_out[19:4],write_back_data);
assign rg_wrt_enable=mem_wb_reg_out[3];
assign rg_wrt_dest = mem_wb_reg_out[2:0];
assign rg_wrt_data = write_back_data;
assign reg_enable=~stall;

assign LEDR[17] = pc_sel;
assign LEDR[15:0]= monitor_regFile;
assign LEDG[0] = mem_to_reg;
assign LEDG[1] = mem_write_en;
assign LEDG[2] = alu_src;
assign LEDG[3] = reg2sel;
assign LEDG[4] = w_en;
assign LEDG[5] = ex_mem_reg_out[36];
assign LEDG[6] = reg_enable;
assign LEDG[7] = stall;

/////Write back
//convertor_two_digit convert(monitor_regFile,HEX6,HEX7);
sevenSegment s1(pc_out[3:0],HEX5);//pc
sevenSegment s2(inst_out_reg[8:6],HEX4);//reg1Index
sevenSegment s3(inst_out_reg[5:3],HEX3);// reg2Index
sevenSegment s7(id_ex_reg_out[19:16],HEX2);//aluIn1
//sevenSegment s7(mem_out[3:0],HEX3);
sevenSegment s5(aluIn2[3:0],HEX1);//aluIn2
sevenSegment s6(write_back_data[3:0],HEX0);//write_back_data
sevenSegment s4(monitor_regFile[3:0],HEX7);//regfile
sevenSegment s8(monitor_mem[3:0],HEX6);//memory


assign rst = ~KEY[3];
assign clk = ~KEY[1];
endmodule