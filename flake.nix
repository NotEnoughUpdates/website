{
    description = "Moulberry's Bush Website";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, flake-utils, ... }:
        (flake-utils.lib.eachDefaultSystem (system: let pkgs = nixpkgs.legacyPackages.${system}; in {
            devShells.default = pkgs.mkShell {
                packages = with pkgs; [
                    nodejs_24
		    corepack
                ];
            };

            packages.default = self.packages.${system}.website;
            packages.website = pkgs.callPackage ./nix/package.nix {
                nodejs = pkgs.nodejs_24;
            };
        })) // {
            nixosModules.default = import ./nix/module.nix { inherit self; };
        };
}
