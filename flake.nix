{
    description = "Despite there being just 13 stripes on the American flag, there is 50 stars.";

    inputs = {
        # Specify the source of Home Manager and Nixpkgs.
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        agenix = {
            url = "github:ryantm/agenix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        kirk-modules.url = "github:rasmus-kirk/nix-modules";
    };

    outputs = { 
        nixpkgs,
        agenix, # Bliver brugbart senere når du skal bruge secrets
        home-manager,
        kirk-modules,
        ...
        }: 
    {
        homeConfigurations = {
            mxpro = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs {
                    system = "x86_64-linux";
                    config.allowUnfree = true;
                };        

                modules = [ 
                    ./home-manager/mxpro/home.nix
                    kirk-modules.homeManagerModules.default
                ];
            };
        };
    };
}
