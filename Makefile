MAKEFLAGS += --no-builtin-rules

.SUFFIXES:

FIRS=$(wildcard *.fir)
MLIRS=$(subst .fir,.mlir,$(FIRS))
VS=$(subst .fir,.v,$(FIRS))
LLS=$(subst .fir,.ll,$(FIRS))
STATES=$(subst .fir,.state.json,$(FIRS))
STATE_HS=$(subst .fir,.state.h,$(FIRS))
SS=$(subst .fir,.S,$(FIRS))

all: $(MLIRS) $(VS) $(LLS)

clean:
	rm -f $(MLIRS) $(VS) $(LLS) $(STATES) $(STATE_HS) $(SS)

%.mlir: %.fir
	firtool -o $@ --ir-hw $<

%.ll: %.mlir
	arcilator -o $@ --state-file=$(subst .mlir,.state.json,$<) $<

%.S: %.ll
	llc -o $@ $<

%.v: %.fir
	firtool -o $@ --verilog $<

%.state.h: %.ll
	node ./scripts/generate-header.js $(subst .ll,.state.json,$<) > $@

gcd: gcd.S gcd.driver.cpp gcd.state.h
	clang++ -o $@ $@.S $@.driver.cpp
