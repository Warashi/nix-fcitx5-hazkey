{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  extra-cmake-modules,
  gettext,
  fcitx5,
  fcitx5-qt,
  qtbase,
  swift,
  glslang,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  vulkan-tools,
  swiftpm2nix,
  enableQt ? false,
}:
stdenv.mkDerivation rec {
  pname = "fcitx5-hazkey";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "7ka-Hiira";
    repo = "fcitx5-hazkey";
    rev = version;
    hash = "sha256-75GRS03CQvYzAtumeL4Exi3puSKjtwrmHCqBBgklaLg=";
  };

  nativeBuildInputs = [
    swift
    cmake
    extra-cmake-modules
    gettext
    pkg-config
  ];

  configurePhase = (swiftpm2nix.helpers ./azookey-kkc).configure;

  buildInputs =
    [
      fcitx5
      glslang
      shaderc
      vulkan-headers
      vulkan-loader
      vulkan-tools
    ]
    ++ lib.optionals enableQt [
      fcitx5-qt
      qtbase
    ];

  buildPhase = ''
    set -e
    export HOME=$(mktemp -d)
    cd $(mktemp -d)
    cp -r --no-preserve=mode $src ./src
    pwd
    mkdir ./src/build && cd ./src/build
    cmake -DCMAKE_INSTALL_PREFIX=$out .. || cmake -DCMAKE_INSTALL_PREFIX=$out .. # do twice
    make install
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Input method engine for Fcitx5, which uses AzooKeyKanaKanjiConverter as its backend";
    homepage = "https://github.com/7ka-Hiira/fcitx5-hazkey";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
