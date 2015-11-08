module convertor_two_digit(in,a,b);
input [15:0] in;
output [3:0] a,b;
assign a= in%10;
assign b= (in-in%10)/10;
endmodule