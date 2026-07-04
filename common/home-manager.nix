{ pkgs, isDesktop, ... }:
{
  users.ember = import ./users/ember/home.nix { inherit pkgs; inherit isDesktop; };
}
