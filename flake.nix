{
  description = "friendly_chat flutter example using flutter-nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.follows = "flutter-nix/nixpkgs";
    flutter-nix = {
      url = "github:ilkecan/flutter-nix";
      inputs = {
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      inherit (inputs.flake-utils.lib)
        eachSystem
      ;

      supportedSystems = [
        "x86_64-linux"
      ];
    in
    eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            inputs.flutter-nix.overlay
          ];
        };

        inherit (pkgs)
          mkShell
          buildFlutterApp
          ;
      in
      rec {
        packages = {
          linux = buildFlutterApp {
            src = ./.;
            name = "friendly_chat";
            version = "1.0.0";
          };
        };

        defaultPackage = packages.linux;

        devShell = mkShell {
          packages = [
          ];

          shellHook = ''
          '';
        };
      }
    );
}
