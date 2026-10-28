// Copyright 2026 Universidad de los Andes.
// Licensed under the Solderpad Hardware License, Version 0.51 (the "License");
// SPDX-License-Identifier: SHL-0.51
//
// Course: Arquitectura de Computadores (2026)
//
// Banco de registros para ASIC (Proyecto 3).
//
// Version FPGA (Proyecto 2): dos copias de un banco hecho con bloques SB_RAM40_4K
// de la iCE40, una por puerto de lectura. Ese bloque no existe en silicio.
//
// Version ASIC: un solo arreglo de 15 registros de 32 bits (x1..x15) hecho de
// flip-flops, con dos puertos de lectura. x0 no se almacena: se lee como 0.
//
// El comportamiento por ciclos es identico al de la BRAM, para no tocar el nucleo:
//   - la lectura es sincronica: el dato aparece un ciclo despues de pedir la direccion
//     (por eso el nucleo espera un ciclo en espino_id_stage con ops_valid_q);
//   - si se lee y se escribe la misma direccion en el mismo flanco, la lectura
//     entrega el valor anterior (asignaciones no bloqueantes).

module espino_register_file (
  input  wire        clk_i,
  input  wire        rst_ni,     // unused: los registros no se reinician
  input  wire [3:0]  raddr_a_i,
  output reg  [31:0] rdata_a_o,
  input  wire [3:0]  raddr_b_i,
  output reg  [31:0] rdata_b_o,
  input  wire [3:0]  waddr_i,
  input  wire [31:0] wdata_i,
  input  wire        we_i
);

  reg [31:0] regs_q [1:15];

  wire wr = we_i & (waddr_i != 4'd0);

  always @(posedge clk_i) begin
    if (wr) regs_q[waddr_i] <= wdata_i;
  end

  always @(posedge clk_i) begin
    rdata_a_o <= (raddr_a_i == 4'd0) ? 32'b0 : regs_q[raddr_a_i];
    rdata_b_o <= (raddr_b_i == 4'd0) ? 32'b0 : regs_q[raddr_b_i];
  end

  wire _unused = &{1'b0, rst_ni};
endmodule
