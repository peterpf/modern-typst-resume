{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.05";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = { self, nixpkgs, pre-commit-hooks }: let
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
      packages = [ pkgs.typst pkgs.pre-commit ];
    };
  };
}
