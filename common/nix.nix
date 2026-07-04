_:
{
  nix = {
    # package = pkgs.nix;

    # max-jobs = 64;

    settings = {
      trusted-users = [ "root" "ember" ];

      system-features = [
        "kvm"
        "big-parallel"
        "gccarch-native" # todo
      ];

      substituters = [
        "https://cache.nixos.org"
        "https://winapps.cachix.org"
        "https://nixpkgs-update-cache.nix-community.org"
        "https://nix-community.cachix.org"
        # "https://cache.jolharg.com"
        "https://dandart.cachix.org"
        "https://nixcache.reflex-frp.org"
        "https://miso-haskell.cachix.org"
        "https://nixcache.webghc.org"
        "https://cache.iog.io"
        "https://static-haskell-nix.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g="
        "nixpkgs-update-cache.nix-community.org-1:U8d6wiQecHUPJFSqHN9GSSmNkmdiFW7GW7WNAnHW0SM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "cache.jolharg.com:JSK2oHzlOOULEJXAM1sKG7+WvB3bZkO9DtlyljmjfH4="
        "dandart.cachix.org-1:k7r2DOpcXOY6Hx+qXMrtYjzCt0XH5tmfJHL/faJ088I="
        "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
        "miso-haskell.cachix.org-1:6N2DooyFlZOHUfJtAx1Q09H0P5XXYzoxxQYiwn6W1e8="
        "hydra.webghc.org-1:knW30Yb8EXYxmUZKEl0Vc6t2BDjAUQ5kfC1BKJ9qEG8="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "static-haskell-nix.cachix.org-1:Q17HawmAwaM1/BfIxaEDKAxwTOyRVhPG5Ji9K3+FvUU="
      ];

      experimental-features = [
        "auto-allocate-uids"
        "ca-derivations"
        "cgroups"
        "flakes"
        "nix-command"
      ];

      auto-optimise-store = true;
    };

    gc = {
      automatic = true; # true
      options = "-d";
      dates = "weekly"; # "03:15"
      persistent = true; # like anacron
    };

    # Saves 2.4G
    extraOptions = ''
      keep-outputs = false
      keep-derivations = false
    '';
    
    optimise = {
      automatic = true;
    };
  };
}