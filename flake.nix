{
  description = "A simple flake for testing the Switch into Nix Shell action";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, unstable }:
    let
      lib = nixpkgs.lib;

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 lastModifiedDate;

      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; config.allowUnfree = true; });
      unstableFor = forAllSystems (system: import unstable { inherit system; config.allowUnfree = true; });

    in
    with lib;
    {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          unstablePkgs = unstableFor.${system};
        in
        {
          default = (pkgs.mkShell {
            buildInputs = with pkgs; flatten [
              hello
            ];
            shellHook = ''
              export TEST_ENV_VAR="Hello from Nix Shell"
              export ANOTHER_VAR="Another variable"
            '';
          });
        });
    };
}
