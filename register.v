module register(clk,rst,in,out);
parameter n=16;
input [n-1:0] in;
input clk,rst;
output reg [n-1:0] out;
always@(posedge clk,posedge rst) begin
	if(rst) out=0;
	else
		out=in;
end
endmodule