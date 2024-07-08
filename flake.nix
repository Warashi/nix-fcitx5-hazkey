{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [
        (_: prev: {
          swift-unwrapped = pkgs.callPackage ./swift-unwrapped_5_10.nix {};
          swift = pkgs.callPackage ./swiftc_5_10.nix {};
          swiftpm = pkgs.callPackage ./swiftpm_5_10.nix {};
          azookey-kkc = pkgs.callPackage ./azookey-kkc.nix {};
          azookey-kkc-resources = pkgs.callPackage ./azookey-kkc-resources.nix {};
          fcitx5-hazkey = pkgs.qt6Packages.callPackage ./fcitx5-hazkey.nix {};
        })
      ];
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        swift
        swiftpm
        cmake
        gettext
        fcitx5
        glslang
        shaderc
        vulkan-headers
        vulkan-loader
        vulkan-tools
      ];
    };
    packages.${system} = rec {
      fcitx5-hazkey = pkgs.fcitx5-hazkey;
      azookey-kkc = pkgs.azookey-kkc;
      azookey-kkc-resources = pkgs.azookey-kkc-resources;
      default = fcitx5-hazkey;
    };
  };
}
