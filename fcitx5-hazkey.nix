{
  lib,
  stdenv,
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
  hazkey-src,
  swiftpm2nix,
  enableQt ? false,
}:
stdenv.mkDerivation {
  pname = "fcitx5-hazkey";
  version = "dev-" + hazkey-src.lastModifiedDate;

  src = hazkey-src;

  HOME = '''$TMPDIR'';

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

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT" enableQt)
    (lib.cmakeBool "USE_QT6" (lib.versions.major qtbase.version == "6"))
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Input method engine for Fcitx5, which uses AzooKeyKanaKanjiConverter as its backend";
    homepage = "https://github.com/7ka-Hiira/fcitx5-hazkey";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
