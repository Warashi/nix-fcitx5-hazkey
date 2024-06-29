{
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "swift";
  version = "5.10.1";

  src = builtins.fetchTarball {
    url = "https://download.swift.org/swift-5.10.1-release/debian12/swift-5.10.1-RELEASE/swift-5.10.1-RELEASE-debian12.tar.gz";
    sha256 = "1a04mbflx17w6q9jzxasfk81z5iagkdh6jqjl5g900p021f2i9m9";
  };

  installPhase = ''
    cp -r $src $out
  '';

  meta = with lib; {
    description = "Input method engine for Fcitx5, which uses AzooKeyKanaKanjiConverter as its backend";
    homepage = "https://github.com/7ka-Hiira/fcitx5-hazkey";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
