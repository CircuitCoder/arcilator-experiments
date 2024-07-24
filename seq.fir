FIRRTL version 2.0.0
circuit seq :
  module seq :
    input clk : Clock
    input rst : UInt<1>
    output cnt : UInt<64>
    output carry : UInt<1>

    reg state : UInt<64>, clk with :
      reset => (rst, UInt<64>("h0"))
    state <= add(state, UInt<1>("h1"))
    carry <= eq(state, not(UInt<64>("h0")))
    cnt <= state