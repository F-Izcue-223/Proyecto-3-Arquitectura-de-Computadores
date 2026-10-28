// Modelo de comportamiento de SB_RAM40_4K (BRAM de la FPGA iCE40, modo 256x16).
// SOLO para la corrida 0b: sin este modelo LibreLane se detiene porque el modulo
// no existe fuera de la FPGA. No forma parte del diseno ASIC.
module SB_RAM40_4K #(
  parameter READ_MODE = 0,
  parameter WRITE_MODE = 0,
  parameter [255:0] INIT_0 = 256'h0
) (
  output reg  [15:0] RDATA,
  input  wire [10:0] RADDR,
  input  wire        RCLK, RCLKE, RE,
  input  wire [15:0] WDATA,
  input  wire [10:0] WADDR,
  input  wire        WCLK, WCLKE, WE,
  input  wire [15:0] MASK
);
  reg [15:0] mem [0:255];
  integer i;
  initial begin
    for (i = 0; i < 16; i = i + 1) mem[i] = INIT_0[16*i +: 16];
    for (i = 16; i < 256; i = i + 1) mem[i] = 16'h0;
  end
  always @(posedge WCLK) if (WCLKE && WE)
    mem[WADDR[7:0]] <= (mem[WADDR[7:0]] & MASK) | (WDATA & ~MASK);
  always @(posedge RCLK) if (RCLKE && RE) RDATA <= mem[RADDR[7:0]];
endmodule
