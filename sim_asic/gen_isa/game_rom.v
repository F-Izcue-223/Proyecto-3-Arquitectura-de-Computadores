// pochoco_rom: GENERADO por asm/pochoasm.py. No editar a mano.
// Programa: 208 palabras de 32 bits. Direccion de palabra: 8 bits.
// ROM combinacional: la salida depende solo de la direccion.
module pochoco_rom (
  input  wire [7:0] addr_i,
  output reg  [31:0] data_o
);
  always @* begin
    case (addr_i)
      8'd0: data_o = 32'h80000437;  // li   s0, PERIPH
      8'd1: data_o = 32'h00100193;  // li   gp, 1
      8'd2: data_o = 32'h00500293;  // li   t0, 5
      8'd3: data_o = 32'h00700313;  // li   t1, 7
      8'd4: data_o = 32'h00628533;  // add  a0, t0, t1
      8'd5: data_o = 32'h00c00393;  // li   t2, 12
      8'd6: data_o = 32'h30751663;  // bne  a0, t2, fail
      8'd7: data_o = 32'h00200193;  // li   gp, 2
      8'd8: data_o = 32'h40628533;  // sub  a0, t0, t1
      8'd9: data_o = 32'hffe00393;  // li   t2, -2
      8'd10: data_o = 32'h2e751e63;  // bne  a0, t2, fail
      8'd11: data_o = 32'h00300193;  // li   gp, 3
      8'd12: data_o = 32'h000012b7;  // li   t0, 0x0F0F
      8'd13: data_o = 32'hf0f28293;
      8'd14: data_o = 32'h0ff00313;  // li   t1, 0x00FF
      8'd15: data_o = 32'h0062c533;  // xor  a0, t0, t1
      8'd16: data_o = 32'h000013b7;  // li   t2, 0x0FF0
      8'd17: data_o = 32'hff038393;
      8'd18: data_o = 32'h2c751e63;  // bne  a0, t2, fail
      8'd19: data_o = 32'h0062e533;  // or   a0, t0, t1
      8'd20: data_o = 32'h000013b7;  // li   t2, 0x0FFF
      8'd21: data_o = 32'hfff38393;
      8'd22: data_o = 32'h2c751663;  // bne  a0, t2, fail
      8'd23: data_o = 32'h0062f533;  // and  a0, t0, t1
      8'd24: data_o = 32'h00f00393;  // li   t2, 0x000F
      8'd25: data_o = 32'h2c751063;  // bne  a0, t2, fail
      8'd26: data_o = 32'h00400193;  // li   gp, 4
      8'd27: data_o = 32'hfff00293;  // li   t0, -1
      8'd28: data_o = 32'h00100313;  // li   t1, 1
      8'd29: data_o = 32'h0062a533;  // slt  a0, t0, t1
      8'd30: data_o = 32'h00100393;  // li   t2, 1
      8'd31: data_o = 32'h2a751463;  // bne  a0, t2, fail
      8'd32: data_o = 32'h0062b533;  // sltu a0, t0, t1
      8'd33: data_o = 32'h2a051063;  // bnez a0, fail
      8'd34: data_o = 32'h00500193;  // li   gp, 5
      8'd35: data_o = 32'h06400293;  // li   t0, 100
      8'd36: data_o = 32'h80028513;  // addi a0, t0, -2048
      8'd37: data_o = 32'h86400393;  // li   t2, -1948
      8'd38: data_o = 32'h28751663;  // bne  a0, t2, fail
      8'd39: data_o = 32'h7ff28513;  // addi a0, t0, 2047
      8'd40: data_o = 32'h000013b7;  // li   t2, 2147
      8'd41: data_o = 32'h86338393;
      8'd42: data_o = 32'h26751e63;  // bne  a0, t2, fail
      8'd43: data_o = 32'h00600193;  // li   gp, 6
      8'd44: data_o = 32'h0652a513;  // slti  a0, t0, 101
      8'd45: data_o = 32'h00100393;  // li    t2, 1
      8'd46: data_o = 32'h26751663;  // bne   a0, t2, fail
      8'd47: data_o = 32'h0642b513;  // sltiu a0, t0, 100
      8'd48: data_o = 32'h26051263;  // bnez  a0, fail
      8'd49: data_o = 32'hffb00313;  // li    t1, -5
      8'd50: data_o = 32'h00533513;  // sltiu a0, t1, 5
      8'd51: data_o = 32'h24051c63;  // bnez  a0, fail
      8'd52: data_o = 32'h00700193;  // li   gp, 7
      8'd53: data_o = 32'h5a500293;  // li   t0, 0x5A5
      8'd54: data_o = 32'hfff2c513;  // xori a0, t0, -1
      8'd55: data_o = 32'ha5a00393;  // li   t2, 0xFFFFFA5A
      8'd56: data_o = 32'h24751263;  // bne  a0, t2, fail
      8'd57: data_o = 32'h00f2e513;  // ori  a0, t0, 0x00F
      8'd58: data_o = 32'h5af00393;  // li   t2, 0x5AF
      8'd59: data_o = 32'h22751c63;  // bne  a0, t2, fail
      8'd60: data_o = 32'h0f02f513;  // andi a0, t0, 0x0F0
      8'd61: data_o = 32'h0a000393;  // li   t2, 0x0A0
      8'd62: data_o = 32'h22751663;  // bne  a0, t2, fail
      8'd63: data_o = 32'h00800193;  // li   gp, 8
      8'd64: data_o = 32'h12345537;  // lui  a0, 0x12345
      8'd65: data_o = 32'h123453b7;  // li   t2, 0x12345000
      8'd66: data_o = 32'h20751e63;  // bne  a0, t2, fail
      8'd67: data_o = 32'h12346537;  // li   a0, 0x12345800
      8'd68: data_o = 32'h80050513;
      8'd69: data_o = 32'h123453b7;  // li   t2, 0x12345000
      8'd70: data_o = 32'h40750533;  // sub  a0, a0, t2
      8'd71: data_o = 32'h000013b7;  // li   t2, 0x800
      8'd72: data_o = 32'h80038393;
      8'd73: data_o = 32'h20751063;  // bne  a0, t2, fail
      8'd74: data_o = 32'h00900193;  // li   gp, 9
      8'd75: data_o = 32'h004000ef;  // jal  ra, here
      8'd76: data_o = 32'h00000517;  // auipc a0, 0
      8'd77: data_o = 32'h1e151863;  // bne   a0, ra, fail
      8'd78: data_o = 32'h00001597;  // auipc a1, 1
      8'd79: data_o = 32'h401585b3;  // sub   a1, a1, ra
      8'd80: data_o = 32'h000013b7;  // li    t2, 0x1008
      8'd81: data_o = 32'h00838393;
      8'd82: data_o = 32'h1c759e63;  // bne   a1, t2, fail
      8'd83: data_o = 32'h00a00193;  // li   gp, 10
      8'd84: data_o = 32'hfff00293;  // li   t0, -1
      8'd85: data_o = 32'h00100313;  // li   t1, 1
      8'd86: data_o = 32'h00528463;  // beq  t0, t0, b1
      8'd87: data_o = 32'h1c80006f;  // j    fail
      8'd88: data_o = 32'h1c628263;  // b1: beq  t0, t1, fail
      8'd89: data_o = 32'h00629463;  // bne  t0, t1, b2
      8'd90: data_o = 32'h1bc0006f;  // j    fail
      8'd91: data_o = 32'h1a529c63;  // b2: bne  t0, t0, fail
      8'd92: data_o = 32'h0062c463;  // blt  t0, t1, b3
      8'd93: data_o = 32'h1b00006f;  // j    fail
      8'd94: data_o = 32'h1a534663;  // b3: blt  t1, t0, fail
      8'd95: data_o = 32'h00535463;  // bge  t1, t0, b4
      8'd96: data_o = 32'h1a40006f;  // j    fail
      8'd97: data_o = 32'h1a62d063;  // b4: bge  t0, t1, fail
      8'd98: data_o = 32'h0062f463;  // bgeu t0, t1, b5
      8'd99: data_o = 32'h1980006f;  // j    fail
      8'd100: data_o = 32'h18537a63;  // b5: bgeu t1, t0, fail
      8'd101: data_o = 32'h00536463;  // bltu t1, t0, b6
      8'd102: data_o = 32'h18c0006f;  // j    fail
      8'd103: data_o = 32'h1862e463;  // b6: bltu t0, t1, fail
      8'd104: data_o = 32'h0052d463;  // bge  t0, t0, b7
      8'd105: data_o = 32'h1800006f;  // j    fail
      8'd106: data_o = 32'h00b00193;  // li   gp, 11
      8'd107: data_o = 32'h00000513;  // li   a0, 0
      8'd108: data_o = 32'h184000ef;  // call add_three
      8'd109: data_o = 32'h180000ef;  // call add_three
      8'd110: data_o = 32'h00600393;  // li   t2, 6
      8'd111: data_o = 32'h16751463;  // bne  a0, t2, fail
      8'd112: data_o = 32'h00c00193;  // li   gp, 12
      8'd113: data_o = 32'h178000ef;  // jal  ra, get_ra
      8'd114: data_o = 32'h008082e7;  // jalr t0, 8(ra)
      8'd115: data_o = 32'h1580006f;  // j    fail
      8'd116: data_o = 32'h40128333;  // sub  t1, t0, ra
      8'd117: data_o = 32'h00400393;  // li   t2, 4
      8'd118: data_o = 32'h14731663;  // bne  t1, t2, fail
      8'd119: data_o = 32'h00d00193;  // li   gp, 13
      8'd120: data_o = 32'h34400293;  // li   t0, SCRATCH
      8'd121: data_o = 32'h11223337;  // li   t1, 0x11223344
      8'd122: data_o = 32'h34430313;
      8'd123: data_o = 32'h0062a023;  // sw   t1, 0(t0)
      8'd124: data_o = 32'h0002a503;  // lw   a0, 0(t0)
      8'd125: data_o = 32'h12651863;  // bne  a0, t1, fail
      8'd126: data_o = 32'h00e00193;  // li   gp, 14
      8'd127: data_o = 32'h0a100313;  // li   t1, 0xA1
      8'd128: data_o = 32'h00628023;  // sb   t1, 0(t0)
      8'd129: data_o = 32'h0b200313;  // li   t1, 0xB2
      8'd130: data_o = 32'h006280a3;  // sb   t1, 1(t0)
      8'd131: data_o = 32'h0c300313;  // li   t1, 0xC3
      8'd132: data_o = 32'h00628123;  // sb   t1, 2(t0)
      8'd133: data_o = 32'h08400313;  // li   t1, 0x84
      8'd134: data_o = 32'h006281a3;  // sb   t1, 3(t0)
      8'd135: data_o = 32'h0002a503;  // lw   a0, 0(t0)
      8'd136: data_o = 32'h84c3b3b7;  // li   t2, 0x84C3B2A1
      8'd137: data_o = 32'h2a138393;
      8'd138: data_o = 32'h0e751e63;  // bne  a0, t2, fail
      8'd139: data_o = 32'h00f00193;  // li   gp, 15
      8'd140: data_o = 32'h00328503;  // lb   a0, 3(t0)
      8'd141: data_o = 32'hf8400393;  // li   t2, -124
      8'd142: data_o = 32'h0e751663;  // bne  a0, t2, fail
      8'd143: data_o = 32'h0032c503;  // lbu  a0, 3(t0)
      8'd144: data_o = 32'h08400393;  // li   t2, 0x84
      8'd145: data_o = 32'h0e751063;  // bne  a0, t2, fail
      8'd146: data_o = 32'h0012c503;  // lbu  a0, 1(t0)
      8'd147: data_o = 32'h0b200393;  // li   t2, 0xB2
      8'd148: data_o = 32'h0c751a63;  // bne  a0, t2, fail
      8'd149: data_o = 32'h01000193;  // li   gp, 16
      8'd150: data_o = 32'h00008337;  // li   t1, 0x8001
      8'd151: data_o = 32'h00130313;
      8'd152: data_o = 32'h00629123;  // sh   t1, 2(t0)
      8'd153: data_o = 32'h0002a503;  // lw   a0, 0(t0)
      8'd154: data_o = 32'h8001b3b7;  // li   t2, 0x8001B2A1
      8'd155: data_o = 32'h2a138393;
      8'd156: data_o = 32'h0a751a63;  // bne  a0, t2, fail
      8'd157: data_o = 32'h00229503;  // lh   a0, 2(t0)
      8'd158: data_o = 32'hffff83b7;  // li   t2, 0xFFFF8001
      8'd159: data_o = 32'h00138393;
      8'd160: data_o = 32'h0a751263;  // bne  a0, t2, fail
      8'd161: data_o = 32'h0022d503;  // lhu  a0, 2(t0)
      8'd162: data_o = 32'h000083b7;  // li   t2, 0x8001
      8'd163: data_o = 32'h00138393;
      8'd164: data_o = 32'h08751a63;  // bne  a0, t2, fail
      8'd165: data_o = 32'h01100193;  // li   gp, 17
      8'd166: data_o = 32'hfe62ae23;  // sw   t1, -4(t0)
      8'd167: data_o = 32'hffc28393;  // addi t2, t0, -4
      8'd168: data_o = 32'h0003a503;  // lw   a0, 0(t2)
      8'd169: data_o = 32'h08651063;  // bne  a0, t1, fail
      8'd170: data_o = 32'h01200193;  // li   gp, 18
      8'd171: data_o = 32'h00842503;  // lw   a0, BUTTONS(s0)
      8'd172: data_o = 32'h00a00393;  // li   t2, 0xA
      8'd173: data_o = 32'h06751863;  // bne  a0, t2, fail
      8'd174: data_o = 32'h01300193;  // li   gp, 19
      8'd175: data_o = 32'h00c42283;  // lw   t0, CYCLES(s0)
      8'd176: data_o = 32'h00c42303;  // lw   t1, CYCLES(s0)
      8'd177: data_o = 32'h40530533;  // sub  a0, t1, t0
      8'd178: data_o = 32'h04050e63;  // beqz a0, fail
      8'd179: data_o = 32'h01400393;  // li   t2, 20
      8'd180: data_o = 32'h04757a63;  // bgeu a0, t2, fail
      8'd181: data_o = 32'h01400193;  // li   gp, 20
      8'd182: data_o = 32'h00500013;  // addi zero, zero, 5
      8'd183: data_o = 32'h04001463;  // bnez zero, fail
      8'd184: data_o = 32'h01500193;  // li   gp, 21
      8'd185: data_o = 32'h00500293;  // li   t0, 5
      8'd186: data_o = 32'h00329513;  // slli a0, t0, 3
      8'd187: data_o = 32'h00800393;  // li   t2, 8
      8'd188: data_o = 32'h02751a63;  // bne  a0, t2, fail
      8'd189: data_o = 32'h01600193;  // li   gp, 22
      8'd190: data_o = 32'h00000013;  // nop
      8'd191: data_o = 32'h00000073;  // ecall
      8'd192: data_o = 32'h00100073;  // ebreak
      8'd193: data_o = 32'h0ff0000f;  // fence
      8'd194: data_o = 32'h00800393;  // li   t2, 8
      8'd195: data_o = 32'h00751c63;  // bne  a0, t2, fail
      8'd196: data_o = 32'h0aa00293;  // li   t0, 0xAA
      8'd197: data_o = 32'h00542023;  // sw   t0, DISPLAY(s0)
      8'd198: data_o = 32'h00f00293;  // li   t0, 0xF
      8'd199: data_o = 32'h00542223;  // sw   t0, LEDS(s0)
      8'd200: data_o = 32'h0000006f;  // j    pass_loop
      8'd201: data_o = 32'h00342023;  // sw   gp, DISPLAY(s0)
      8'd202: data_o = 32'h00900293;  // li   t0, 0x9
      8'd203: data_o = 32'h00542223;  // sw   t0, LEDS(s0)
      8'd204: data_o = 32'h0000006f;  // j    fail_loop
      8'd205: data_o = 32'h00350513;  // addi a0, a0, 3
      8'd206: data_o = 32'h00008067;  // ret
      8'd207: data_o = 32'h00008067;  // ret
      default: data_o = 32'h00000013;  // nop
    endcase
  end
endmodule

// pochoco_imem: memoria de instrucciones = ROM + registro de salida.
// El nucleo espera la instruccion un ciclo despues de pedirla (lectura
// sincronica, como la RAM del Proyecto 2). El registro de salida entrega
// eso sin cambiar el nucleo. Fuera del programa devuelve un nop.
module pochoco_imem (
  input  wire        clk_i,
  input  wire        req_i,
  input  wire [31:0] addr_i,
  output reg  [31:0] rdata_o
);
  wire [31:0] rom_data;
  pochoco_rom u_rom (.addr_i(addr_i[9:2]), .data_o(rom_data));
  always @(posedge clk_i) begin
    if (req_i) rdata_o <= (addr_i[31:10] == 0) ? rom_data : 32'h00000013;
  end
endmodule
