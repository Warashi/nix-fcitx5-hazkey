{
  llvmPackages_15,
  stdenv ? llvmPackages_15.stdenv,
  autoPatchelfHook,
  buildFHSEnv,
  libz,
  libuuid,
  libxml2,
  ncurses,
  sqlite,
  curl,
  python3,
  libedit,
  glibc,
}: let
  pname = "swift";
  version = "5.10.1";
  swift-unwrapped = stdenv.mkDerivation {
    inherit pname version;

    src = builtins.fetchTarball {
      url = "https://download.swift.org/swift-5.10.1-release/debian12/swift-5.10.1-RELEASE/swift-5.10.1-RELEASE-debian12.tar.gz";
      sha256 = "18kg741vvwc5w2yckhfpsnqwp4c30yiz6nzbbgqdg50zmiwr9gm4";
    };

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    buildInputs = [
      stdenv.cc.cc.lib
      ncurses.out
      libxml2.out
      libuuid.lib
      libz.out
      sqlite.out
      (curl.overrideAttrs (_: old: {configureFlags = old.configureFlags ++ ["--enable-versioned-symbols"];})).out
      python3.out
    
      (libedit.overrideAttrs (_: {postInstall ? "", ...}: {
        postInstall =
          postInstall
          + ''
            cd $out/lib
            ln -s libedit.so.0 libedit.so.2
          '';
      }))

    ];

    installPhase = ''
      cp -r $src/usr $out
    '';
  };
in
  buildFHSEnv {
    name = pname;
    targetPkgs = pkgs: [
      swift-unwrapped

      glibc.dev
      stdenv.cc.cc
      stdenv.cc.cc.lib

      # (curl.overrideAttrs (_: old: {configureFlags = old.configureFlags ++ ["--enable-versioned-symbols"];}))

      # clang
      # python311
      # (libedit.overrideAttrs (_: {postInstall ? "", ...}: {
      #   postInstall =
      #     postInstall
      #     + ''
      #       cd $out/lib
      #       ln -s libedit.so.0 libedit.so.2
      #     '';
      # }))
      # libcxx
      # libgcc
      # libxml2
      # sqlite
    ];

    runScript = "swift";
    profile = ''
      export CC=clang
    '';
  }
