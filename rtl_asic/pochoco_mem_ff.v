// Copyright 2026 Universidad de los Andes.
// SPDX-License-Identifier: SHL-0.51
//
// Estrategia 2: memoria unificada de flip-flops, dimensionada segun el uso real.
//
// Tamano: PROG_WORDS palabras de programa (las cuenta el assembler y las deja en
// gen/game_mem_init.vh) mas DataWords palabras de datos. Instrucciones y datos
// comparten el mismo arreglo, como la RAM del Proyecto 2, y el programa se puede
// leer y escribir como datos.
//
// El programa llega en los valores de RESET de los flip-flops de las palabras
// 0..PROG_WORDS-1: al soltar el reset la memoria ya contiene el juego. Las palabras
// de datos se reinician en 0. Es la forma de que no exista un archivo .hex que cargar.
//
// Cada palabra es un registro propio (generate) para que el reset por palabra se
// pueda sintetizar con flip-flops, sin inferir un bloque de RAM.

module pochoco_mem_ff #(
  parameter DataWords = 8
) (
  input  wire        clk_i,
  input  wire        rst_ni,
  input  wire        a_req_i,
  input  wire [31:0] a_addr_i,
  output reg  [31:0] a_rdata_o,
  input  wire        b_req_i,
  input  wire        b_we_i,
  input  wire [3:0]  b_be_i,
  input  wire [31:0] b_addr_i,
  input  wire [31:0] b_wdata_i,
  output reg  [31:0] b_rdata_o
);

  `include "game_mem_init.vh"   // PROG_WORDS y PROG_INIT, generados por pochoasm.py

  localparam NumWords = PROG_WORDS + DataWords;
  localparam AddrW    = $clog2(NumWords);

  wire [AddrW-1:0] a_idx = a_addr_i[AddrW+1:2];
  wire [AddrW-1:0] b_idx = b_addr_i[AddrW+1:2];
  wire             a_ok  = (a_addr_i[31:AddrW+2] == 0) && (a_idx < NumWords);
  wire             b_ok  = (b_addr_i[31:AddrW+2] == 0) && (b_idx < NumWords);

  wire [31:0] word_w [0:NumWords-1];

  genvar g;
  generate
    for (g = 0; g < NumWords; g = g + 1) begin : g_word
      localparam [31:0] RESET_VAL = (g < PROG_WORDS) ? PROG_INIT[32*(g % PROG_WORDS) +: 32] : 32'h0;
      reg [31:0] q;
      wire we = b_req_i & b_we_i & b_ok & (b_idx == g);
      always @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) q <= RESET_VAL;
        else if (we) begin
          if (b_be_i[0]) q[7:0]   <= b_wdata_i[7:0];
          if (b_be_i[1]) q[15:8]  <= b_wdata_i[15:8];
          if (b_be_i[2]) q[23:16] <= b_wdata_i[23:16];
          if (b_be_i[3]) q[31:24] <= b_wdata_i[31:24];
        end
      end
      assign word_w[g] = q;
    end
  endgenerate

  // Lecturas sincronicas. Fuera de la memoria: nop para instrucciones, 0 para datos.
  always @(posedge clk_i) begin
    if (a_req_i) a_rdata_o <= a_ok ? word_w[a_idx] : 32'h00000013;
    b_rdata_o <= b_ok ? word_w[b_idx] : 32'h0;
  end

endmodule
