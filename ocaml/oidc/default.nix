{ ocamlPackages, lib }:

with ocamlPackages;
let src = builtins.fetchurl {
  url = https://github.com/ulrikstrid/ocaml-oidc/archive/v0.1.1.tar.gz;
  sha256 = "1k729n94zx5qjc701s41dn4bjyqxznzbrwck713rni4w3yzparys";
};

in
{
  oidc = ocamlPackages.buildDunePackage {
    pname = "oidc";
    version = "0.1.1";
    inherit src;

    propagatedBuildInputs = with ocamlPackages; [
      jose
      uri
      yojson
      logs
      logs
    ];

    meta = {
      description = "Base functions and types to work with OpenID Connect.";
      license = lib.licenses.bsd3;
    };
  };

  oidc-client = ocamlPackages.buildDunePackage {
    pname = "oidc-client";
    version = "1.0.0";
    inherit src;

    propagatedBuildInputs = with ocamlPackages; [
      oidc
      jose
      uri
      yojson
      logs
      piaf
    ];

    meta = {
      description = "OpenID Connect Relaying Party implementation built ontop of Piaf.";
      license = lib.licenses.bsd3;
    };
  };
}
