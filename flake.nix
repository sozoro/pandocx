{
  description = "pandocx";

  inputs = {
    nixpkgs.url     = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url    = "github:numtide/devshell";
  };

  outputs = { self, ... }@inputs: (inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [
      inputs.devshell.flakeModule
    ];
    systems   = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    perSystem = { pkgs, system, ... }: rec {
      packages.default  = pkgs.callPackage ./default.nix {};
      devshells.default = {
        packages = [ packages.default ];
      };
    };
  }) // {
    name         = "pandocx";
    nixosModules = rec {
      addpkg = { pkgs, ... }: {
        nixpkgs.config = {
          packageOverrides = oldpkgs: let newpkgs = oldpkgs.pkgs; in {
            "${self.name}" = self.packages."${pkgs.stdenv.hostPlatform.system}".default;
          };
        };
      };

      install = { pkgs, ... }: (addpkg { inherit pkgs; }) // {
        environment.systemPackages = [ pkgs."${self.name}" ];
      };
    };
  };
}
