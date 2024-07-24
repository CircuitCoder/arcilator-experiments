FIRS=$(wildcard *.fir)
MLIRS=$(subst .fir,.mlir,$(FIRS))
VS=$(subst .fir,.v,$(FIRS))
LLS=$(subst .fir,.ll,$(FIRS))

all: $(MLIRS) $(VS) $(LLS)

clean:
	rm -f $(MLIRS) $(VS)

%.mlir: %.fir
	firtool -o $@ --ir-hw $< 

%.ll: %.mlir
	arcilator -o $@ $< 

%.v: %.fir
	firtool -o $@ --verilog $< 