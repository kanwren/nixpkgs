{ stdenv, lib, callPackage, fetchurl, isInsiders ? false }:

let
  inherit (stdenv.hostPlatform) system;

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
    armv7l-linux = "linux-armhf";
  }.${system};

  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "049spg4c1arkw97mg0h046kiirmcrjj97sy4ldiblwldjn510acw";
    x86_64-darwin = "0g6b1891ag4a6p7rlkfka5v4nbmpr4ckkmibhw8l3wa9zdzs77x6";
    aarch64-linux = "1qvk6cn5v9bz4vl5ifpdgrba94v6a54xx8s3fxdkj3lqvq27kpd1";
    aarch64-darwin = "1whgjkxy70ifx1vaddxr8f1xcg651fhca4x7rzidzbyyf3baghy0";
    armv7l-linux = "1k45s81s4ispc0vz7i17a7gss05d82vpymxgangg6f1yxwz944r4";
    x86_64-linux_insiders = "0ayfqr4sa7dk48322b5ywvvxhhfisbadampzb66f9cqrcd621b96";
    x86_64-darwin_insiders = "06fwbrdy9yv9viag2kmcf9ny2bv6g9ndng0zm82k5x7akslns396";
    aarch64-linux_insiders = "1iprpwdr8xsndxz3xcjcddl5a7yibrxg7f230y8r9pgg3z4nqmsh";
    aarch64-darwin_insiders = "06cm5a7ib6llnwa1s6fgmwvnbc01bqx7z408rqq338lg9s2r45yr";
    armv7l-linux_insiders = "1v7gaqmyc7qdp66hx2f37f0dh17xpxiaafszkvvfn0fp9y2b1y64";
  }.${if isInsiders then "${system}_insiders" else system};
in
  callPackage ./generic.nix rec {
    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.58.2";
    pname = "vscode";

    executableName = "code" + lib.optionalString isInsiders "-insiders";
    longName = "Visual Studio Code" + lib.optionalString isInsiders " - Insiders";
    shortName = "Code" + lib.optionalString isInsiders " - Insiders";

    src =
      if isInsiders then
        fetchurl {
          name = "VSCode_insider_${plat}.${archive_fmt}";
          url = "https://code.visualstudio.com/sha/download?build=insider&os=${plat}";
          inherit sha256;
        }
      else
        fetchurl {
          name = "VSCode_${version}_${plat}.${archive_fmt}";
          url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
          inherit sha256;
        };

    sourceRoot = "";

    updateScript = ./update-vscode.sh;

    meta = with lib; {
      description = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS
      '';
      mainProgram = "code";
      longDescription = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS. It includes support for debugging, embedded Git
        control, syntax highlighting, intelligent code completion, snippets,
        and code refactoring. It is also customizable, so users can change the
        editor's theme, keyboard shortcuts, and preferences
      '';
      homepage = "https://code.visualstudio.com/";
      downloadPage = "https://code.visualstudio.com/Updates";
      license = licenses.unfree;
      maintainers = with maintainers; [ eadwu synthetica maxeaubrey ];
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" "armv7l-linux" ];
    };
  }
