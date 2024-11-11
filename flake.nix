{
  description = "Super flake, comprising all my personal flakes";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    c3c.url = "path:./c3c";
  };

  outputs = { self, ... } @ inputs: inputs.flake-utils.lib.eachDefaultSystem 
  (system: 
    {
      packages.c3c = inputs.c3c.outputs.packages.${system}.default;
    }
  );
}
