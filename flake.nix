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
    mybatsched-src.url = "git+https://github.com/Saleh1806/Batsim_Test_1";

    # Ajout de batprotocol et intervalset
    batprotocol = {
      url = "git+https://framagit.org/batsim/batprotocol";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nur-kapack.follows = "nur-kapack";
      inputs.flake-utils.follows = "flake-utils";
    };

    intervalset = {
      url = "git+https://framagit.org/batsim/intervalset";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nur-kapack.follows = "nur-kapack";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, nur-kapack, flake-utils, mybatsim-src, mybatsched-src, batprotocol, intervalset }:
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

          # Ajout de batprotocol et intervalset dans les packages
          batprotocol = batprotocol.packages-release.${system}.batprotocol-cpp;
          intervalset = intervalset.packages-release.${system}.intervalset;
        };
        devShells = rec {
          simulation = pkgs.mkShell {
            buildInputs = [
              packages.mybatsim
              packages.mybatsched
              kapack.batexpe
              packages.batprotocol  # Ajout de batprotocol dans devShell
              packages.intervalset   # Ajout de intervalset dans devShell
            ];
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
