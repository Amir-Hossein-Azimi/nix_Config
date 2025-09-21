{
  inputs = { 
    # Define the Nixpkgs repository, using the unstable branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; 

    # Define the stable Nixpkgs repository
    #nixpkgs-stable = {
    #  url = "github:nixos/nixpkgs/nixos-24.11"; # Or your desired stable branch, e.g., nixos-24.05 when available
    #  # It's good practice to not have this follow the main nixpkgs if you want it truly independent and stable
    #};

    # Define the Home Manager repository
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Home Manager follows the Nixpkgs input
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Define the Nixpkgs Wayland repository
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    
    # Define the Nix Flatpak repository
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    
    # Define the NUR (Nix User Repository)
   nur = {
	url = "github:nix-community/NUR";
      	inputs.nixpkgs.follows = "nixpkgs"; # Home Manager follows the Nixpkgs input
    };
  
    # Define the Chaotic repository
    #chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
# to fix command not found
programsdb.url = "github:wamserma/flake-programs-sqlite";
programsdb.inputs.nixpkgs.follows = "nixpkgs";

############################
# non-flake example
# # github repo
#    material-fox-updated = {
#      url = "https://github.com/edelvarden/material-fox-updated/releases/download/v2.0.0/chrome.zip";
#      flake = false;
#    };
#
# # urls
#    material-fox-updated = {
#      url = "github:edelvarden/material-fox-updated";
#      flake = false;
#    };
#
# then in configuration.nix
#  home.file.material-fox = {
#    source = inputs.material-fox-updated;
#    target = ".mozilla/firefox/default/chrome/material-firefox-updated";
#  };
#
# you could even specify fish plugins
#      { name = "pufferfish"; src = inputs.fish-plugin-pufferfish; }
#
# still learning.


  };

  # Nix configuration settings
  nixConfig = {
    # retry-count = 10;
    # Additional cache servers for fetching packages
    extra-substituters = [
      "https://nix-community.cachix.org"
#      "https://cache.garnix.io"
      "https://nixpkgs-wayland.cachix.org"
    ];
    
    # Trust keys for the specified cache servers
    extra-trusted-public-keys = [
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
#      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = { 
    self, 
    nixpkgs, # This is your main unstable nixpkgs
    #nixpkgs-stable, # This is your stable nixpkgs input
    stylix, 
    nix-flatpak,
    home-manager, 
    plasma-manager,
    nixpkgs-wayland,
    nur,
    #chaotic,
    ... 
  }@inputs: 
    let
      system = "x86_64-linux"; # Define the system architecture
      username = "amir"; # Define the username for home configurations
      # Packages from your main (unstable) nixpkgs

      #if you do not nead unfree
      #pkgs = nixpkgs.legacyPackages.${system};

      pkgs = import nixpkgs {
         system = system;
         config.allowUnfree = true;
      };
      # Packages from your stable nixpkgs
      #pkgs-stable = nixpkgs-stable.legacyPackages.${system};      
    in {
      # Define the NixOS configuration
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs; # Passes all inputs
        #pkgs-stable = pkgs-stable; # Specifically pass the stable package set
        # You can also pass pkgs here if needed explicitly, though it's often available via nixpkgs.legacyPackages
      };
        modules = [
#           nur.modules.nixos.default # Updated from nur.nixosModules.nur, Include NUR modules
           home-manager.nixosModules.home-manager # Include Home Manager modules
	   stylix.nixosModules.stylix
	   nur.modules.nixos.default
	   nix-flatpak.nixosModules.nix-flatpak # Include Nix Flatpak modules
#          nix-flatpak.nixosModules.nix-flatpak # Include Nix Flatpak modules
#          chaotic.nixosModules.default # Include Chaotic modules
          ./configuration.nix # Include the main configuration file

        ];
      };
    };
}
