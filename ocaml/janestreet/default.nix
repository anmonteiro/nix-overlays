{ ocamlPackages, openssl, fetchpatch, zstd }:

with ocamlPackages;

{
  async_ssl = janePackage {
    pname = "async_ssl";
    hash = "0ykys3ckpsx5crfgj26v2q3gy6wf684aq0bfb4q8p92ivwznvlzy";
    meta.description = "Async wrappers for SSL";
    buildInputs = [ dune-configurator ];
    propagatedBuildInputs = [ async ctypes-0_17 openssl ];
  };

  base_quickcheck = (janePackage {
    pname = "base_quickcheck";
    hash = "1lmp1h68g0gqiw8m6gqcbrp0fn76nsrlsqrwxp20d7jhh0693f3j";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Randomized testing framework, designed for compatibility with Base";
    propagatedBuildInputs = [ ppx_base ppx_fields_conv ppx_let ppx_sexp_value splittable_random ];
  }).overrideAttrs (_: {
    src = builtins.fetchurl {
      url = https://github.com/janestreet/base_quickcheck/archive/v0.14.1.tar.gz;
      sha256 = "0n5h0ysn593awvz4crkvzf5r800hd1c55bx9mm9vbqs906zii6mn";
    };
  });

  core = (janePackage {
    pname = "core";
    hash = "1m9h73pk9590m8ngs1yf4xrw61maiqmi9glmlrl12qhi0wcja5f3";
    meta.description = "System-independent part of Core";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [ core_kernel spawn timezone ];
    doCheck = false; # we don't have quickcheck_deprecated
  }).overrideAttrs (o: {
    src = builtins.fetchurl {
      url = https://github.com/janestreet/core/archive/596b31f37c30acc5ca8e8c1029dbc753d473bc31.tar.gz;
      sha256 = "1k0l9q1k9j5ccc2x40w2627ykzldyy8ysx3mmkh11rijgjjk3fsf";
    };
  });

  core_kernel = (janePackage {
    pname = "core_kernel";
    hash = "012sp02v35j41lzkvf073620602fgiswz2n224j06mk3bm8jmjms";
    meta.description = "System-independent part of Core";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [ base_bigstring sexplib ];
    doCheck = false; # we don't have quickcheck_deprecated
  }).overrideAttrs (o: {
    src = builtins.fetchurl {
      url = https://github.com/janestreet/core_kernel/archive/v0.14.1.tar.gz;
      sha256 = "0f24sagyzhfr6x68fynhsn5cd1p72vkqm25wnfg8164sivas148x";
    };
  });

  parsexp = janePackage {
    pname = "parsexp";
    hash = "0rvbrf8ggh2imsbhqi15jzyyqbi3m5hzvy2iy2r4skx6m102mzpd";
    minimumOCamlVersion = "4.04.2";
    meta.description = "S-expression parsing library";
    propagatedBuildInputs = [ base sexplib0 ];

    patches = [ ./parsexp.patch ];
  };

  ppx_custom_printf = (janePackage {
    pname = "ppx_custom_printf";
    hash = "0p9hgx0krxqw8hlzfv2bg2m3zi5nxsnzhyp0fj5936rapad02hc5";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Printf-style format-strings for user-defined string conversion";
    propagatedBuildInputs = [ ppx_sexp_conv ];
  }).overrideAttrs (o: {
    src = builtins.fetchurl {
      url = https://github.com/janestreet/ppx_custom_printf/archive/d415134eb9851e0e52357046f2ed642dfc398ba3.tar.gz;
      sha256 = "1ydfpb6aqgj03njxlicydbd9hf8shlqjr2i6yknzsvmwqxpy5qci";
    };
  });

  ppx_expect = (janePackage {
    pname = "ppx_expect";
    hash = "05v6jzn1nbmwk3vzxxnb3380wzg2nb28jpb3v5m5c4ikn0jrhcwn";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Cram like framework for OCaml";
    propagatedBuildInputs = [ ppx_here ppx_inline_test re stdio ];
    doCheck = false; # circular dependency with ppx_jane
  }).overrideAttrs (o: {
    src = builtins.fetchurl {
      url = https://github.com/janestreet/ppx_expect/archive/7f46c2d22a87b99c70a220c1b13aaa34c6d217ff.tar.gz;
      sha256 = "0vkrmcf1s07qc1l7apbdr8y28x77s8shbsyb6jzwjkx3flyahqmh";
    };
  });

  ppx_optcomp = (janePackage {
    pname = "ppx_optcomp";
    hash = "1wav3zgh4244x1ll562g735cwwrzyk5jj72niq9jgz9qjlpsprlk";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Optional compilation for OCaml";
    propagatedBuildInputs = [ ppxlib stdio ];
  }).overrideAttrs (o: {
    src = builtins.fetchurl {
      url = https://github.com/janestreet/ppx_optcomp/archive/a4422ecd7e0677569533b1dae07924f5d786e8f6.tar.gz;
      sha256 = "1szyb7hjln28dak2hb97hgnax64agwv9hy066l42mmgjxijghzlg";
    };
  });

  ppx_sexp_conv = (janePackage {
    pname = "ppx_sexp_conv";
    version = "0.14.1";
    minimumOCamlVersion = "4.04.2";
    hash = "04bx5id99clrgvkg122nx03zig1m7igg75piphhyx04w33shgkz2";
    meta.description = "[@@deriving] plugin to generate S-expression conversion functions";
    propagatedBuildInputs = [ ppxlib sexplib0 base ];
  }).overrideAttrs (o: {
    src = builtins.fetchurl {
      url = https://github.com/janestreet/ppx_sexp_conv/archive/291fd9b59d19e29702e0e3170559250c1f382e42.tar.gz;
      sha256 = "003mzsjy3abqv72rmfnlrjbk24mvl1ck7qz58b8a3xpmgyxz1kq1";
    };
  });

  ppx_sexp_message = (janePackage {
    pname = "ppx_sexp_message";
    hash = "17xnq345xwfkl9ydn05ljsg37m2glh3alnspayl3fgbhmcjmav3i";
    minimumOCamlVersion = "4.04.2";
    meta.description = "A ppx rewriter for easy construction of s-expressions";
    propagatedBuildInputs = [ ppx_here ppx_sexp_conv ];
  }).overrideAttrs (o: {
    src = builtins.fetchurl {
      url = https://github.com/janestreet/ppx_sexp_message/archive/fd604b269398aebdb0c5fa5511d9f3c38b6ecb45.tar.gz;
      sha256 = "1izfs9a12m2fc3vaz6yxgj1f5hl5xw0hx2qs55cbai5sa1irm8lg";
    };
  });

  ppx_typerep_conv = (janePackage {
    pname = "ppx_typerep_conv";
    version = "0.14.1";
    minimumOCamlVersion = "4.04.2";
    hash = "1r0z7qlcpaicas5hkymy2q0gi207814wlay4hys7pl5asd59wcdh";
    meta.description = "Generation of runtime types from type declarations";
    propagatedBuildInputs = [ ppxlib typerep ];
  }).overrideAttrs (_: {
    src = builtins.fetchurl
      {
        url = https://github.com/janestreet/ppx_typerep_conv/archive/v0.14.2.tar.gz;
        sha256 = "1g1sb3prscpa7jwnk08f50idcgyiiv0b9amkl0kymj5cghkdqw0n";
      };
  });


}
