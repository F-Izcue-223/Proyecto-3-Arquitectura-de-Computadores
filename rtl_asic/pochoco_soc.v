// Copyright 2026 Universidad de los Andes.
// Licensed under the Solderpad Hardware License, Version 0.51 (the "License");
// SPDX-License-Identifier: SHL-0.51
//
// Course: Arquitectura de Computadores (2026)
// Original: Nicolas Villegas <navillegas@miuandes.cl>
//
// Pochoco SoC, version ASIC (Proyecto 3).
// Cambios respecto a la version de FPGA del Proyecto 2:
//   - El reset ya no se genera aqui (el contador por_cnt de 4095 ciclos esperaba a
//     las block RAM de la FPGA). rst_ni llega de afuera, ya sincronizado (asic_top).
//   - Los siete segmentos salen como vectores activos en alto; la inversion para
//     la Go Board era propia de la placa y no del macro.
//   - Los botones llegan ya sincronizados al reloj (asic_top).

module pochoco_soc #(
  parameter DataWords = 8        // palabras de RAM de datos
) (
  input  wire       clk_i,
  input  wire       rst_ni,

  output wire [3:0] o_LED,
  input  wire [3:0] i_Switch,

  output wire [6:0] o_Seg1,       // {G,F,E,D,C,B,A}, activo en alto
  output wire [6:0] o_Seg2,

  input  wire       i_SPI_SCLK,
  input  wire       i_SPI_MOSI,
  input  wire       i_SPI_CS_n,
  output wire       o_SPI_MISO
);

  wire clk = clk_i;

  // Core-memory wiring
  wire        instr_req;
  wire [31:0] instr_addr, instr_rdata;

  wire        data_req, data_we;
  wire [3:0]  data_be;
  wire [31:0] data_addr, data_wdata, data_rdata;

  espino_core #(.BootAddr(32'h0000_0000)) u_core (
    .clk_i         (clk),
    .rst_ni        (rst_ni),
    .instr_req_o   (instr_req),
    .instr_addr_o  (instr_addr),
    .instr_rdata_i (instr_rdata),
    .data_req_o    (data_req),
    .data_we_o     (data_we),
    .data_be_o     (data_be),
    .data_addr_o   (data_addr),
    .data_wdata_o  (data_wdata),
    .data_rdata_i  (data_rdata)
  );

  wire is_mmio, spi_sel, per_sel;
  assign is_mmio = data_addr[31];
  assign per_sel = is_mmio & ~data_addr[16];
  assign spi_sel = is_mmio &  data_addr[16];

  wire ram_b_req, per_req, spi_req;
  assign ram_b_req = data_req & ~is_mmio;
  assign per_req   = data_req &  per_sel;
  assign spi_req   = data_req &  spi_sel;

  wire [31:0] ram_b_rdata, per_rdata, spi_rdata;

  reg rd_is_per, rd_is_spi;
  always @(posedge clk or negedge rst_ni) begin
    if (!rst_ni) begin
      rd_is_per <= 1'b0;
      rd_is_spi <= 1'b0;
    end else if (data_req & ~data_we) begin
      rd_is_per <= per_sel;
      rd_is_spi <= spi_sel;
    end
  end
  assign data_rdata = rd_is_per ? per_rdata :
                      rd_is_spi ? spi_rdata : ram_b_rdata;

  // Memoria. Estrategia 1 (por defecto): ROM generada por el assembler + RAM de
  // datos reducida. Estrategia 2 (-DMEM_FF): memoria unificada de flip-flops.
`ifdef MEM_FF
  pochoco_mem_ff #(.DataWords(DataWords)) u_mem (
`else
  pochoco_mem_rom #(.DataWords(DataWords)) u_mem (
`endif
    .clk_i     (clk),
    .rst_ni    (rst_ni),
    .a_req_i   (instr_req),
    .a_addr_i  (instr_addr),
    .a_rdata_o (instr_rdata),
    .b_req_i   (ram_b_req),
    .b_we_i    (data_we),
    .b_be_i    (data_be),
    .b_addr_i  (data_addr),
    .b_wdata_i (data_wdata),
    .b_rdata_o (ram_b_rdata)
  );

  pochoco_periph u_periph (
    .clk_i     (clk),
    .rst_ni    (rst_ni),
    .sel_i     (per_sel),
    .req_i     (per_req),
    .we_i      (data_we),
    .addr_i    (data_addr[7:0]),
    .wdata_i   (data_wdata),
    .rdata_o   (per_rdata),
    .leds_o    (o_LED),
    .btn_i     (i_Switch),
    .seg1_o    (o_Seg1),
    .seg2_o    (o_Seg2)
  );

  pochoco_spi_slave u_spi (
    .clk_i      (clk),
    .rst_ni     (rst_ni),
    .sel_i      (spi_sel),
    .req_i      (spi_req),
    .we_i       (data_we),
    .addr_i     (data_addr[7:0]),
    .wdata_i    (data_wdata),
    .rdata_o    (spi_rdata),
    .spi_sclk_i (i_SPI_SCLK),
    .spi_mosi_i (i_SPI_MOSI),
    .spi_cs_n_i (i_SPI_CS_n),
    .spi_miso_o (o_SPI_MISO)
  );

endmodule
