module pc(clk,rst,load,in,out);
input clk,rst,load;
input [15:0] in;
output [15:0]out;
reg [15:0] counter;
always@(posedge clk,posedge rst)begin
	if(rst)begin
		counter=0;
	end
	else if(load) begin
		counter=in;
	end
end
assign out = counter;
endmodule