{ pkgs, ... }:
{
  home.packages = with pkgs; [
    neovim

    # Runtimes and package managers.
    nodejs_20 # TODO: findout how to easily switch node versions for local projects. Have neovim list node as a dependency?
    cargo

    # Compilers.
    gccgo # C compiler.

    # Languages servers.
    lua-language-server
    marksman # Markdown.
  ];
}

