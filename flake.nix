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
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [
        (_: prev: {
          swift =
            pkgs.callPackage ./swift_5_10.nix {
            };
        })
        (_: prev: {
          libedit = prev.libedit.overrideAttrs (_: {postInstall ? "", ...}: {
            postInstall =
              postInstall
              + ''
                cd $out/lib
                ln -s libedit.so.0 libedit.so.2
              '';
          });
        })
      ];
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        llvmPackages_latest.clang
        swift
        cmake
        fcitx5
        glslang
        shaderc
        vulkan-headers
        vulkan-loader
        vulkan-tools
        glibc
      ];
    };
    packages.${system} = rec {
      fcitx5-hazkey = pkgs.qt6Packages.callPackage ./fcitx5-hazkey.nix {
        inherit (inputs) hazkey-src;
        inherit (pkgs) fcitx5 swift glslang shaderc vulkan-headers vulkan-loader vulkan-tools;
        inherit (pkgs.llvmPackages_latest) stdenv;
        curl = pkgs.curl.overrideAttrs (_: old: {
          configureFlags = old.configureFlags ++ ["--enable-versioned-symbols"];
        });
      };
      default = fcitx5-hazkey;
    };
  };
}
