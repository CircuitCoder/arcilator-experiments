#include <iostream>
#include <optional>
#include <random>
#include <vector>

#include "gcd.state.h"

extern "C" void gcd_eval(gcd_state *);

void dump_state(gcd_state &state) {
}

uint16_t gcd_std(uint16_t a, uint16_t b) {
  while(true) {
    uint16_t tmp = b;
    b = a % b;
    a = tmp;

    if(b == 0) return tmp;
  }
}

const size_t TICK_UNTIL = 100000;
std::mt19937 gen(0x19260817);
std::uniform_int_distribution<uint16_t> dist(1, 0xFFFF);

using case_t = std::tuple<uint16_t, uint16_t, uint16_t>;
case_t generate_case() {
  uint16_t a = dist(gen);
  uint16_t b = dist(gen);

  return std::make_tuple(a, b, gcd_std(a, b));
}

int main() {
  gcd_state state;
  size_t tick = 0;

  std::optional<case_t> last;
  case_t testcase = generate_case();

  while(tick < TICK_UNTIL) {
    state.io.i_clk = tick % 2 == 0;
    state.io.i_rst = tick < 10;

    auto &[a, b, r] = testcase;
    state.io.i_in_a = a;
    state.io.i_in_b = b;
    state.io.i_in_valid = tick > 20;

    // o_in_ready doesn't depend on input, so we can skip a eval here
    // fire and is posedge
    if(tick > 20 && state.io.o_in_ready && tick % 2 == 0) {
      // std::cout<<"Accept "<<a<<", "<<b<<std::endl;
      if(last) {
        std::cerr<<"Last gcd not completed"<<std::endl;
        return 1;
      }
      last = testcase;
      testcase = generate_case();
    }

    gcd_eval(&state);

    if(tick >= 15 && tick % 2 == 0 && state.io.o_out_valid) {
      // New output generated
      if(!last) {
        std::cerr<<"Unexpected valid output"<<std::endl;
        return 1;
      }

      auto &[la, lb, lr] = *last;
      std::cout<<la<<", "<<lb<<" -> "<<state.io.o_out<<" # "<<lr<<std::endl;

      if(lr != state.io.o_out) {
        std::cerr<<"Mismatched output"<<std::endl;
        return 1;
      }

      last = {};
    }

    ++tick;
  }
}