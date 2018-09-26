import RecDoub::*;

module mkTbRecDoub ();
  RecDoub rdb <- mkRD();
  Reg#(Bool) start <- mkReg(False);

  rule startTest(start == False);
  	Bit#(8) a = 8'b11101111;
  	$display("Recursive and of %b", a);
  	rdb.prefixSum(a);
  	start <= True;
  endrule

  rule endTest(start == True);
  	let x = rdb.getSum();
  	$display("%b", x);
  	$finish(0);
  endrule

endmodule
