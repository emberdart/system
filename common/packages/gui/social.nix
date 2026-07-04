pkgs:
let
    pkgs-x86_64 = import <nixos> {
        system = "x86_64-linux";
        config = {
            allowUnfree = true;
        };
    };
in
with pkgs; [
    # Known issues:
    #     - The libolm end‐to‐end encryption library used in many Matrix
    # clients and Jitsi Meet has been deprecated upstream, and relies
    # on a cryptography library that has known side‐channel issues and
    # disclaims that its implementations are not cryptographically secure
    # and should not be used when cryptographic security is required.
    # 
    # It is not known that the issues can be exploited over the network in
    # practical conditions. Upstream has stated that the library should
    # not be used going forwards, and there are no plans to move to a
    # another cryptography implementation or otherwise further maintain
    # the library at all.
    # 
    # You should make an informed decision about whether to override this
    # security warning, especially if you critically rely on end‐to‐end
    # encryption. If you don’t care about that, or don’t use the Matrix
    # functionality of a multi‐protocol client depending on libolm,
    # then there should be no additional risk.
    # 
    # Some clients are investigating migrating away from libolm to maintained
    # libraries without known vulnerabilities.
    # 
    # For further information, see:
    # 
    # * The libolm deprecation notice:
    #     <https://gitlab.matrix.org/matrix-org/olm/-/blob/6d4b5b07887821a95b144091c8497d09d377f985/README.md#important-libolm-is-now-deprecated>
    # 
    # * The warning from the cryptography code used by libolm:
    #     <https://gitlab.matrix.org/matrix-org/olm/-/blob/6d4b5b07887821a95b144091c8497d09d377f985/lib/crypto-algorithms/README.md>
    # 
    # * The blog post disclosing the details of the known vulnerabilities:
    #     <https://soatok.blog/2024/08/14/security-issues-in-matrixs-olm-library/>
    # 
    # * The Matrix.org project lead’s response to the disclosure:
    #     <https://news.ycombinator.com/item?id=41249371>
    # 
    # * A (likely incomplete) aggregation of client tracking issue links:
    #     <https://github.com/NixOS/nixpkgs/pull/334638#issuecomment-2289025802>
    # element-desktop # insecure notice
    fractal
] ++ (if builtins.currentSystem == "x86_64-linux" then [
    betterdiscordctl
    (discord.override {
        # withOpenASAR = true;
        nss = pkgs.nss_latest;
    })
    discordchatexporter-cli
    discordchatexporter-desktop
    # matrix-appservice-discord # uses old node
    # mautrix-discord # no libolm
    music-discord-rpc
    # slack
    # skypeforlinux
    teams-for-linux
    vencord
    vencord-web-extension
    webcord
    webcord-vencord
    # vesktop # pnpm vulnerable
    # zoom-us
] else [
   # pkgs-x86_64.betterdiscordctl
   # (pkgs-x86_64.discord.override {
   #      withOpenASAR = true;
   #      nss =# pkgs-x86_64.nss_latest;
   #  })
   # pkgs-x86_64.skypeforlinux
])
