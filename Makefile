FIRS=$(wildcard *.fir)
MLIRS=$(subst .fir,.mlir,$(FIRS))
VS=$(subst .fir,.v,$(FIRS))

all: $(MLIRS) $(VS)

clean:
	rm -f $(MLIRS) $(VS)

%.mlir: %.fir
	firtool -o $@ --ir-hw $< 

%.v: %.fir
	firtool -o $@ --verilog $< 