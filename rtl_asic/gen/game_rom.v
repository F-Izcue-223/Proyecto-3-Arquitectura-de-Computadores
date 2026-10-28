// pochoco_rom: GENERADO por asm/pochoasm.py. No editar a mano.
// Programa: 114 palabras de 32 bits. Direccion de palabra: 7 bits.
// ROM combinacional: la salida depende solo de la direccion.
module pochoco_rom (
  input  wire [6:0] addr_i,
  output reg  [31:0] data_o
);
  always @* begin
    case (addr_i)
      7'd0: data_o = 32'h80000437;  // li   s0, PERIPH
      7'd1: data_o = 32'h00000513;  // li   a0, 0
      7'd2: data_o = 32'h180000ef;  // call show_number
      7'd3: data_o = 32'h0bc000ef;  // call wait_release
      7'd4: data_o = 32'h0e0000ef;  // call wait_start
      7'd5: data_o = 32'h00156493;  // ori  s1, a0, 1
      7'd6: data_o = 32'h00000793;  // li   a5, 0
      7'd7: data_o = 32'h00000713;  // li   a4, 0
      7'd8: data_o = 32'h00000513;  // li   a0, 0
      7'd9: data_o = 32'h164000ef;  // call show_number
      7'd10: data_o = 32'h00f00293;  // li   t0, 0xF
      7'd11: data_o = 32'h00542223;  // sw   t0, LEDS(s0)
      7'd12: data_o = 32'h01c9c537;  // li   a0, WAIT_CYCLES
      7'd13: data_o = 32'h38050513;
      7'd14: data_o = 32'h07c000ef;  // call wait_cycles
      7'd15: data_o = 32'h08c000ef;  // call wait_release
      7'd16: data_o = 32'h0ec000ef;  // call pick_target
      7'd17: data_o = 32'h00050693;  // mv   a3, a0
      7'd18: data_o = 32'h00d42223;  // sw   a3, LEDS(s0)
      7'd19: data_o = 32'h00c42603;  // lw   a2, CYCLES(s0)
      7'd20: data_o = 32'h00842283;  // lw   t0, BUTTONS(s0)
      7'd21: data_o = 32'hfe028ee3;  // beqz t0, wait_press
      7'd22: data_o = 32'h00c42303;  // lw   t1, CYCLES(s0)
      7'd23: data_o = 32'h04d29663;  // bne  t0, a3, wrong
      7'd24: data_o = 32'h40c30533;  // sub  a0, t1, a2
      7'd25: data_o = 32'h000f45b7;  // li   a1, TENTH_CYCLES
      7'd26: data_o = 32'h24058593;
      7'd27: data_o = 32'h100000ef;  // call divu
      7'd28: data_o = 32'h00a70733;  // add  a4, a4, a0
      7'd29: data_o = 32'h114000ef;  // call show_number
      7'd30: data_o = 32'h00178793;  // addi a5, a5, 1
      7'd31: data_o = 32'h00a00293;  // li   t0, ROUNDS
      7'd32: data_o = 32'hfa57e4e3;  // bltu a5, t0, round
      7'd33: data_o = 32'h00042223;  // sw   zero, LEDS(s0)
      7'd34: data_o = 32'h01c9c537;  // li   a0, WAIT_CYCLES
      7'd35: data_o = 32'h38050513;
      7'd36: data_o = 32'h024000ef;  // call wait_cycles
      7'd37: data_o = 32'h00070513;  // mv   a0, a4
      7'd38: data_o = 32'h00a00593;  // li   a1, ROUNDS
      7'd39: data_o = 32'h0d0000ef;  // call divu
      7'd40: data_o = 32'h0e8000ef;  // call show_number
      7'd41: data_o = 32'hf69ff06f;  // j    game
      7'd42: data_o = 32'h0ee00293;  // li   t0, ERROR_CODE
      7'd43: data_o = 32'h00542023;  // sw   t0, DISPLAY(s0)
      7'd44: data_o = 32'hf79ff06f;  // j    round
      7'd45: data_o = 32'h00c42283;  // lw   t0, CYCLES(s0)
      7'd46: data_o = 32'h00c42303;  // lw   t1, CYCLES(s0)
      7'd47: data_o = 32'h40530333;  // sub  t1, t1, t0
      7'd48: data_o = 32'hfea36ce3;  // bltu t1, a0, wc_loop
      7'd49: data_o = 32'h00008067;  // ret
      7'd50: data_o = 32'h000315b7;  // li   a1, DEBOUNCE_CYCLES
      7'd51: data_o = 32'hd4058593;
      7'd52: data_o = 32'h00c42283;  // lw   t0, CYCLES(s0)
      7'd53: data_o = 32'h00c42303;  // lw   t1, CYCLES(s0)
      7'd54: data_o = 32'h00842383;  // lw   t2, BUTTONS(s0)
      7'd55: data_o = 32'h00038463;  // beqz t2, wr_quiet
      7'd56: data_o = 32'h00030293;  // mv   t0, t1
      7'd57: data_o = 32'h40530333;  // sub  t1, t1, t0
      7'd58: data_o = 32'hfeb366e3;  // bltu t1, a1, wr_loop
      7'd59: data_o = 32'h00008067;  // ret
      7'd60: data_o = 32'h00500393;  // li   t2, 0b0101
      7'd61: data_o = 32'h002625b7;  // li   a1, BLINK_CYCLES
      7'd62: data_o = 32'h5a058593;
      7'd63: data_o = 32'h00c42283;  // lw   t0, CYCLES(s0)
      7'd64: data_o = 32'h00742223;  // sw   t2, LEDS(s0)
      7'd65: data_o = 32'h00842303;  // lw   t1, BUTTONS(s0)
      7'd66: data_o = 32'h00031e63;  // bnez t1, ws_pressed
      7'd67: data_o = 32'h00c42303;  // lw   t1, CYCLES(s0)
      7'd68: data_o = 32'h40530333;  // sub  t1, t1, t0
      7'd69: data_o = 32'hfeb366e3;  // bltu t1, a1, ws_loop
      7'd70: data_o = 32'h00f3c393;  // xori t2, t2, 0xF
      7'd71: data_o = 32'h00b282b3;  // add  t0, t0, a1
      7'd72: data_o = 32'hfe1ff06f;  // j    ws_loop
      7'd73: data_o = 32'h00c42503;  // lw   a0, CYCLES(s0)
      7'd74: data_o = 32'h00008067;  // ret
      7'd75: data_o = 32'h004003b7;  // li   t2, LFSR_TAPS
      7'd76: data_o = 32'h00738393;
      7'd77: data_o = 32'h02000313;  // li   t1, LFSR_STEPS
      7'd78: data_o = 32'h009482b3;  // add  t0, s1, s1
      7'd79: data_o = 32'h0004d463;  // bge  s1, zero, pt_no_tap
      7'd80: data_o = 32'h0072c2b3;  // xor  t0, t0, t2
      7'd81: data_o = 32'h00028493;  // mv   s1, t0
      7'd82: data_o = 32'hfff30313;  // addi t1, t1, -1
      7'd83: data_o = 32'hfe0316e3;  // bnez t1, pt_step
      7'd84: data_o = 32'h0034f293;  // andi t0, s1, 3
      7'd85: data_o = 32'h00100513;  // li   a0, 1
      7'd86: data_o = 32'h00028863;  // beqz t0, pt_done
      7'd87: data_o = 32'h00a50533;  // add  a0, a0, a0
      7'd88: data_o = 32'hfff28293;  // addi t0, t0, -1
      7'd89: data_o = 32'hff5ff06f;  // j    pt_mask
      7'd90: data_o = 32'h00008067;  // ret
      7'd91: data_o = 32'h00000293;  // li   t0, 0
      7'd92: data_o = 32'h00b56863;  // bltu a0, a1, du_done
      7'd93: data_o = 32'h40b50533;  // sub  a0, a0, a1
      7'd94: data_o = 32'h00128293;  // addi t0, t0, 1
      7'd95: data_o = 32'hff5ff06f;  // j    du_loop
      7'd96: data_o = 32'h00028513;  // mv   a0, t0
      7'd97: data_o = 32'h00008067;  // ret
      7'd98: data_o = 32'h06300293;  // li   t0, 99
      7'd99: data_o = 32'h00a2f463;  // bleu a0, t0, sn_fits
      7'd100: data_o = 32'h00028513;  // mv   a0, t0
      7'd101: data_o = 32'h00000313;  // li   t1, 0
      7'd102: data_o = 32'h00a00393;  // li   t2, 10
      7'd103: data_o = 32'h00756863;  // bltu a0, t2, sn_write
      7'd104: data_o = 32'h40750533;  // sub  a0, a0, t2
      7'd105: data_o = 32'h00130313;  // addi t1, t1, 1
      7'd106: data_o = 32'hff5ff06f;  // j    sn_tens
      7'd107: data_o = 32'h00630333;  // add  t1, t1, t1
      7'd108: data_o = 32'h00630333;  // add  t1, t1, t1
      7'd109: data_o = 32'h00630333;  // add  t1, t1, t1
      7'd110: data_o = 32'h00630333;  // add  t1, t1, t1
      7'd111: data_o = 32'h00a30333;  // add  t1, t1, a0
      7'd112: data_o = 32'h00642023;  // sw   t1, DISPLAY(s0)
      7'd113: data_o = 32'h00008067;  // ret
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
  pochoco_rom u_rom (.addr_i(addr_i[8:2]), .data_o(rom_data));
  always @(posedge clk_i) begin
    if (req_i) rdata_o <= (addr_i[31:9] == 0) ? rom_data : 32'h00000013;
  end
endmodule
