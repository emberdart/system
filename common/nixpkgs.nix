_:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      # permittedInsecurePackages = [
      #   # ???
      #   "python2.7-pyjwt-1.7.1"
      #   # ???
      #   "openssl-1.1.1t"
      #   "openssl-1.1.1u"
      # ];
      packageOverrides = pkgs: {
        xsaneGimp = pkgs.xsane.override { gimpSupport = true; };
        # ln -s /run/current-system/sw/bin/xsane ~/.config/GIMP/2.10/plug-ins/xsane
      };
    };

    # overlays = [
    #   (final: prev: {
    #     libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
    #       version = "git";
    #       src = final.fetchFromGitHub {
    #         owner = "archeYR";
    #         repo = "libfprint-CS9711";
    #         rev = "02b285c9703c38d308fbe47a3c566ef1e7f883ca";
    #         sha256 = "sha256-QGrBNqbRNqLZIURI66xkenlQamNW+DQU4WS+CLN4zM8=";
    #       };
    #       nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
    #         final.opencv
    #         final.cmake
    #         final.doctest
    #       ];
    #     });
    #   })
# 
    #   # (self: super: { kdePackages = (import <unstable> {}).pkgs.kdePackages; } )
    # ];
  };
}