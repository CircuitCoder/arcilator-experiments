FIRS=$(wildcard *.fir)
MLIRS=$(subst .fir,.mlir,$(FIRS))
VS=$(subst .fir,.v,$(FIRS))
LLS=$(subst .fir,.ll,$(FIRS))
SS=$(subst .fir,.S,$(FIRS))

all: $(MLIRS) $(VS) $(LLS) $(SS)

clean:
	rm -f $(MLIRS) $(VS)

%.mlir: %.fir
	firtool -o $@ --ir-hw $<

%.ll: %.mlir
	arcilator -o $@ $<

%.S: %.ll
	llc -o $@ $<

%.v: %.fir
	firtool -o $@ --verilog $<