module MUX(sel,a,b,out);
parameter n=16;
input sel;
input [n-1:0] a,b;
output [n-1:0] out;

assign out = sel?b:a;
endmodule