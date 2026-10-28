// Copyright 2026 Universidad de los Andes.
// SPDX-License-Identifier: SHL-0.51
//
// RAM de datos reducida (estrategia 1) hecha de flip-flops.
//
// DataWords palabras de 32 bits (8 por defecto). Escritura por byte, lectura
// sincronica (el dato aparece un ciclo despues), como la RAM del Proyecto 2.
// Las direcciones se repliegan sobre las DataWords palabras (se usan solo los bits
// bajos de la direccion). No tiene reset: el programa no debe suponer su contenido
// al encender.

module pochoco_dram #(
  parameter DataWords = 8
) (
  input  wire        clk_i,
  input  wire        req_i,
  input  wire        we_i,
  input  wire [3:0]  be_i,
  input  wire [31:0] addr_i,
  input  wire [31:0] wdata_i,
  output reg  [31:0] rdata_o
);

  localparam AddrW = $clog2(DataWords);

  reg [31:0] mem_q [0:DataWords-1];

  wire [AddrW-1:0] idx = addr_i[AddrW+1:2];

  always @(posedge clk_i) begin
    if (req_i && we_i) begin
      if (be_i[0]) mem_q[idx][7:0]   <= wdata_i[7:0];
      if (be_i[1]) mem_q[idx][15:8]  <= wdata_i[15:8];
      if (be_i[2]) mem_q[idx][23:16] <= wdata_i[23:16];
      if (be_i[3]) mem_q[idx][31:24] <= wdata_i[31:24];
    end
    rdata_o <= mem_q[idx];
  end

endmodule
