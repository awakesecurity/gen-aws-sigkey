{ mkDerivation, aeson, base, bytestring, cryptonite, lens, memory
, old-locale, optparse-generic, stdenv, tasty, tasty-golden
, tasty-hunit, tasty-quickcheck, text, thyme
}:
mkDerivation {
  pname = "gen-aws-sigkey";
  version = "1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base bytestring cryptonite memory old-locale optparse-generic
    text thyme
  ];
  executableHaskellDepends = [
    aeson base bytestring lens optparse-generic text thyme
  ];
  testHaskellDepends = [
    base old-locale tasty tasty-golden tasty-hunit tasty-quickcheck
    text thyme
  ];
  homepage = "https://github.com/awakenetworks/gen-aws-sigkey";
  description = "Scoped signing keygen";
  license = stdenv.lib.licenses.asl20;
}
