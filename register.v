module register(clk,rst,en,in,out);
parameter n=16;
input [n-1:0] in;
input clk,rst,en;
output reg [n-1:0] out;
always@(posedge clk,posedge rst) begin
	if(rst) out=0;
	else if(en)
		out=in;
end
endmodule