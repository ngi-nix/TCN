{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    naersk.url = "github:nmattia/naersk";

    tcn-src.url = "github:TCNCoalition/TCN";
    tcn-src.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, naersk, tcn-src }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
        naersk-lib = naersk.lib."${system}";
      in
      rec {
        # `nix build`
        packages.tcn-ref = naersk-lib.buildPackage {
          name = "tcn-ref";
          src = tcn-src;
          root = ./.;
        };
        defaultPackage = packages.tcn-ref;

        # `nix develop`
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ rustc cargo ];
        };
      }
    );
}
