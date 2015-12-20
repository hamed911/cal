module cache_controller(clk,rst,freeze,address,write_en,rdata,SRAM_addr,SRAM_write_data,
		opcode,SRAM_data,SRAM_out_addr,SRAM_UB_N_O,SRAM_LB_N_O,SRAM_WE_N_O,SRAM_CE_N_O,SRAM_OE_N_O,monitor_addr,monitor_data);
input write_en,clk,rst;
input [15:0] address;
output [15:0] rdata;
output freeze;
input[3:0] monitor_addr;
output[15:0] monitor_data;
wire [15:0] SRAM_read_data; 
input [3:0] opcode;
input [17:0] SRAM_addr;
input [15:0] SRAM_write_data;
wire ready;
output [17:0] SRAM_out_addr;
output SRAM_UB_N_O,SRAM_LB_N_O,SRAM_CE_N_O,SRAM_OE_N_O,SRAM_WE_N_O;

inout [15:0] SRAM_data;
reg replace1,replace2;
reg [15:0] data1[31:0];
reg [15:0] data2[31:0];
reg [7:0] tag1[31:0];
reg [7:0] tag2[31:0];
reg [255:0] valid1,valid2,LRU1,LRU2 ;
wire [15:0] d1,d2;
assign d1 = monitor_addr[3]==1?data1[monitor_addr[2:0]]:data2[monitor_addr[2:0]];
assign d2 = data2[monitor_addr];
//assign monitor_data = {freeze,ready,d1[6:0],replace1,replace2,hit_or_miss1,hit_or_miss2,opcode};
assign monitor_data = address;
//assign monitor_data = d2;
SRAM_controller sram(clk,rst|(hit_or_miss&opcode==10),opcode,SRAM_addr,SRAM_write_data,write_en,SRAM_data,
					SRAM_read_data,ready,SRAM_out_addr,
					SRAM_UB_N_O,SRAM_LB_N_O,SRAM_WE_N_O,SRAM_CE_N_O,SRAM_OE_N_O);

wire [15:0] data_cache1,data_cache2;					
wire [15:0] cache_out;
wire eq1,eq2,hit_or_miss1,hit_or_miss2,hit_or_miss;
reg ps,ns,sel_out;

assign data_cache1 = data1[address[7:0]];
assign data_cache2 = data2[address[7:0]];

assign eq1 = (tag1[address[7:0]] == address[15:8])?1:0;
assign eq2 = (tag2[address[7:0]] == address[15:8])?1:0;

assign hit_or_miss1 = valid1[address[7:0]] & eq1;
assign hit_or_miss2 = valid2[address[7:0]] & eq2;
 
assign hit_or_miss = hit_or_miss1 | hit_or_miss2; 
assign cache_out = (hit_or_miss1)?data_cache1:(hit_or_miss2)?data_cache2:0;

assign rdata = (sel_out == 0)? cache_out : SRAM_read_data;
assign freeze = (opcode==11) ? ready : (ready & ~hit_or_miss);

always@(posedge clk)begin
	if(rst)begin
		valid1[3]= 1'b0;
		valid2[3] = 1'b0;
		data1[0] = 16'b0;
		data2[0] = 16'b0;
		valid1[10]= 1'b0;
		valid2[10] = 1'b0;
		data1[10] = 16'b0;
		data2[10] = 16'b0;
		LRU1[0] = 1'b0;
		LRU2[0] = 1'b0;
		LRU1[10] = 1'b0;
		LRU2[10] = 1'b0;
	end
	if(replace1)begin
		data1[address[7:0]] = SRAM_read_data;
		tag1[address[7:0]] = address[15:8];
		valid1[address[7:0]] = 1;
	end
	if(replace2)begin
		data2[address[7:0]] = SRAM_read_data;
		tag2[address[7:0]] = address[15:8];
		valid2[address[7:0]] = 1;
	end
	if(hit_or_miss1 == 1 || replace1==1) begin
		LRU1[address[7:0]] = 1;
		LRU2[address[7:0]] = 0;
	end
	if(hit_or_miss2 == 1 || replace2 ==1)begin
		LRU2[address[7:0]] = 1;
		LRU1[address[7:0]] = 0;
	end
end

always@(ps,opcode,rst)begin
	if(rst)begin
		ns=0;
		replace1=0;
		replace2=0;
	end
	replace1=0;
	replace2=0;
	ns = 0;
	case(ps)
		0:begin 
			if(opcode!=10 && opcode!=11)
				ns = 0;
			else if((opcode==10 || opcode==11)&&hit_or_miss==1)begin
				sel_out = 0;
				ns = 0;
			end
			else if((opcode==10 || opcode==11)&&hit_or_miss==0)begin
				ns = 1;
			end
		end
		1:begin 
			if(ready==1)
				ns = 1;
			else if(ready==0 &&opcode==10) begin
				sel_out = 1;
				if(valid1[address[7:0]] == 0)begin
					replace1=1;
				end
				else if(valid2[address[7:0]] == 0)begin
					replace2=1;
				end
				else if(LRU1[address[7:0]] == 0)begin
					replace1=1;
				end
				else if(LRU2[address[7:0]] == 0)begin
					replace2=1;
				end
				ns = 0;
			end
		end
	endcase;
end

always@(posedge clk) begin
	if(rst)begin
		ps=0;
	end
	else
		ps<=ns;
end
					
endmodule