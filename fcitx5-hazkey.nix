{
  stdenv,
  autoPatchelfHook,
  libcxx,
  fcitx5,
  mesa,
  vulkan-loader,
}:
stdenv.mkDerivation {
  name = "fcitx5-hazkey";
  version = "0.0.4";

  src = builtins.fetchTarball {
    url = "https://github.com/7ka-Hiira/fcitx5-hazkey/releases/download/0.0.4/fcitx5-hazkey-0.0.4-x86_64.tar.gz";
    sha256 = "1a04mbflx17w6q9jzxasfk81z5iagkdh6jqjl5g900p021f2i9m9";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libcxx
    fcitx5
    mesa
    vulkan-loader
  ];

  buildPhase = ''
    cp -r --no-preserve=mode $src/usr $TMPDIR/
    mv $TMPDIR/usr/lib/x86_64-linux-gnu/* $TMPDIR/usr/lib/
    rmdir $TMPDIR/usr/lib/x86_64-linux-gnu
    cp -r --no-preserve=mode $TMPDIR/usr $out
  '';
}
