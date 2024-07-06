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
  pname = "swiftc";
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

    runScript = "swiftc";
    profile = ''
      export CC=clang
    '';
  }
