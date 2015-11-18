module MUX2(sel,a,b,c,out);
parameter n=16;
input [1:0]sel;
input [n-1:0] a,b,c;
output [n-1:0] out;

assign out = sel==0?a:sel==1?b:c;
endmodule