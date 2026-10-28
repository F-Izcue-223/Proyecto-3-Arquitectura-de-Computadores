# Orden de pines (`librelane/pin_order.cfg`)

El archivo de LibreLane no admite comentarios (el `#` marca el lado), por eso la justificacion esta aqui.

- **Oeste: `i_Clk`, `i_Rst_n`.** Entradas de control juntas, un solo lado para el arbol de reloj y el reset.
- **Sur: `i_Btn[3:0]`, `o_LED[3:0]`.** La "cara" del juego: lo que toca el usuario.
- **Norte: `o_Seg1[6:0]`, `o_Seg2[6:0]`.** Los 14 pines de los displays, en un grupo contiguo.
- **Este: SPI (`i_SPI_SCLK`, `i_SPI_MOSI`, `i_SPI_CS_n`, `o_SPI_MISO`).** Esclavo SPI, alejado del reloj.
