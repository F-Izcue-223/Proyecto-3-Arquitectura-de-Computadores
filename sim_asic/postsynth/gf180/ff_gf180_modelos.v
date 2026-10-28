// Modelos funcionales de los 3 flip-flops de gf180mcu_fd_sc_mcu7t5v0 usados en la netlist.
// Los modelos "functional" del PDK para flip-flops usan primitivas UDP con nombres que no
// coinciden con las del directorio models/, y Verilator no las simula; aqui se escriben con
// la misma funcion logica (puertos identicos, incluido `notifier`, que la netlist no conecta).
module gf180mcu_fd_sc_mcu7t5v0__dffq_1(CLK, D, Q, notifier);
  input CLK, D, notifier; output reg Q;
  always @(posedge CLK) Q <= D;
endmodule
module gf180mcu_fd_sc_mcu7t5v0__dffrnq_1(CLK, D, RN, Q, notifier);   // reset asincrono activo en 0
  input CLK, D, RN, notifier; output reg Q;
  always @(posedge CLK or negedge RN) if (!RN) Q <= 1'b0; else Q <= D;
endmodule
module gf180mcu_fd_sc_mcu7t5v0__dffsnq_1(CLK, D, SETN, Q, notifier); // set asincrono activo en 0
  input CLK, D, SETN, notifier; output reg Q;
  always @(posedge CLK or negedge SETN) if (!SETN) Q <= 1'b1; else Q <= D;
endmodule
