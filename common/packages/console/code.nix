pkgs:
let pkgs-x86_64 = import <nixos> {
        system = "x86_64-linux";
        config = {
            allowUnfree = true;
        };
    };
in
with pkgs; [
    # platform-tools?
    python314Packages.android-backup
    # code-server # unneeded
    # docker-compose # doing the alias doesn't seem to be enough
    gh
    gitFull
    git-hub
    hub
    git-crypt
    git-lfs
    # neovim
    vim # plugins?
    # xcodebuild
] ++ (if builtins.currentSystem == "x86_64-linux" then [
    adbfs-rootless
] else [
   # pkgs-x86_64.adbfs-rootless
])
