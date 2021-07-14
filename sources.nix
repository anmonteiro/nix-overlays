args@{ overlays ? [ (import ./.) ], ... }:

# `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-unstable`

import
  (builtins.fetchTarball {
    name = "nixos-unstable-2021-07-15";
    url = https://github.com/nixos/nixpkgs/archive/dac74fead873.tar.gz;
    sha256 = "0m0bqkh4bmlg5djb9bmyrpa1s4kwy2klil36487vyqkbdxnl76f7";
  })
  (args // { inherit overlays; })
