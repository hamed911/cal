module ALU(a,b,cmd,res);
input [15:0] a,b;
input [2:0] cmd;
output [15:0] res;
assign res = (cmd==0) ? a+b : 
					(cmd==1) ? a-b : 
					(cmd==2) ? a&b : 
					(cmd==3) ? a|b : 
					(cmd==4) ? a^b : 
					(cmd==5) ? a << b : 
					(cmd==6) ? a >> b : 
					(cmd==7) ? a >>> b : res;
endmodule