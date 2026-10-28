// isa_tb para asic_top: corre isa_test.hex y revisa el resultado en los pines.
`timescale 1ns/1ps
module isa_tb;
  reg clk = 1'b0;
  always #20 clk = ~clk;
  reg rst_n = 1'b0;
  wire [3:0] led;
  wire [6:0] seg1_h, seg2_h;
  wire [6:0] seg1 = ~seg1_h, seg2 = ~seg2_h;   // seg2hex.vh espera pines activos en bajo

  asic_top dut (
    .i_Clk(clk), .i_Rst_n(rst_n), .o_LED(led), .i_Btn(4'b1010),
    .o_Seg1(seg1_h), .o_Seg2(seg2_h),
    .i_SPI_SCLK(1'b0), .i_SPI_MOSI(1'b0), .i_SPI_CS_n(1'b1), .o_SPI_MISO()
  );

  `include "sim/seg2hex.vh"

  initial begin
    repeat (5) @(posedge clk);
    rst_n = 1'b1;
    wait (led == 4'hF || led == 4'h9);
    repeat (5) @(posedge clk);
    if (led == 4'hF && shown(seg1, seg2) == 8'hAA)
      $display("ISA: OK - las pruebas pasaron");
    else
      $fatal(1, "ISA: FALLO - prueba %0d (displays = %h)", shown(seg1, seg2), shown(seg1, seg2));
    $finish;
  end
  initial begin
    #(40 * 20000);
    $fatal(1, "ISA: FALLO - timeout");
  end
endmodule
