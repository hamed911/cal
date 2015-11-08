module Mips(CLOCK_50,SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,LEDR);
defparam id_ex.n=39;
defparam ex_mem.n=20;
defparam mem_wb.n=20;

input CLOCK_50;
input [3:0] KEY;
input [17:0] SW;
output [17:0] LEDR;
output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
wire pc_sel;
wire [15:0] pc_out,pc_in,adder_out,sign_ex_out,branch_offset,monitor_data;
wire [15:0] inst_out,inst_out_reg,rg_rd_data1,rg_rd_data2,alu_out,rg_wrt_data,handle_stall;
wire [2:0] alu_com,rg_wrt_dest;
wire [38:0] id_ex_reg_out;
wire [19:0] ex_mem_reg_out,mem_wb_reg_out;
wire rst,w_en,rg_wrt_enable;
sign_extend(inst_out_reg[5:0],sign_ex_out);
adder add_offset(sign_ex_out,pc_out,branch_offset);
////branch
adder add1(1,pc_out,adder_out);
MUX pc_mux(pc_sel,adder_out,branch_offset,pc_in);
pc p1(clk,rst,0,pc_in,pc_out);
instruction_mem ins_mem(clk,rst,pc_out,inst_out);
assign handle_stall=inst_out& {16{~pc_sel}};
fetch_id_reg fe_id_reg(clk,rst,handle_stall,inst_out_reg);
//////Fetch
controller control(inst_out_reg[15:12],alu_com,w_en,pc_sel,rg_rd_data1);
registerFile regFile(clk,rst,rg_wrt_enable,rg_wrt_dest,rg_wrt_data,inst_out_reg[8:6],
				rg_rd_data1,inst_out_reg[5:3],rg_rd_data2,SW[17:15],monitor_data);
register id_ex(clk,rst,{w_en,inst_out_reg[11:9],alu_com,rg_rd_data1,rg_rd_data2},id_ex_reg_out);
//////Decode
ALU alu(id_ex_reg_out[31:16],id_ex_reg_out[15:0],id_ex_reg_out[34:32],alu_out);
register ex_mem(clk,rst,{alu_out,id_ex_reg_out[38],id_ex_reg_out[37:35]},ex_mem_reg_out);
//////Execute
register mem_wb(clk,rst,ex_mem_reg_out,mem_wb_reg_out);
/////mem
assign rg_wrt_enable=mem_wb_reg_out[3];
assign rg_wrt_dest = mem_wb_reg_out[2:0];
assign rg_wrt_data = mem_wb_reg_out[19:4];
assign LEDR[0] = pc_sel;
assign LEDR[17:2]= handle_stall;
//convertor_two_digit convert(monitor_data,HEX6,HEX7);
sevenSegment s1(pc_out[3:0],HEX0);//pc
sevenSegment s2(inst_out_reg[8:6],HEX1);//reg1
sevenSegment s3(inst_out_reg[5:3],HEX2);// reg2
sevenSegment s4(monitor_data[3:0],HEX6);//data1
sevenSegment s8(branch_offset[3:0],HEX7);//branch offset
sevenSegment s7(rg_rd_data1[3:0],HEX3);//data1
sevenSegment s5(rg_rd_data2[3:0],HEX4);//data2
sevenSegment s6(mem_wb_reg_out[19:4],HEX5);//result
assign rst = ~KEY[3];
assign clk = ~KEY[1];
endmodule