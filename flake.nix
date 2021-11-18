{
  description = "TODO";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flutter-nix = {
      url = "path:/home/ilkecan/projects/personal/flutter";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      inherit (inputs.flake-utils.lib)
        defaultSystems
        eachSystem
        ;

      supportedSystems = defaultSystems;
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
          buildFlutterPackage
          ;
      in
      rec {
        packages = {
          linux = buildFlutterPackage {
            src = ./.;
            name = "friendly_chat";
            version = "1.0.0";
          };
        };

        defaultPackage = packages.trivial;

        devShell = mkShell {
          packages = [
          ];

          shellHook = ''
          '';
        };
      }
    );
}
