// Copyright 2026 Universidad de los Andes.
// SPDX-License-Identifier: SHL-0.51
//
// asic_top: modulo superior del macro ASIC (Proyecto 3).
//
// Reemplaza a game_top.v (Proyecto 2), que era propio de la Go Board. Sus puertos
// son las funciones logicas del juego: reloj, reset, LEDs, botones, displays de
// 7 segmentos y SPI. Son terminales del macro, no pads de I/O: un chip completo
// agregaria pads con proteccion ESD y manejo de carga.
//
// Aqui solo se acondicionan las entradas asincronas:
//   - i_Rst_n: se activa de forma asincronica y se suelta sincronizada al reloj
//     (sincronizador de reset de dos flip-flops).
//   - i_Btn: los botones no tienen relacion con el reloj; cada bit pasa por un
//     sincronizador de dos flip-flops antes de llegar al SoC.
// Las entradas SPI ya se sincronizan dentro de pochoco_spi_slave.
//
// No hay bloques initial, valores iniciales en declaraciones ni $readmemh.

module asic_top (
  input  wire       i_Clk,
  input  wire       i_Rst_n,        // reset activo en bajo, asincrono

  output wire [3:0] o_LED,
  input  wire [3:0] i_Btn,          // boton i corresponde al LED i

  output wire [6:0] o_Seg1,         // {G,F,E,D,C,B,A}, activo en alto
  output wire [6:0] o_Seg2,

  input  wire       i_SPI_SCLK,
  input  wire       i_SPI_MOSI,
  input  wire       i_SPI_CS_n,
  output wire       o_SPI_MISO
);

  // Sincronizador de reset: asercion asincrona, liberacion sincrona.
  reg [1:0] rst_sync_q;
  always @(posedge i_Clk or negedge i_Rst_n) begin
    if (!i_Rst_n) rst_sync_q <= 2'b00;
    else          rst_sync_q <= {rst_sync_q[0], 1'b1};
  end
  wire rst_n = rst_sync_q[1];

  // Sincronizador de botones (sin reset: se llenan en dos ciclos).
  reg [3:0] btn_meta_q, btn_sync_q;
  always @(posedge i_Clk) begin
    btn_meta_q <= i_Btn;
    btn_sync_q <= btn_meta_q;
  end

  pochoco_soc #(.DataWords(8)) u_soc (
    .clk_i      (i_Clk),
    .rst_ni     (rst_n),
    .o_LED      (o_LED),
    .i_Switch   (btn_sync_q),
    .o_Seg1     (o_Seg1),
    .o_Seg2     (o_Seg2),
    .i_SPI_SCLK (i_SPI_SCLK),
    .i_SPI_MOSI (i_SPI_MOSI),
    .i_SPI_CS_n (i_SPI_CS_n),
    .o_SPI_MISO (o_SPI_MISO)
  );

endmodule
