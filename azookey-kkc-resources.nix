{
  lib,
  stdenv,
  fetchFromGitHub,
}: let
  zenzai = builtins.fetchurl {
    name = "zenzai";
    url = "https://huggingface.co/Miwa-Keita/zenz-v1/resolve/main/ggml-model-Q8_0.gguf";
    sha256 = "057xcm9cxxa527gm57h7xsy54fkyxwfpbn5raphjig907qh6h771";
  };
in
  stdenv.mkDerivation rec {
    pname = "azookey-kkc-dictionary";
    version = "0.0.6";

    src = fetchFromGitHub {
      owner = "7ka-Hiira";
      repo = "fcitx5-hazkey";
      rev = version;
      hash = "sha256-0vsC/YbWwDHpR2vXZ7hvmctnktWpgg7ITnAZi4LAif8=";
      fetchSubmodules = true;
    };

    installPhase = ''
      mkdir -p $out/share/hazkey
      cp -r $src/azooKey_dictionary_storage/Dictionary $out/share/hazkey/Dictionary
      cp -r ${zenzai} $out/share/hazkey/ggml-model-Q8_0.gguf
    '';

    meta = with lib; {
      description = "Input method engine for Fcitx5, which uses AzooKeyKanaKanjiConverter as its backend";
      homepage = "https://github.com/7ka-Hiira/fcitx5-hazkey";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  }
