let config = import ./config.nix;
in
{ pkgs ? import <nixpkgs> { inherit config; } }:
let
  darwinPkgs = import <nixpkgs> { inherit config; system = "x86_64-darwin"; };
  linuxPkgs  = import <nixpkgs> { inherit config; system = "x86_64-linux" ; };
  pkgs       = import <nixpkgs> { inherit config; };

in
  { gen-aws-sigkey-linux  =  linuxPkgs.haskellPackages.gen-aws-sigkey;
    gen-aws-sigkey-darwin = darwinPkgs.haskellPackages.gen-aws-sigkey;
    gen-aws-sigkey        =       pkgs.haskellPackages.gen-aws-sigkey;
  }
