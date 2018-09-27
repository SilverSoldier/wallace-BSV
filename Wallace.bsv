import CLA::*;
import Vector::*;
import CRA::*;
`define n 8

`define res 15

module mkCRA(CRA#(n));
  method Bit#(n) sum(Bit#(n) a, Bit#(n) b, Bit#(n) c);
  	return a & b | b & c | c & a;
  endmethod

  method Bit#(n) carry(Bit#(n) a, Bit#(n) b, Bit#(n) c);
  	return a ^ b ^ c;
  endmethod
endmodule

module mkWallaceN();
  // n-partial products - each a 2n-1 bit no.
  Vector#(`n, Reg#(Bit#(`res))) partial_products <- replicateM(mkReg(0));
  Bit#(`n) a = 8'b00001111;
  Bit#(`n) b = 8'b00000001;
  Reg#(Bool) start <- mkReg(True);
  CRA#(`res) cra <- mkCRA();

  rule init(start == True);
  	for(Int#(32) i = 0; i < `n; i = i+1) begin
  	  if(b[i] == 1)
  	  	partial_products[i] <= extend(a);
  	end
  	start <= False;
  endrule

  rule add_partial_products(start == False);
  	for(Integer i = 0; i < `n; i = i+3) begin
  	  if(i < `n - 2) begin
  	  	let temp1 = cra.sum(partial_products[i], partial_products[i+1], partial_products[i+2]);
  	  	let temp2 = cra.carry(partial_products[i], partial_products[i+1], partial_products[i+2]);

  	  	Integer loc = 2 * div(i, 3);

  	  	partial_products[loc] <= temp1;
  	  	partial_products[loc+1] <= temp2;
  	  end
  	  else begin
  	  	Integer loc = div(i, 3) * 2 + mod(i, 3);
  	  	partial_products[loc] <= partial_products[i];
  	  end
  	end
  endrule

endmodule
