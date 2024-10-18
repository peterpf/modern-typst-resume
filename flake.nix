{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.05";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = { self, nixpkgs, pre-commit-hooks }: let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = self.overlays.${system}.default;
      };
  in
  {
    overlays.${system}.default = [
      (final: prev: {
        typst = prev.typst.overrideAttrs (old: {
          patches = old.patches ++ [
            (prev.fetchpatch {
              url = "https://github.com/typst/typst/commit/15a26c6c45bea9a539b0dfdb3999422d8ce1f558.patch";
              hash = "sha256-ZQnONB0gB6SjMT5ixhPD0JlamfZNiEdophDLy3nFKH0=";
            })
          ];
        });
      })
    ];
    checks.${system} = {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          typos.enable = true;
        };
      };
    };
    devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
      inherit (self.checks.${system}.pre-commit-check) shellHook;
      packages = with pkgs; [ typst pre-commit ];
    };
  };
}
