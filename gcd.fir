FIRRTL version 2.0.0
circuit gcd :
  module gcd :
    input clk : Clock
    input rst : UInt<1>
    input in_a : UInt<64>
    input in_b : UInt<64>
    input in_valid : UInt<1>
    output in_ready : UInt<1>

    output out : UInt<64>
    output out_valid : UInt<64>

    reg smaller : UInt<64>, clk
    reg larger : UInt<64>, clk
    reg working : UInt<1>, clk with :
      reset => (rst, UInt<1>("h0"))

    node done = and(eq(smaller, UInt<64>("h0")), working)

    node na = mux(working, sub(larger, smaller), in_a)
    node nb = mux(working, smaller, in_b)

    node nlarger = mux(gt(na, nb), na, nb)
    node nsmaller = mux(gt(na, nb), nb, na)

    node nworking = mux(working, not(done), in_valid)

    out <= larger
    out_valid <= done
    in_ready <= not(working)

    working <= nworking
    larger <= nlarger
    smaller <= nsmaller