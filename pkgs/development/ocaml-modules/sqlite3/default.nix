{ lib, fetchurl, sqlite, pkg-config, buildDunePackage, dune-configurator }:

buildDunePackage rec {
  pname = "sqlite3";
  version = "5.1.0";
  useDune2 = true;
  minimumOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/mmottl/sqlite3-ocaml/releases/download/${version}/sqlite3-${version}.tbz";
    sha256 = "sha256-uw23EWkajfok/insTstpEkRK2Q4PTER6+Jgx5tHf/qU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator sqlite ];

  meta = with lib; {
    homepage = "http://mmottl.github.io/sqlite3-ocaml/";
    description = "OCaml bindings to the SQLite 3 database access library";
    license = licenses.mit;
    maintainers = with maintainers; [
      maggesi vbgl
    ];
  };
}
