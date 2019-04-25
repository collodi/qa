with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "QA";

  buildInputs = [ elmPackages.elm yarn nodejs ];

  env = buildEnv { name = name; paths = buildInputs; };
}
