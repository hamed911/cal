module Mips(CLOCK_50,SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,LEDR,LEDG,SRAM_ADDR,SRAM_DQ,SRAM_UB_N_O,SRAM_LB_N_O,SRAM_WE_N_O,SRAM_CE_N_O,SRAM_OE_N_O);
defparam id_ex.n=68;
defparam ex_mem.n=42;
defparam mem_wb.n=37;

input CLOCK_50,SRAM_UB_N_O,SRAM_LB_N_O,SRAM_WE_N_O,SRAM_CE_N_O,SRAM_OE_N_O;
input [3:0] KEY;
input [17:0] SW,SRAM_ADDR;
inout [15:0] SRAM_DQ;
output [17:0] LEDR;
output [7:0] LEDG;
output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
wire pc_sel,reg2sel,alu_src,mem_write_en,mem_to_reg,enable2,enableBase;
wire [15:0] out_src1,out_src2,pc_out,pc_in,adder_out,sign_ex_out,branch_offset,monitor_regFile,aluIn2,mem_out,write_back_data;
wire [15:0] inst_out,inst_out_reg,rg_rd_data1,rg_rd_data2,alu_out,rg_wrt_data,branch_stall,monitor_cache;
wire [2:0] alu_com,rg_wrt_dest,reg2src;
wire [67:0] id_ex_reg_out,id_ex_input;
wire [41:0] ex_mem_reg_out,ex_mem_input;
wire [36:0] mem_wb_reg_out;
wire [1:0] ALUsel1,ALUsel2;
wire rst,w_en,rg_wrt_enable,stall,reg_enable,memory_stall,ready;
sign_extend ex(inst_out_reg[5:0],sign_ex_out);
adder add_offset(sign_ex_out,pc_out,branch_offset);
////branch
adder add1(1,pc_out,adder_out);
MUX pc_mux(pc_sel,adder_out,branch_offset,pc_in);
pc p1(clk,rst,enableBase,pc_in,pc_out);
instruction_mem ins_mem(clk,rst,pc_out,inst_out);
assign branch_stall=inst_out& {16{~pc_sel}};
fetch_id_reg fe_id_reg(clk,rst,enableBase,branch_stall,inst_out_reg);
//////Fetch
controller control(inst_out_reg[15:12],alu_com,w_en,pc_sel,rg_rd_data1,reg2sel,alu_src,mem_write_en,mem_to_reg);
hazard_detection hazard_detect(inst_out_reg[15:12],inst_out_reg[8:6],inst_out_reg[5:3],
								inst_out_reg[11:9],id_ex_reg_out[37:35],ex_mem_reg_out[2:0],mem_wb_reg_out[2:0],stall);
MUX reg2mux(reg2sel,inst_out_reg[5:3],inst_out_reg[11:9],reg2src);
registerFile regFile(clk,rst,rg_wrt_enable,rg_wrt_dest,rg_wrt_data,inst_out_reg[8:6],
				rg_rd_data1,reg2src,rg_rd_data2,SW[17:15],monitor_regFile);
assign id_ex_input = {inst_out_reg[15:12],inst_out_reg[8:6],reg2src,mem_to_reg,mem_write_en,alu_src,sign_ex_out,w_en,inst_out_reg[11:9],alu_com,rg_rd_data1,rg_rd_data2};
register id_ex(clk,rst,enable2&~ready,id_ex_input&{68{reg_enable}},id_ex_reg_out);
//////Decode
forwardingUnit fw(forward_en,ex_mem_reg_out[3],mem_wb_reg_out[3],ex_mem_reg_out[2:0]&{3{ex_mem_reg_out[3]}},id_ex_reg_out[63:61],id_ex_reg_out[60:58],mem_wb_reg_out[2:0]&{3{mem_wb_reg_out[3]}},
									id_ex_reg_out[67:64],ex_mem_reg_out[41:38],ALUsel1,ALUsel2,memory_stall);
MUX2 src2(ALUsel2,id_ex_reg_out[15:0],ex_mem_reg_out[19:4],write_back_data,out_src2);
MUX aluMux(id_ex_reg_out[55],out_src2,id_ex_reg_out[54:39],aluIn2);
MUX2 src1(ALUsel1,id_ex_reg_out[31:16],ex_mem_reg_out[19:4],write_back_data,out_src1);
ALU alu(out_src1,aluIn2,id_ex_reg_out[34:32],alu_out);
assign ex_mem_input = {id_ex_reg_out[67:64],id_ex_reg_out[57:56],out_src2,alu_out,id_ex_reg_out[38],id_ex_reg_out[37:35]};
register ex_mem(clk,rst,~ready,ex_mem_input&{42{~memory_stall}},ex_mem_reg_out);
//////Execute
//dataMemory mem(clk,rst,ex_mem_reg_out[11:4],ex_mem_reg_out[35:20],ex_mem_reg_out[36],mem_out,
//							SW[14:11],monitor_mem);

/*SRAM_controller mem_ctrl(clk,rst,ex_mem_reg_out[41:38],{2'b00,ex_mem_reg_out[19:4]},ex_mem_reg_out[35:20],ex_mem_reg_out[36],SRAM_DQ,
					mem_out,ready,SRAM_ADDR,
					SRAM_UB_N_O,SRAM_LB_N_O,SRAM_WE_N_O,SRAM_CE_N_O,SRAM_OE_N_O);
*/

cache_controller(clk,rst,ready,ex_mem_reg_out[19:4],ex_mem_reg_out[36],mem_out,{2'b00,ex_mem_reg_out[19:4]},ex_mem_reg_out[35:20],
		ex_mem_reg_out[41:38],SRAM_DQ,SRAM_ADDR,SRAM_UB_N_O,SRAM_LB_N_O,SRAM_WE_N_O,SRAM_CE_N_O,SRAM_OE_N_O,SW[14:11],monitor_cache);

register mem_wb(clk,rst,1,{ex_mem_reg_out[37],mem_out,ex_mem_reg_out[19:0]}&{37{~ready}},mem_wb_reg_out);
/////mem
MUX wb_mux(mem_wb_reg_out[36],mem_wb_reg_out[35:20],mem_wb_reg_out[19:4],write_back_data);
assign rg_wrt_enable=mem_wb_reg_out[3];
assign rg_wrt_dest = mem_wb_reg_out[2:0];
assign rg_wrt_data = write_back_data;
assign reg_enable=SW[0]==0?~stall:1;
assign forward_en = SW[0];
assign enable2 = (SW[0]==1&&memory_stall==1)?0:1;
assign enableBase = (SW[0]==1?enable2:reg_enable)& ~ready;

assign LEDR[17] = enable2;
assign LEDR[16] = memory_stall;
//assign LEDR[15:0]= monitor_regFile;
assign LEDR[15:0]= monitor_cache;
assign LEDG[1:0] = ALUsel1;
assign LEDG[3:2] = ALUsel2;
assign LEDG[4] = id_ex_reg_out[55];
assign LEDG[5] = ex_mem_reg_out[36];
assign LEDG[6] = enableBase;
assign LEDG[7] = stall;

/////Write back
//convertor_two_digit convert(monitor_regFile,HEX6,HEX7);
sevenSegment s1(pc_out[3:0],HEX5);//pc
sevenSegment s2(ex_mem_reg_out[7:4],HEX4);//ALU_out-ex_mem
sevenSegment s3(ex_mem_reg_out[23:20],HEX3);// reg2Index
sevenSegment s7(out_src1[3:0],HEX2);//aluIn1
//sevenSegment s7(mem_out[3:0],HEX3);
sevenSegment s5(aluIn2[3:0],HEX1);//aluIn2
sevenSegment s6(id_ex_reg_out[67:64],HEX0);//ex-opcode
sevenSegment s4(monitor_regFile[3:0],HEX7);//regfile
sevenSegment s8(ex_mem_reg_out[41:38],HEX6);//cache


assign rst = ~KEY[3];
assign clk = ~KEY[1];
endmodule