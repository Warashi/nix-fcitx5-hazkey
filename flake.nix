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
        (_: prev: rec {
          swift-unwrapped = pkgs.callPackage ./swift-unwrapped_5_10.nix {};
          swift = pkgs.callPackage ./swiftc_5_10.nix {};
          swiftpm = pkgs.callPackage ./swiftpm_5_10.nix {};
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
      fcitx5-hazkey = pkgs.qt6Packages.callPackage ./fcitx5-hazkey.nix {};
      azookey-kkc = pkgs.callPackage ./azookey-kkc.nix {};
      swift = pkgs.swift;
      default = azookey-kkc;
    };
  };
}
