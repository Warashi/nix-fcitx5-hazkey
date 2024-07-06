{
  llvmPackages_15,
  stdenv ? llvmPackages_15.stdenv,
  swift-unwrapped,
  buildFHSEnv,
  glibc,
  glslang,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  vulkan-tools,
}: let
  pname = "swift";
in
  buildFHSEnv {
    name = pname;
    targetPkgs = pkgs: [
      swift-unwrapped

      glibc.dev
      stdenv.cc.cc
      stdenv.cc.cc.lib

      glslang
      shaderc
      vulkan-headers
      vulkan-loader
      vulkan-tools
    ];

    setupHook = ./swiftpm-setup-hook.sh;

    runScript = "swift";
    profile = ''
      export CC=clang
    '';
  }
