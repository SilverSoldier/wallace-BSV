interface CRA#(numeric type n);
  method Bit#(n) sum(Bit#(n)a, Bit#(n) b, Bit#(n) c);
  method Bit#(n) carry(Bit#(n)a, Bit#(n) b, Bit#(n) c);
endinterface
