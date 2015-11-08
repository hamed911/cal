module fetch_id_reg(clk,rst,inst_out,inst_out_reg);
input [15:0] inst_out;
input clk,rst;
output reg [15:0] inst_out_reg;
always@(posedge clk,posedge rst)begin
 if(rst) inst_out_reg=0;
 else
	inst_out_reg=inst_out;
end
endmodule