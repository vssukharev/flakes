{
  description = "Flake for c3c compiler";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    c3c = {
      url = "github:c3lang/c3c?ref=v0.6.4";
      flake = false;
    };
  };

  outputs = { self, ... } @ inputs: inputs.flake-utils.lib.eachDefaultSystem 
  (system: 
    let pkgs = import inputs.nixpkgs { inherit system; };
    in 
    {
      packages.default = pkgs.callPackage ./package.nix { 
        c3c-src = inputs.c3c;
        c3c-ver = "0.6.4";
      };
    }
  );
}
