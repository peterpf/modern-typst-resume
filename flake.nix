{
  description = "Nix flake for the project 'modern-typst-resume'";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/25.05";
    typst.url = "github:typst/typst?ref=v0.14.0";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = {
    self,
    nixpkgs,
    typst,
    pre-commit-hooks,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    checks.${system} = {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          typos.enable = true;
          yamlfmt.enable = true;
          alejandra.enable = true;
        };
      };
      tests = pkgs.stdenv.mkDerivation {
        name = "test_lib";
        src = self;
        buildInputs = [pkgs.typst];
        buildPhase = ''
          typst compile tests/test_lib.typ --root . --input config=tests/config.yaml >> log.txt
        '';

        unpackPhase = "";
        installPhase = ''
          mkdir -p $out/bin
          mv log.txt $out/bin
        '';
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      inherit (self.checks.${system}.pre-commit-check) shellHook;
      packages =
        [
          typst.packages.${system}.typst-dev
        ]
        ++ self.checks.${system}.pre-commit-check.enabledPackages;
    };
  };
}
