import CLA::*;

module mkTbCLA ();
  CLAn cla <- mkCLAn();
  Reg#(Bool) start <- mkReg(False);

  rule startTest(start == False);
  	Bit#(8) a = 8'b00001111;
  	Bit#(8) b = 8'b00000001;
  	cla.add(a, b);
  	start <= True;
  endrule

  rule endTest(start == True);
  	let x = cla.getSum();
  	$display("%b", x);
  	$finish(0);
  endrule

endmodule

