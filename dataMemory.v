module dataMemory(clk,rst,addr,wdata,w_en,rdata,monitor_addr,monitor_data);
input clk,rst,w_en;
input [7:0] addr;
input [15:0] wdata;
input [2:0] monitor_addr;
output [15:0] rdata,monitor_data;
reg [15:0] memory [63:0];
assign rdata = memory[{8'b00000000,addr}];
assign monitor_data = memory[{13'b0000000000000,monitor_addr}];
always@(clk) begin
	if(w_en)memory[addr] = wdata;
end
endmodule
