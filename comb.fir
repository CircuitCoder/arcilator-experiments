FIRRTL version 2.0.0
circuit comb :
  module comb :
    input a : UInt<64>
    input b : UInt<64>
    output out_xor : UInt<64>
    output out_and : UInt<64>
    output out_or : UInt<64>

    out_xor <= xor(a, b)
    out_and <= and(a, b)
    out_or <= or(a, b)