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
      overlays = [];
    };
  in {
    packages.x86_64-linux.fcitx5-hazkey = pkgs.qt6Packages.callPackage ./fcitx5-hazkey.nix {
      inherit (inputs) hazkey-src;
      inherit (pkgs) fcitx5 swift vulkan-headers vulkan-loader vulkan-tools;
      inherit (pkgs.swiftPackages) swiftpm;
    };
    packages.x86_64-linux.default = self.packages.x86_64-linux.fcitx5-hazkey;
  };
}
