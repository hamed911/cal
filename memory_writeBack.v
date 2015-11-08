module memory_writeBack(clk,rst,memory_out,wb_out);
input clk,rst;
input [15:0] memory_out;
output [15:0] wb_out;
reg [15:0] temp_reg;
always@(posedge clk)begin
	if(rst) temp_reg=0;
	else
		temp_reg = ins_out;
end
endmodule