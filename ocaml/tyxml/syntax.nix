{ ocamlPackages, lib }:

with ocamlPackages;

buildDunePackage {
  pname = "tyxml-syntax";
  inherit (tyxml) src version;

  propagatedBuildInputs = [ ppxlib uutf re ];

  checkInputs = [
    alcotest
  ];

  doCheck = true;

  meta = {
    description = "Common layer for the JSX and PPX syntaxes for Tyxml";
    license = lib.licenses.lgpl21;
  };
}
