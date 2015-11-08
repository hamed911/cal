module registerFile(clk,rst,rg_wrt_enable,rg_wrt_dest,rg_wrt_data,
		rg_rd_add1,rg_rd_data1,rg_rd_add2,rg_rd_data2,monitor_addr,monitor_data);
input clk,rst;
//wire port
input rg_wrt_enable;
input [2:0] rg_wrt_dest;
input [15:0] rg_wrt_data;
//read port1
input [2:0] rg_rd_add1,monitor_addr;
output [15:0] rg_rd_data1;
//read port2
input [2:0] rg_rd_add2;
output [15:0] rg_rd_data2,monitor_data;

reg [15:0] registers [7:0];

assign rg_rd_data1 = registers[rg_rd_add1];
assign rg_rd_data2 = registers[rg_rd_add2];
assign monitor_data = registers[monitor_addr];

always@(posedge clk,posedge rst)begin
	if(rst) begin
		registers [1] = 1;
		registers [2] = 2;
		registers [3] = 3;
		registers [4] = 4;
	end
	else if(rg_wrt_enable)begin
		registers[rg_wrt_dest] = rg_wrt_data;
	end
	
	registers[0] = 0;
end
endmodule