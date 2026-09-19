// cla4.v
// Gate-level 4-bit carry-lookahead adder

module cla4(
  input  [3:0] a,
  input  [3:0] b,
  input        cin,
  output [3:0] sum,
  output       cout
);

  wire p0, p1, p2, p3;
  wire g0, g1, g2, g3;
  wire c1, c2, c3, c4;

  // --------------------------------------------------
  // Step 1: Propagate and Generate
  // p[i] = a[i] ^ b[i]
  // g[i] = a[i] & b[i]
  // --------------------------------------------------

  xor #(2) (p0, a[0], b[0]);
  xor #(2) (p1, a[1], b[1]);
  xor #(2) (p2, a[2], b[2]);
  xor #(2) (p3, a[3], b[3]);

  and #(2) (g0, a[0], b[0]);
  and #(2) (g1, a[1], b[1]);
  and #(2) (g2, a[2], b[2]);
  and #(2) (g3, a[3], b[3]);


  // --------------------------------------------------
  // Step 2: Carry Lookahead Logic
  // --------------------------------------------------

  // c1 = g0 + p0.cin
  wire c1_pcin;

  and #(2) (c1_pcin, p0, cin);
  or  #(2) (c1, g0, c1_pcin);


  // c2 = g1 + p1.g0 + p1.p0.cin
  wire c2_pg0;
  wire c2_ppcin;

  and #(2) (c2_pg0,   p1, g0);
  and #(2) (c2_ppcin, p1, p0, cin);
  or  #(2) (c2, g1, c2_pg0, c2_ppcin);


  // c3 = g2 + p2.g1 + p2.p1.g0 + p2.p1.p0.cin
  wire c3_pg1;
  wire c3_ppg0;
  wire c3_pppcin;

  and #(2) (c3_pg1,   p2, g1);
  and #(2) (c3_ppg0,  p2, p1, g0);
  and #(2) (c3_pppcin, p2, p1, p0, cin);
  or  #(2) (c3, g2, c3_pg1, c3_ppg0, c3_pppcin);


  // c4 = g3 + p3.g2 + p3.p2.g1
  //      + p3.p2.p1.g0 + p3.p2.p1.p0.cin
  wire c4_pg2;
  wire c4_ppg1;
  wire c4_pppg0;
  wire c4_ppppcin;

  and #(2) (c4_pg2,     p3, g2);
  and #(2) (c4_ppg1,    p3, p2, g1);
  and #(2) (c4_pppg0,   p3, p2, p1, g0);
  and #(2) (c4_ppppcin, p3, p2, p1, p0, cin);

  or #(2) (c4, g3, c4_pg2, c4_ppg1, c4_pppg0, c4_ppppcin);


  // --------------------------------------------------
  // Step 3: Sum
  // sum[0] = p0 ^ cin
  // sum[1] = p1 ^ c1
  // sum[2] = p2 ^ c2
  // sum[3] = p3 ^ c3
  // --------------------------------------------------

  xor #(2) (sum[0], p0, cin);
  xor #(2) (sum[1], p1, c1);
  xor #(2) (sum[2], p2, c2);
  xor #(2) (sum[3], p3, c3);

  // Final carry
  assign #(2) cout = c4;

endmodule