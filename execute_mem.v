module execute_mem(clk,rst,decode_out,mem_out);
input clk,rst;
input [15:0] decode_out;
output [15:0] mem_out;
reg [15:0] temp_reg;
always@(posedge clk)begin
	if(rst) temp_reg=0;
	else
		temp_reg = ins_out;
end
endmodule