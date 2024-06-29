{
  stdenv,
  autoPatchelfHook,
  clang,
  curl,
  python311,
  libcxx,
  libedit,
  libgcc,
  libuuid,
  libxml2,
  ncurses,
  sqlite,
}:
stdenv.mkDerivation {
  pname = "swift";
  version = "5.10.1";

  src = builtins.fetchTarball {
    url = "https://download.swift.org/swift-5.10.1-release/debian12/swift-5.10.1-RELEASE/swift-5.10.1-RELEASE-debian12.tar.gz";
    sha256 = "18kg741vvwc5w2yckhfpsnqwp4c30yiz6nzbbgqdg50zmiwr9gm4";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  propagatedBuildInputs = [
    clang
    curl
    python311
    libedit
    libcxx
    libgcc
    libuuid
    libxml2
    ncurses
    sqlite
  ];

  buildPhase = ''
    cp -r $src/usr $out
  '';
}
