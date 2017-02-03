{ allowUnfree = true;
  packageOverrides = pkgs: {
    haskellPackages = pkgs.haskellPackages.override {
      overrides = haskellPackagesNew: haskellPackagesOld: {
        optparse-applicative =
          pkgs.haskell.lib.dontCheck
            (haskellPackagesNew.callPackage ./nix/optparse-applicative.nix { });

        optparse-generic =
          haskellPackagesNew.callPackage ./nix/optparse-generic.nix { };

        gen-aws-sigkey = haskellPackagesNew.callPackage ./default.nix { };
      };
    };
  };
}
