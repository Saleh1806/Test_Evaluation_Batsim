{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=22.11";
    nur-kapack = {
      url = "github:oar-team/nur-kapack/master";
      inputs.nixpkgs.follows = "nixpkgs"; # tell kapack to use the nixpkgs that is defined above
    };
    flake-utils.url = "github:numtide/flake-utils";

    # define your own batsim and batsched source code as inputs, which are git repository fetched via https, using the default branch of each repository.
    mybatsim-src.url = "git+https://git@framagit.org/batsim/batsim";
    mybatsched-src.url = "git+https://git@framagit.org/batsim/batsched";

    # the lines below show other ways to define inputs depending on your need, taking batsched as an example.

    # batsched, from a git repository fetched via ssh, on a specific branch.
    # the version used by nix can be updated with this command: nix flake lock --update-input mybatsched-src
    # mybatsched-src.url = "git+ssh://git@framagit.org/batsim/batsched?ref=master";

    # batsched, from a git repository fetched via ssh, on a specific commit.
    # mybatsched-src.url = "git+ssh://git@framagit.org/batsim/batsched?rev=203c79745b0718d28fe08a6e2ba863ee9dff0922"; # important: rev, not ref!

    # batsched, from a local git repository. This is very useful for private repositories.
    # mybatsched-src.url = "/home/mpoquet/proj/batsched"; # use the path to the git repository's root
  };

  outputs = { self, nixpkgs, nur-kapack, flake-utils, mybatsim-src, mybatsched-src }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs { inherit system; };
        kapack = nur-kapack.packages.${system};
      in rec {
        packages = {
          mybatsim = kapack.batsim.overrideAttrs (final: previous: {
            version = mybatsim-src.shortRev;
            src = mybatsim-src;
          });
          mybatsched = kapack.batsched.overrideAttrs (final: previous: {
            version = mybatsched-src.shortRev;
            src = mybatsched-src;
          });
        };
        devShells = rec {
          simulation = pkgs.mkShell {
            buildInputs = [
              packages.mybatsim
              packages.mybatsched
              kapack.batexpe
            ];
            #WORKLOAD_DIR = "${mybatsim-src}/workloads";
            #PLATFORM_DIR = "${mybatsim-src}/platforms";
          };
          analysis = pkgs.mkShell {
            buildInputs = [
              kapack.evalys
            ];
            # needed to avoid matplotlib crash at startup
            QT_QPA_PLATFORM_PLUGIN_PATH = "${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.version}/plugins";
          };
          visualization = analysis;
        };
      }
    );
}
