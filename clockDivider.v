module clockDivider(inclk,outclk);
input inclk;
output outclk;
reg [21:0] counter=0;
always@(posedge inclk)begin
 counter = counter+1;
end
assign outclk= counter[21];
endmodule