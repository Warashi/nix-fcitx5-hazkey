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
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = rec {
      swift-unwrapped = pkgs.callPackage ./swift-unwrapped_5_10.nix {};
      swift = pkgs.callPackage ./swiftc_5_10.nix {inherit swift-unwrapped;};
      swiftpm = pkgs.callPackage ./swiftpm_5_10.nix {inherit swift-unwrapped;};
      azookey-kkc-resources = pkgs.callPackage ./azookey-kkc-resources.nix {};
      azookey-kkc = pkgs.callPackage ./azookey-kkc.nix {inherit swift swiftpm azookey-kkc-resources;};
      fcitx5-hazkey = pkgs.qt6Packages.callPackage ./fcitx5-hazkey.nix {inherit azookey-kkc;};
      default = fcitx5-hazkey;
    };
  };
}
