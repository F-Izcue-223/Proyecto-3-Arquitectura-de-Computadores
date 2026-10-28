// Copyright 2026 Universidad de los Andes.
// SPDX-License-Identifier: SHL-0.51
//
// Estrategia 1: ROM combinacional (generada por el assembler) + RAM de datos reducida.
//
//   - Instrucciones: pochoco_imem (en gen/game_rom.v), ROM de un case por palabra
//     con registro de salida. Es de solo lectura: el programa no se puede modificar.
//   - Datos: pochoco_dram, DataWords palabras de flip-flops.
//
// Misma interfaz que la RAM unificada del Proyecto 2 (puerto A de instrucciones y
// puerto B de datos).

module pochoco_mem_rom #(
  parameter DataWords = 8
) (
  input  wire        clk_i,
  input  wire        rst_ni,      // unused
  input  wire        a_req_i,
  input  wire [31:0] a_addr_i,
  output wire [31:0] a_rdata_o,
  input  wire        b_req_i,
  input  wire        b_we_i,
  input  wire [3:0]  b_be_i,
  input  wire [31:0] b_addr_i,
  input  wire [31:0] b_wdata_i,
  output wire [31:0] b_rdata_o
);

  pochoco_imem u_imem (
    .clk_i   (clk_i),
    .req_i   (a_req_i),
    .addr_i  (a_addr_i),
    .rdata_o (a_rdata_o)
  );

  pochoco_dram #(.DataWords(DataWords)) u_dram (
    .clk_i   (clk_i),
    .req_i   (b_req_i),
    .we_i    (b_we_i),
    .be_i    (b_be_i),
    .addr_i  (b_addr_i),
    .wdata_i (b_wdata_i),
    .rdata_o (b_rdata_o)
  );

  wire _unused = &{1'b0, rst_ni};
endmodule
