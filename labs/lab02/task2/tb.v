// tb.v
// Testbench for the parameterized LUT (Task 2).

module tb;

  // inputs and outputs
  reg  [2:0] t_sel;
  wire [7:0] t_dout;

  integer i;
  integer errors;

  // DUT: parameter override (differs from lut.v defaults WIDTH=8, DEPTH=4)
  lut #(.WIDTH(8), .DEPTH(8)) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    for (i = 0; i < 8; i = i + 1) begin
      t_sel = i[2:0];
      #5;
      if (t_dout !== (i*i)) begin
        $display("FAIL at time %0t: sel=%0d  got dout=%0d  expected %0d",
                 $time, t_sel, t_dout, i*i);
        errors = errors + 1;
      end
    end
    $write("SUMMARY: %0d of 8 passed", 8 - errors);
    $display(" (%0d errors)", errors);
    $finish;
  end

  initial
    $monitor($time, " sel=%0d | dout=%0d", t_sel, t_dout);

endmodule
