// and_beh_intra.v
// 2-input AND, BEHAVIORAL style with an INTRA-assignment delay.
module and_beh_intra (
  input      a,
  input      b,
  output reg y
);

  always @(*)
    y = #3 a & b;

endmodule
