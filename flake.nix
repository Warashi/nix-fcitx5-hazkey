{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    hazkey-src = {
      url = "github:7ka-Hiira/fcitx5-hazkey";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [
        (_:_: {
          swift = pkgs.callPackage ./swift_5_10.nix {};
        })
      ];
    };
  in {
    packages.x86_64-linux.fcitx5-hazkey = pkgs.qt6Packages.callPackage ./fcitx5-hazkey.nix {
      inherit (inputs) hazkey-src;
      inherit (pkgs) fcitx5 swift glslang shaderc vulkan-headers vulkan-loader vulkan-tools;
      inherit (pkgs.swiftPackages) swiftpm;
    };
    packages.x86_64-linux.default = self.packages.x86_64-linux.fcitx5-hazkey;
  };
}
