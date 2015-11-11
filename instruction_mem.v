module instruction_mem(clk,rst,pc_out,instr_out);
input rst,clk;
input [15:0] pc_out;
output reg[15:0] instr_out;
always@(pc_out)begin
	case(pc_out)
		/*0: instr_out=16'b1011_011_010_000011;//store
		1: instr_out=16'b0001_111_010_000_000;//add
		2: instr_out=16'b0110_110_010_001_000;//sl
		3: instr_out=16'b0100_110_100_010_000;//or
		4: instr_out=16'b1100_000_000_000010;//bz pc=pc+1+2
		5: instr_out=16'b0010_101_100_001_000;//sub
		6: instr_out=16'b0101_101_100_011_000;//xor
		7: instr_out=16'b0010_101_100_011_000;//sub
		8: instr_out=16'b1011_111_011_000100;//store
		9: instr_out=16'b1010_110_010_000011;//load
		10: instr_out=16'b1100_000_000_111010;//bz pc=pc+1-6
		0: instr_out=16'b1001_100_000_001001; //addi
		1: instr_out=16'b0001_110_011_001_000;// add
		2: instr_out=16'b0010_101_110_010_000;// sub
		3: instr_out=16'b0111_111_011_001_000;// sr*/
		/*
		0 : instr_out=16'b1001001000001111; // addi r1 = 15
		1 : instr_out=16'b1011_011_001_111011; // ST  Mem(R1-5 = 10) <- R3 = -4
		2 : instr_out=16'b1010111011001110; // Ld  R7 <- Mem(14 + R3 = 10) = -4
		3 : instr_out=16'b1010110111001110; // Ld  R6 <- Mem(14 + R7 = 4) = -4
		4 : instr_out=16'b0001011110111000; // Add R3 = R6 + R7 = -8
		
		*/
		
		0 : instr_out=16'b1001001000000101; // addi r1 = 5	
		1 : instr_out=16'b1001010000111011; // addi r2 = -5	
		2 : instr_out=16'b1001011010001111; // addi r3 = R2 +15 = 10
		3 : instr_out=16'b1001100010111111; // addi r4 = R2 - 1 = -6
		4 : instr_out=16'b1001101010000101; // addi r5 = R2 + 5 = 0
		5 : instr_out=16'b0000111100101000; //nop
		6 : instr_out=16'b1001110101000110; // addi r6 = R5 + 6 = 6
		7 : instr_out=16'b0000000000000000; //nop
		8 : instr_out=16'b0000000000000000; //nop
		9 : instr_out=16'b1001111110000101; // addi r7 = R6 + 5 = 11
		10 : instr_out=16'b0001000111000000; // add R0 =R7 +R0 = 0
		11 : instr_out=16'b0000010010100000; // nop
		12 : instr_out=16'b0001011011000000; // add R3 =R3 +R0 = 10
		13 : instr_out=16'b0001100001100000; // add R4 =R1 +R4 = -1
		14 : instr_out=16'b0010001001010000; // SUB R1 =R1 - R2 = 10	
		15 : instr_out=16'b0011001001110000; // AND R1 =R1 &R6 = 00000010= 2
		16 : instr_out=16'b0100001100001000; // OR  R1 =R4 |R1 = 111111 = -1
		17 : instr_out=16'b0101001011001000; // XOR R1 =R3^R1 = 110101 = -11
		18 : instr_out=16'b1001010000000010; // Adi R2 = 2
		19 : instr_out=16'b0110001001010000; // SL  R1 =R1 <<R2 = 11010100
		20 : instr_out=16'b1001010010000010; // Adi R2 = R2 + 2 = 4 
		21 : instr_out=16'b1001011000111100; // Adi R3 = -4
		22 : instr_out=16'b0111001001010000; // SR  R1 =R1 >>R2 = 11111101 
		23 : instr_out=16'b1001001000001111; // addi r1 = 15
		24 : instr_out=16'b1011011001111011; // ST  Mem(R1-5 = 10) <- R3 = -4
		25 : instr_out=16'b1010111011001110; // Ld  R7 <- Mem(14 + R3 = 10) = -4
		26 : instr_out=16'b1010110111001110; // Ld  R6 <- Mem(14 + R7 = 4) = -4
		27 : instr_out=16'b0001011110111000; // Add R3 = R6 + R7 = -8
		28 : instr_out=16'b1011011110000100; // ST  Mem(R6 + 4 = 0) <- R3 = -8
		29 : instr_out=16'b1010001000000000; // Ld  R1 <- Mem(0 + R0 = 0) = -8
		30 : instr_out=16'b1001010000111011; // Adi R2 = -5
		31 : instr_out=16'b1001001000000000; // Adi R1 = 0
		32 : instr_out=16'b1100000001000001; // BR  R1 , 1 , YES
		33 : instr_out=16'b1001010000000000; // Adi R2 = 0	
		34 : instr_out=16'b1100000010111111; // BR  R2 , -1 , NOT	
		35 : instr_out=16'b1001001000000001; // Adi R1 = 1	
		36 : instr_out=16'b1100000001111011; // BR  R1 , -5 , NOT	
		37 : instr_out=16'b1100000000000000; // BR  R0 , 0 , YES	
		38 : instr_out=16'b1100000001111011; // BR  R1 , -5 , NOT 
		39 : instr_out=16'b1100000000111111; // BR  R0 , -1 , YES	
		//[40..255] : instr_out=16'b0000000000000000;
		
		
		default: instr_out=0;
	endcase
end
endmodule