// and_df.v
// 2-input AND, DATAFLOW style with a continuous-assignment delay.
module and_df (
  input  a,
  input  b,
  output y
);

  assign #3 y = a & b;

endmodule
