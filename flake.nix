{
  description = "Nix flake for the project 'modern-typst-resume'";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.05";
    typst.url = "github:typst/typst?ref=v0.12.0";
  };

  outputs = { self, nixpkgs, typst }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    checks.${system} = {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          typos.enable = true;
        };
      };
      tests = pkgs.stdenv.mkDerivation {
        name = "test_lib";
        src = self;
        buildInputs = [ pkgs.typst ];
        buildPhase = ''bash
          typst compile tests/test_lib.typ --root . --input config=tests/config.yaml >> log.txt
        '';

        unpackPhase = "";
        installPhase = ''bash
          mkdir -p $out/bin
          mv log.txt $out/bin
        '';
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      inherit (self.checks.${system}.pre-commit-check) shellHook;
      packages = [
        typst.packages.${system}.typst-dev
        pkgs.pre-commit
      ];
    };
  };
}
