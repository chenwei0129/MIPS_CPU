`timescale 1ns/100ps
module CLA_adder(src1, src2, C0, result);

  input [`WIDTH - 1:0] src1;
  input [`WIDTH - 1:0] src2;
  input C0;
  
  output [`WIDTH - 1:0] result;
  
  wire [3:0] S0;
  wire [3:0] S1;
  wire [3:0] S2;
  wire [3:0] S3;
  wire [3:0] S4;
  wire [3:0] S5;
  wire [3:0] S6;
  wire [3:0] S7;
  wire G0, G4, G8, G12, G16, G20, G24, G28, P0, P4, P8, P12, P16, P20, P24, P28;
  wire C4, C8, C12, C16, C20, C24, C28;
  
  assign result = {S7, S6, S5, S4, S3, S2, S1, S0};
  
  CLA_circuit_32 CLA_circuit_32(.C0(C0),
                                .G0(G0),
                                .G4(G4),
								.G8(G8),
								.G12(G12),
								.G16(G16),
								.G20(G20),
								.G24(G24),
								.G28(G28),
                                .P0(P0),
								.P4(P4),
								.P8(P8),
								.P12(P12),
								.P16(P16),
								.P20(P20),
								.P24(P24),
								.P28(P28),
					            .C4(C4),
								.C8(C8),
								.C12(C12),
								.C16(C16),
								.C20(C20),
								.C24(C24),
								.C28(C28));
  
  fourbits_CLA f0(.a(src1[3:0]),
                  .b(src2[3:0]),
				  .c(C0),
				  .s(S0),
				  .big_G(G0),
				  .big_P(P0));
  fourbits_CLA f1(.a(src1[7:4]),
                  .b(src2[7:4]),
				  .c(C4),
				  .s(S1),
				  .big_G(G4),
				  .big_P(P4));
  fourbits_CLA f2(.a(src1[11:8]),
                  .b(src2[11:8]),
				  .c(C8),
				  .s(S2),
				  .big_G(G8),
				  .big_P(P8));
  fourbits_CLA f3(.a(src1[15:12]),
                  .b(src2[15:12]),
				  .c(C12),
				  .s(S3),
				  .big_G(G12),
				  .big_P(P12));
  fourbits_CLA f4(.a(src1[19:16]),
                  .b(src2[19:16]),
				  .c(C16),
				  .s(S4),
				  .big_G(G16),
				  .big_P(P16));
  fourbits_CLA f5(.a(src1[23:20]),
                  .b(src2[23:20]),
				  .c(C20),
				  .s(S5),
				  .big_G(G20),
				  .big_P(P20));
  fourbits_CLA f6(.a(src1[27:24]),
                  .b(src2[27:24]),
				  .c(C24),
				  .s(S6),
				  .big_G(G24),
				  .big_P(P24));
  fourbits_CLA f7(.a(src1[31:28]),
                  .b(src2[31:28]),
				  .c(C28),
				  .s(S7),
				  .big_G(G28),
				  .big_P(P28));

endmodule

module CLA_circuit_32(C0,
                      G0, G4, G8, G12, G16, G20, G24, G28,
                      P0, P4, P8, P12, P16, P20, P24, P28,
					  C4, C8, C12, C16, C20, C24, C28);

  input C0;
  input G0;
  input G4;
  input G8;
  input G12;
  input G16;
  input G20;
  input G24;
  input G28;
  input P0;
  input P4;
  input P8;
  input P12;
  input P16;
  input P20;
  input P24;
  input P28;
  
  output C4;
  output C8;
  output C12;
  output C16;
  output C20;
  output C24;
  output C28;
  
  assign C4 = G0 | P0&C0;
  assign C8 = G4 | P4&C4;
  assign C12 = G8 | P8&C8;
  assign C16 = G12 | P12&C12;
  assign C20 = G16 | P16&C16;
  assign C24 = G20 | P20&C20;
  assign C28 = G24 | P24&C24;

endmodule

module fourbits_CLA(a, b, c, s, big_G, big_P);

  input [3:0] a;
  input [3:0] b;
  input c;
  
  output [3:0] s;
  output big_G;
  output big_P;

  wire c3, c2, c1;
  wire big_G0, big_G1, big_G2, big_G3, big_P0, big_P1, big_P2, big_P3;
  
  fourbits_adder fourbits_adder(.a(a),
                                .b(b),
								.c({c3, c2, c1, c}),
								.s(s),
								.G0(big_G0),
								.G1(big_G1),
								.G2(big_G2),
								.G3(big_G3),
								.P0(big_P0),
								.P1(big_P1),
								.P2(big_P2),
								.P3(big_P3));

  CLA_circuit CLA_circuit(.c0(c),
                          .G0(big_G0),
						  .G1(big_G1),
						  .G2(big_G2),
						  .G3(big_G3),
						  .P0(big_P0),
						  .P1(big_P1),
						  .P2(big_P2),
						  .P3(big_P3),
						  .big_G(big_G),
						  .big_P(big_P),
						  .c1(c1),
						  .c2(c2),
						  .c3(c3));

endmodule

module CLA_circuit(c0, G0, G1, G2, G3, P0, P1, P2, P3, big_G, big_P, c1, c2, c3);

  input c0;
  input G0;
  input G1;
  input G2;
  input G3;
  input P0;
  input P1;
  input P2;
  input P3;
  
  output big_G;
  output big_P;
  output c1;
  output c2;
  output c3;
  
  assign big_G = G3 | P3&G2 | P3&P2&G1 | P3&P2&P1&G0;
  assign big_P = P3&P2&P1&P0;
  assign c1 = G0 | P0&c0;
  assign c2 = G1 | P1&G0 | P1&P0&c0;
  assign c3 = G2 | P2&G1 | P2&P1&G0 | P2&P1&P0&c0;

endmodule

module fourbits_adder(a, b, c, s, G0, G1, G2, G3, P0, P1, P2, P3);

  input [3:0] a;
  input [3:0] b;
  input [3:0] c;
  
  output [3:0] s;
  output G0;
  output G1;
  output G2;
  output G3;
  output P0;
  output P1;
  output P2;
  output P3;

  wire s3, s2, s1, s0;
  
  assign s = {s3, s2, s1, s0};
  
  fulladder a0(.a(a[0]),
               .b(b[0]),
			   .c(c[0]),
			   .s(s0),
			   .G(G0),
			   .P(P0));
  fulladder a1(.a(a[1]),
               .b(b[1]),
			   .c(c[1]),
			   .s(s1),
			   .G(G1),
			   .P(P1));
  fulladder a2(.a(a[2]),
               .b(b[2]),
			   .c(c[2]),
			   .s(s2),
			   .G(G2),
			   .P(P2));
  fulladder a3(.a(a[3]),
               .b(b[3]),
			   .c(c[3]),
			   .s(s3),
			   .G(G3),
			   .P(P3));

endmodule

module fulladder(a, b, c, s, G, P);

  input a;
  input b;
  input c;
  
  output s;
  output G;
  output P;
  
  assign s = a^b^c;
  assign G = a&b;
  assign P = a|b;

endmodule