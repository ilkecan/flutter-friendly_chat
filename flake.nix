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

      inherit (inputs.flutter-nix)
        supportedSystems
      ;
    in
    eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            inputs.flutter-nix.overlay
          ];
          config = {
            allowUnfree = true;
          };
        };

        inherit (pkgs)
          flutter-nix
        ;
      in
      rec {
        packages = {
          linux = flutter-nix.buildFlutterApp {
            src = ./.;
            name = "friendly_chat";
            version = "1.0.0";
            platform = "linux";
          };

          web = flutter-nix.buildFlutterApp {
            src = ./.;
            name = "friendly_chat";
            version = "1.0.0";
            platform = "web";
          };
        };

        defaultPackage = packages.linux;

        devShell = flutter-nix.mkShell {
          enableAll = true;
        };
      }
    );
}
