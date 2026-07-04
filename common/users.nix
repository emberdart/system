{ username, hostname, privateDir, ... }:
let myKeys = [
    ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6DDaMcQMcPI5DMU2pgaxTcd83E/xoHnJFXwSIkjkSZPpfhRBOorcXnhi2qs6PzYcKkC/50vm9+kEnZDERNr/HmSwEZt83UpzA4AmAjhDuFzCumyv7m8XjlL4dFxPLYgSmHTAzk54AtbiZfWRH6dgXE0SHF9Oyk8o3QYp4G3/KQ11DsVG1LbRYUWkdfWLQ1A+/oRh3HaBAX/p7fMKJqDayMtYxDxtMVqVu5oPpWsadboC7z9IbfF+DQCqTgjwW/+u9CD62ceiDUesO2Uwg2PzW6rydtpQU3eYIMePRQIPI79doRxZFiyxLlzgVMRGFiB1RYkdw49jei1envwFGB2uiBNeFnyP2EMvCGBIX0rcyoDKyEixhMito8dyYUO2I62F7+dkOOnq2ofTn/n9wLCM+oRtxyNEwT++eUt4G1ZBmWEdBYLsa/wXC3Q78OoPEt4ECmP+NvaFHpllRWL+jKXtmGrOcK0T+KPf6C4i0kwSm++uTjR8ZKR/D5vsfiRawR08= nix-on-droid@localhost''
    ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYdqN0shqtDIWOauiAead09dF0Qmjd9IZnfRsHeLSGDTqLfxRhkJGMOdHAH8Bp9XZzvjIrG8e9Tc7y0x2lz1nC6kcqZCRhEphc8IpuOjAT/RVx8rvQKnid9zBrMgVKOKeRRUwqyUnYakFSreSaJM/ttWFkjU3re99fL/8bY0u5bOZlE2YLaGp144Rqvk5S/REklGICUt3ZZFkFjIh0rg0VaRYeXNFokxSLVuJJpiJ6RgRB0vw2ZMOg3hitv4EEeBdNQqG1RKfRKeaaIj1VFxzqZM7VyAW8O8BdWRSwlnhtMNqpFVbB6+WrR5/e8hOpR9IlAb4HczfRK0bDSuy9e9yvVQ2twVle4buzkq1HOtOF5DbXLY/cHBr3PWAoweimBYhd2o93nQz7qEedm1+rL5Z4JE6u1U7AMhAcDWSoJGsQZwSeICDlIsLHLXJ3HRZQ6H3MqwLFu9x35I7OyLac0kTAqsh9m+4Vi6ha/JlyYlSBE9Jlg9Vx2BPNcNHsHEcAAfc= ${username}@M-H7MN7QR4V5''
    ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEiVZSKNnqBeZLknioRXVTTHsS1M1pz5IW95uUSaysIK8/uw/iTBxWoIWqAuBaAcAtRRgBtCrx686lShqDaRLYty6kAFPeXtwRRPpi7t6e3BTIUi7OT6M6sndyjI9YviCjiial67OTxEQaZAWcKMPV6dKOGH+zohZg5Qt99Fqym1lDhdF9PM6OsaPJZJ55RJWNpfpe5hZm0oSUEKmjfme+SvWok1giPmhk6HNggvEVC2py/k/iDmk9dNm4Y1GusScQErtH5+HFBZ8apQjYZjBYiTXn6Op3wRzOmxRGdykxANCp98yxflq+16QA5NVKesIuO4WsyvHKyhAtlnOZrbFO1er8SUQqNuQQPArexH/IPdtjmYhGXCvdFtLZtT4xM9SaCwpvdIGUHiCnGRATZDw6Fe2p2cz+EGHTNLQ4uDJ1vDQrXgyrc+W8uCylZ6d7qKOGvWwmLOLdhxY5mvFUB1SAbLceSx649hf/UppWowmbs3CnhGfUwsEUmFPCOQcco9c= ${username}@nixos''
    ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCz8FhFVcqh80tlnZ3VJ4UDG0phm4arBqrPYdNNPw1zrSDC8OzOjQ/W0MX14upJRPWHsiJfmwhuheWjQgmM2/vO5/pw8nLAWEX46QuBIY0nnf0/15/y+V9vsT0vs6FiiRyY9YeH4/pHqb6ExDIyU7HZXdua0jxbgRCCy0SL3L9z1SdjdKqX0wJ+NpI2giIVHGpgmuUQEZ6r9+V7dpwx2xEtRlGhS1q8EEqC3JFNMr1s7BMfPIfqDjyRjq3xjqq+Fw40H3YM5FBBHxESaHgxJpY0Q1EtbA1Mk/6re+po2jA36NHRYAecOfhAstUTxxdp5K2Q/wMhu0eqV1PXCvR5rbwM/CT4TuLqaO3ySybJpkGs2dwQB3KDtZ9qlM8M2mE80RGu9pBTTjwNyWky0ucATJ68Kt0b6vKRefKyenw26G+vdn3GVJoRQLz/O1EpKirnw6S1U/9YRFgKwH/FfI2FjBEF1q2U6PM4wZJSMosjodHzuISv9VWZI/pG+3K3HMqS8l0= ${username}@testbox''
    ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmk3PFu4CkndaejZMKuW2anM7n+WMzkp0qw9jMxf7bld/gNZBXiSE3g0vlZ9NLePyr3m9RDgBKzeCCqSTAFKtYOE5Ut369fLdNxpJ1i1xAOJeKJbCB206sZ7pkqHke6FxC+tI+BqtoNM1jtffoWdFmtuUvQyvGVNbH975UpMaQtvF18T+OHPiqlk3Ypgy1wcglrA7M7GYCUFBNejcEZtwE7zgkao8LJbOCncAi47sqimNg3FZwxpmbXBKiGFOB+RcQvpuprB0IxKH+Dui4MCW+7KtxDG40v8eXHAmXKpEjG8Tej00ccc28tKP5BbG91brxSASt/oKgWbvQw1ndm8oHmq46f7buTE7jpPFmTE676DwR3eAi93nMZdKswb1tAbikg4uVZy1z0gQTLE6xIjO3SSLcJNdqQDga7nqKv1876AM5+c5BbHEG3D46ckVKQsKL7AsF9Zf/vCQtlmL7DehyE5dE8C+6ReBiBYgSUsGvKXJ5YQTVXyBAAS5M/Xun+o0= ${username}@nixos''
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgmEbNpYCGw72HLs+lKeLZ6pXgZkKU5unZVXlkYhKb8 ${username}@${hostname}''
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINq1cR1L7TnELPl3b82q/mFzNu+ZDqI/t5PRrr3m/H/F micro@GLaDOS''
];
in
{
    users = {
        # Don't allow mutation of users outside of the config.
        mutableUsers = false;
    
        # Set a root password, consider using
        # initialHashedPassword instead.
        #
        # To generate a hash to put in initialHashedPassword
        # you can do this:
        # $ nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd
        users = {
            root = {
                initialHashedPassword = builtins.readFile "${privateDir}/users/root/hashed_password";
                openssh.authorizedKeys.keys = myKeys;
            };  
        
            ember = {
                createHome = true;
                # name = "Ember Dart";
                description = "Ember Dart";
                initialHashedPassword = builtins.readFile "${privateDir}/users/${username}/hashed_password";
                isNormalUser = true;
                extraGroups = [
                    "adbusers"
                    "dialout"
                    "docker"
                    "jackaudio"
                    "kvm"
                    "libvirtd"
                    "lp"
                    "networkmanager"
                    "plugdev"
                    "scanner"
                    "soundmodem"
                    "vboxusers"
                    "wheel"
                    "wireshark"
                ];
                openssh.authorizedKeys.keys = myKeys;
                linger = true;
                homeMode = "755";
            };
        };
    };
}
