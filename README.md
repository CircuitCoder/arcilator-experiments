# Arcilator Experiments

Random silly experiments with arcilator.

Tested with CIRCT 1.77.0 distributed by nixpkgs-unstable.

```bash
git submodule update --init --recursive
nix-env -iA "nixpkgs.circt"
make gcd
./gcd
```
