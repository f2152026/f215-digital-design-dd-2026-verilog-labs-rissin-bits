// tb.v
// Self-checking testbench for alu.v (Task 5).

module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  reg  [3:0] exp;
  integer    i, j;
  integer    errors, checks;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  // one check: apply, settle, compare against an independently computed value
  task check;
    input [3:0] a_in;
    input [3:0] b_in;
    input       op_in;
    begin
      t_a = a_in; t_b = b_in; t_op = op_in;
      #5;
      exp = op_in ? (a_in - b_in) : (a_in + b_in);
      checks = checks + 1;
      if (t_result !== exp) begin
        $display("FAIL at time %0t: a=%0d b=%0d op=%b  got result=%0d  expected %0d",
                 $time, a_in, b_in, op_in, t_result, exp);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;
    checks = 0;

    // same operand pair, op toggled (exposes the sensitivity-list bug)
    check(4'd9, 4'd5, 1'b0);
    check(4'd9, 4'd5, 1'b1);
    check(4'd9, 4'd5, 1'b0);

    // operands changing, both operations
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        check(i[3:0], j[3:0], 1'b0);
        check(i[3:0], j[3:0], 1'b1);
      end
    end

    $write("SUMMARY: %0d of %0d passed", checks - errors, checks);
    $display(" (%0d failed)", errors);
    $finish;
  end

endmodule
