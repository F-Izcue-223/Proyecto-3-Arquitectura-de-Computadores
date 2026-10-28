// Copyright 2026 Universidad de los Andes.
// SPDX-License-Identifier: SHL-0.51
//
// Contador de ciclos de 32 bits agregado en el Proyecto 2.
// Suma 1 en cada flanco de reloj desde que se suelta el reset. Es de solo lectura
// para el programa (direccion base + 0xC). Da la vuelta tras 2^32 ciclos; el
// software mide intervalos como (ahora - inicio) en aritmetica sin signo.
//
// Esta en su propio modulo para poder medir su area por separado (seccion 3.3).

module pochoco_cycle_counter (
  input  wire        clk_i,
  input  wire        rst_ni,
  output wire [31:0] count_o
);

  reg [31:0] cycle_q;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) cycle_q <= 32'b0;
    else         cycle_q <= cycle_q + 32'd1;
  end

  assign count_o = cycle_q;

endmodule
