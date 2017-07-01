{ mkDerivation, aeson, base, bytestring, cryptonite, ini, lens
, memory, neat-interpolation, old-locale, optparse-generic, stdenv
, tasty, tasty-golden, tasty-hunit, tasty-quickcheck, text, thyme
, turtle
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
    aeson base bytestring ini lens neat-interpolation optparse-generic
    text thyme turtle
  ];
  testHaskellDepends = [
    base old-locale tasty tasty-golden tasty-hunit tasty-quickcheck
    text thyme
  ];
  homepage = "https://github.com/awakenetworks/gen-aws-sigkey";
  description = "Scoped signing keygen";
  license = stdenv.lib.licenses.asl20;
}
