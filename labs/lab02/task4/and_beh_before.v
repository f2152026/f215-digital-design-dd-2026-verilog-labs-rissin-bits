// and_beh_before.v
// 2-input AND, BEHAVIORAL style with the delay BEFORE the assignment.
module and_beh_before (
  input      a,
  input      b,
  output reg y
);

  always @(*)
    #3 y = a & b;


endmodule