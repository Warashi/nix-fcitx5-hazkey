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
          swift = pkgs.callPackage ./swift_5_10.nix {};
        })
      ];
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        swift
        # cmake
        # fcitx5
        # glslang
        # shaderc
        # vulkan-headers
        # vulkan-loader
        # vulkan-tools
        # glibc
      ];
    };
    packages.${system} = rec {
      fcitx5-hazkey = pkgs.qt6Packages.callPackage ./fcitx5-hazkey.nix { };
      swift = pkgs.swift;
      default = fcitx5-hazkey;
    };
  };
}
