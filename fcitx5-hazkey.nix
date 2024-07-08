{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  azookey-kkc,
  cmake,
  extra-cmake-modules,
  gettext,
  fcitx5,
  fcitx5-qt,
  qtbase,
  enableQt ? false,
}:
stdenv.mkDerivation rec {
  pname = "fcitx5-hazkey";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "7ka-Hiira";
    repo = "fcitx5-hazkey";
    rev = version;
    hash = "sha256-0vsC/YbWwDHpR2vXZ7hvmctnktWpgg7ITnAZi4LAif8=";
    fetchSubmodules = true;
  };

  sourceRoot = "${src.name}/fcitx5";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
    pkg-config
  ];

  buildInputs =
    [
      fcitx5
      azookey-kkc
    ]
    ++ lib.optionals enableQt [
      fcitx5-qt
      qtbase
    ];

  preBuild = ''
    mkdir -p /build/source/fcitx5/azookey-kkc/.build
    cp -r ${azookey-kkc}/lib /build/source/fcitx5/azookey-kkc/.build/release
    ls -alh /build/source/fcitx5/azookey-kkc/.build/release
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Input method engine for Fcitx5, which uses AzooKeyKanaKanjiConverter as its backend";
    homepage = "https://github.com/7ka-Hiira/fcitx5-hazkey";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
