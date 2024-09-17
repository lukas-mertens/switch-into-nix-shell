{
  description = "A simple flake for testing the Switch into Nix Shell action";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  outputs = { self, nixpkgs, ... }:
    let
      pkgs = import nixpkgs {
        inherit (nixpkgs) system;
      };
    in {
      devShell = pkgs.mkShell {
        packages = [ pkgs.hello ];

        # Set environment variables
        shellHook = ''
          export TEST_ENV_VAR="Hello from Nix Shell"
          export ANOTHER_VAR="Another variable"
        '';
      };
    };
}
