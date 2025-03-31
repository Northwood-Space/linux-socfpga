{
  description = "A very basic flake for building altera linux";

  inputs = {
    northwood-nixpkgs.url = "git+ssh://git@github.com/Northwood-Space/northwood-nixpkgs?ref=main&rev=4388c8560e03ce7b45b74c49245a61d719a64fbe";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, northwood-nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = northwood-nixpkgs.legacyPackages.${system};
        in {
          devShells.default = import ./shell.nix {
            inherit system pkgs;
            # If you would like to use menuconfig or xconfig to configure your image,
            # then comment out one of the following lines.
            #
            # By default, we do not want to pull in the dependencies these require.

            # menuconfig = true;
            # xconfig = true;
            fit-generation = true;
          };
        }
      );
}
