FIRRTL version 2.0.0
circuit pingpong :
  module pingpong :
    input clk : Clock
    input rst : UInt<1>

    inst shifter_l of shifter
    inst shifter_r of shifter

    shifter_l.rst <= rst
    shifter_l.clk <= clk
    shifter_r.rst <= rst
    shifter_r.clk <= clk

    shifter_l.in <= shifter_r.out
    shifter_r.in <= shifter_l.out

  module shifter :
    input clk : Clock
    input rst : UInt<1>

    input in : UInt<1>
    output out : UInt<1>

    reg inner : UInt<65536>, clk with :
      reset => (rst, UInt<65536>("b1"))
    
    out <= bits(inner, 0, 0)
    inner <= bits(cat(in, inner), 65536, 1)