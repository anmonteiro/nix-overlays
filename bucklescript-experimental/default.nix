{ stdenv, opaline, ocamlPackages, lib, dune_2, nodejs, gnutar, fetchFromGitHub }:

with ocamlPackages;
let
  bin_folder = if stdenv.isDarwin then "darwin" else "linux";
in
stdenv.mkDerivation rec {
  name = "bucklescript";
  version = "8.3.0-dune";

  src = fetchFromGitHub {
    owner = "anmonteiro";
    repo = "bucklescript";
    rev = "de286f346";
    sha256 = "00piz4smzrppg5bvbigpj347qhsl7ib46l9js64fcazhyihx5l7m";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gnutar
    nodejs
    dune_2
    ocaml
    findlib
    cppo
  ];

  propagatedBuildInputs = [
    reason
    camlp4
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    dune build -p ${name} --display=short
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${opaline}/bin/opaline -prefix $out -libdir $OCAMLFIND_DESTDIR

    cp package.json bsconfig.json $out
    cp -r ./_build/default/lib/es6 ./_build/default/lib/js $out/lib

    mkdir -p $out/lib/ocaml
    tar -C $out/lib/ocaml -xzf $out/share/bucklescript/libocaml.tar.gz --strip-components=1

    runHook postInstall
  '';
}
