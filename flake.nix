{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-for-swift.url = "github:nixos/nixpkgs/feb2849fdeb70028c70d73b848214b00d324a497";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-for-swift,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-for-swift = nixpkgs-for-swift.legacyPackages.${system};
    in
    {
      packages.${system} = rec {
        swift-unwrapped = pkgs-for-swift.callPackage ./swift-unwrapped_5_10.nix {};
        swift = pkgs-for-swift.callPackage ./swiftc_5_10.nix { inherit swift-unwrapped; };
        swiftpm = pkgs-for-swift.callPackage ./swiftpm_5_10.nix { inherit swift-unwrapped; };
        azookey-kkc-resources = pkgs.callPackage ./azookey-kkc-resources.nix { };
        azookey-kkc = pkgs-for-swift.callPackage ./azookey-kkc.nix { inherit swift swiftpm azookey-kkc-resources; };
        fcitx5-hazkey = pkgs.qt6Packages.callPackage ./fcitx5-hazkey.nix { inherit azookey-kkc; };
        default = fcitx5-hazkey;
      };
    };
}
