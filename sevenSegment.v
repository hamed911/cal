module sevenSegment(number,bits);
input [3:0] number;
output reg [6:0] bits=0;
always@(number)begin
	case(number)
	0: bits = 7'b1000000;
	1: bits = 7'b1111001;
	2: bits = 7'b0100100;
	3: bits = 7'b0110000;
	4: bits = 7'b0011001;
	5: bits = 7'b0010010;
	6: bits = 7'b0000010;
	7: bits = 7'b1111000;
	8: bits = 7'b0000000;
	9: bits = 7'b0010000;
	endcase
end
endmodule