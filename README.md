# Nixos configuration README

This is what my Nixos configuration looked like before **I stopped using it**.
This is for "future reference" in case I decide to try it out one more time.

I have decided that, for a daily driver, what I really want is an OS I can mess
with, and an OS that is close to the other Linux distributions. And Nixos is
not that OS.

Reprducible builds and "OS as configuation" is pretty neat, it's too bad it's
very inflexible and o foreign to what most other Linux distributions do.

[configuration.nix](./configuration.nix) is the OS-level Nixos configuration
(with Luks configuration).  
[home-manager](./home-manager) is the home manager
configuration (to manage user packages and configurations separately from the
system configuration).

