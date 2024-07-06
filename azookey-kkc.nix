{
  lib,
  stdenv,
  fetchFromGitHub,
  swift,
  swiftpm,
  glslang,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  vulkan-tools,
  swiftpm2nix,
}:
stdenv.mkDerivation rec {
  pname = "azookey-kkc";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "7ka-Hiira";
    repo = "fcitx5-hazkey";
    rev = version;
    hash = "sha256-75GRS03CQvYzAtumeL4Exi3puSKjtwrmHCqBBgklaLg=";
  };

  sourceRoot = "${src.name}/azookey-kkc";

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  configurePhase = (swiftpm2nix.helpers ./azookey-kkc).configure;

  buildInputs = [
    glslang
    shaderc
    vulkan-headers
    vulkan-loader
    vulkan-tools
  ];

  buildPhase = builtins.readFile ./azookey-kkc-build.sh;

  installPhase =
    (builtins.readFile ./swiftpm-bin-path.sh)
    + ''
      # This is a special function that invokes swiftpm to find the location
      # of the binaries it produced.
      binPath="$(swiftpmBinPath)"

      # Now perform any installation steps.
      mkdir -p $out/lib
      cp $binPath/libhazkey.so $out/lib/
    '';

  meta = with lib; {
    description = "Input method engine for Fcitx5, which uses AzooKeyKanaKanjiConverter as its backend";
    homepage = "https://github.com/7ka-Hiira/fcitx5-hazkey";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
