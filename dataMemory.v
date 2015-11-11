module dataMemory(clk,rst,addr,wdata,w_en,rdata,monitor_addr,monitor_data);
input clk,rst,w_en;
input [7:0] addr;
input [15:0] wdata;
input [3:0] monitor_addr;
output [15:0] rdata,monitor_data;
reg [15:0] memory [63:0];
assign rdata = memory[addr];
assign monitor_data = memory[monitor_addr];
always@(negedge clk) begin
	/*if(rst==1) begin
		memory[0] =1;
		memory[5] =4;
		memory[10] =-4;
	end*/
	if(w_en)memory[addr] = wdata;
end
endmodule
