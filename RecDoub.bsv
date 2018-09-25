interface RecDoub;
  method Action prefixSum(Bit#(8) a);
  method Bit#(1) getSum();
endinterface

module mkRD (RecDoub);
  Reg#(Bit#(8)) x <- mkReg(0);
  Reg#(Bool) running <- mkReg(False);
  Reg#(Maybe#(int)) next[8];

  rule init(running == False);
  	running <= True;
  	next[0] <= tagged Invalid;
  	for (Int#(32) i = 1; i < 8; i = i+1) begin
  	  let temp = i - 1;
  	  next[i] <= tagged Valid temp;
  	end
  endrule

  method Action prefixSum(Bit#(8) a);
  	x <= a;
  endmethod

  method Bit#(1) getSum();
  	return x[0];
  endmethod
endmodule
