{
  pkgs,
  system,
  stdenv,
  ...
}: {
  pname ? "record-duckdb-extension",
  version ? "0.6.38",
  shas ? {
    aarch64-darwin = "15wqxy577kgfyn6amm0jrkm034zg8di4ynk4k9mz7x6jq9k294x8";
    x86_64-darwin = "07rh67s51nyawmvyq9pbsqxfg04gznx43jxisiiii117w852j2bi";
    aarch64-linux = "087418lm1hbknafh3hs3q9s2pnmjkm4pdi0nm5k17xhlnl7i80d2";
    x86_64-linux = "0960a8x6xal0xv4wm89f6mcxg59sf35vj257yp0wg3c28b71cpkx";
  },
}: let
  os =
    if stdenv.isDarwin
    then "Darwin"
    else "Linux";
  arch =
    if pkgs.lib.hasInfix "aarch64" system
    then "arm64"
    else "x86_64";
  file = "flytectl_${os}_${arch}.tar.gz";
in
  stdenv.mkDerivation {
    pname = pname;
    version = version;
    src = pkgs.fetchzip {
      url = "https://github.com/flyteorg/flytectl/releases/download/v${version}/${file}";
      sha256 = shas.${system};
      stripRoot = false;
    };

    installPhase = "mkdir -p $out/bin; cp flytectl $out/bin";

    checkPhase = ''
      flytectl version | grep ${version}
    '';
  }
