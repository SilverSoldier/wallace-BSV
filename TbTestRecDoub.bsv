import RecDoub::*;

module mkTbRecDoub ();
  RecDoub rdb <- mkRD();
  Reg#(Bool) running <- mkReg(False);

  rule startTest(running == False);
  	Bit#(8) a = 8'b11101111;
  	$display("Recursive and of %b", a);
  endrule
endmodule
