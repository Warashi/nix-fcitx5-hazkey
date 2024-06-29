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
    };
  in {
    packages.${system} = rec {
      fcitx5-hazkey = pkgs.qt6Packages.callPackage ./fcitx5-hazkey.nix { };
      default = fcitx5-hazkey;
    };
  };
}
