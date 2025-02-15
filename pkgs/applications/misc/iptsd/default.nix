{ lib
, stdenv
, fetchFromGitHub
, cmake
, meson
, ninja
, pkg-config
, cli11
, hidrd
, inih
, microsoft_gsl
, spdlog
, systemd
}:

stdenv.mkDerivation rec {
  pname = "iptsd";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "linux-surface";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fd/WZXRvJb6XCATNmPj2xi1UseoZqBT9IN21iwxHGLs=";
  };

  nativeBuildInputs = [
    cmake
    meson
    ninja
    pkg-config
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    cli11
    hidrd
    inih
    microsoft_gsl
    spdlog
    systemd
  ];

  # Original installs udev rules and service config into global paths
  postPatch = ''
    substituteInPlace etc/meson.build \
      --replace "install_dir: unitdir" "install_dir: datadir" \
      --replace "install_dir: rulesdir" "install_dir: datadir" \
  '';

  mesonFlags = [
    "-Dservice_manager=systemd"
    "-Dsample_config=false"
    "-Ddebug_tools="
    "-Db_lto=false"  # plugin needed to handle lto object -> undefined reference to ...
  ];

  meta = with lib; {
    changelog = "https://github.com/linux-surface/iptsd/releases/tag/${src.rev}";
    description = "Userspace daemon for Intel Precise Touch & Stylus";
    homepage = "https://github.com/linux-surface/iptsd";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ tomberek dotlambda ];
    platforms = platforms.linux;
  };
}
