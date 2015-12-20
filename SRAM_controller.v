module SRAM_controller(clk,rst,opcode,SRAM_addr,SRAM_write_data,SRAM_write_en,SRAM_data,
					SRAM_read_data,ready,SRAM_out_addr,
					SRAM_UB_N_O,SRAM_LB_N_O,SRAM_WE_N_O,SRAM_CE_N_O,SRAM_OE_N_O);
input clk,rst,SRAM_write_en;
input [17:0] SRAM_addr;
input [15:0] SRAM_write_data;
input [3:0] opcode;

output reg [15:0] SRAM_read_data;
output reg ready;
output [17:0] SRAM_out_addr;
output SRAM_UB_N_O,SRAM_LB_N_O,SRAM_CE_N_O,SRAM_OE_N_O;
output reg SRAM_WE_N_O;
inout reg[15:0] SRAM_data;

parameter[2:0] wa8 = 3'b000,s1 = 3'b001,s2 = 3'b010,s3=3'b011 , s4=3'b100;
reg [2:0] ps,ns;
assign SRAM_UB_N_O=0;
assign SRAM_LB_N_O=0;
assign SRAM_CE_N_O=0;
assign SRAM_OE_N_O=0;
assign SRAM_out_addr = SRAM_addr;
always@(ps,opcode)begin
	ns=wa8;
	ready=0;
	SRAM_WE_N_O = 1;
	case(ps)
		wa8: begin if(opcode==10 || opcode==11) begin ready=1; ns= s1; end end
		s1: begin if(opcode==10) begin SRAM_WE_N_O = 1; end else 
						if(opcode ==11 )begin SRAM_WE_N_O =0; SRAM_data = SRAM_write_data; end ns=s2; ready=1; end
		s2: begin if(opcode==10) begin SRAM_WE_N_O = 1; end ns=s3; ready=1; end
		s3: begin if(opcode==10) begin SRAM_WE_N_O = 1; end ns=s4; ready=1; end
		s4: begin if(opcode==10) begin SRAM_read_data = SRAM_data; end ready=0; ns=wa8;  end
			default : ns=wa8;
	endcase
end

always@(posedge clk) begin
	if(rst)
		ps<=0;
	else
		ps<=ns;
end

endmodule