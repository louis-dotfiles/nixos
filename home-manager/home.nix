{ config, pkgs, nix-colors, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "louis";
  home.homeDirectory = "/home/louis";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  imports = [
    nix-colors.homeManagerModules.default
    ./nvim.nix
  ];

  colorScheme = nix-colors.colorSchemes.dracula;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    alacritty
    ansible
    docker-compose
    eza
    fd
    firefox
    kubectl
    kubectx
    nitrogen # TODO: wallpaper.
    ripgrep
    # https://www.nerdfonts.com/font-downloads
    (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })

    go

    insomnia

    python3 # For dotbot.
  ];

  fonts.fontconfig.enable = true;

  programs = {
    lf = {
      enable = true;

      settings = {
        preview = true;
        icons = true;
        hidden = true;
        drawbox = true;
        ignorecase = true;
      };
    };

    git = {
      enable = true;
      userName = "Louis VINCHON";
      userEmail = "louis.vinchon.dev@gmail.com";


      diff-so-fancy.enable = true;

      aliases = {
        "ada"  = "add --all";
        "br"   = "branch";
        "ci"   = "commit";
        "cia"  = "commit --amend";
        "cian" = "commit --amend --no-edit";
        "cl"   = "clone";
        "co"   = "checkout";
        "logs" = "log";
        "ls"   = "log --oneline";
        "st"   = "status --short";
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = false;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      defaultKeymap = "viins";

      dotDir = ".config/zsh";

      initExtra = ''
        bindkey '^ ' autosuggest-accept
      '';

      # TODO: move that stuff to a separate file.
      envExtra = ''
        export EDITOR="nvim"
        export CARGO_HOME="${config.xdg.cacheHome}/cargo"
        export npm_config_cache="${config.xdg.cacheHome}/npm"
        export NODE_REPL_HISTORY="${config.xdg.dataHome}/node_repl_history"

        ########
        # LESS #
        ########

        export LESSKEY="${config.xdg.configHome}/less/lesskey"
        export LESSHISTFILE="${config.xdg.cacheHome}/less/history"
        export LESS='--RAW-CONTROL-CHARS --status-column --line-numbers --hilite-unread --no-histdups'

        # Coloring is complicated so hold on to your butt.
        #
        # Styling (not just coloring) is done with ANSI escape sequences.
        # https://en.wikipedia.org/wiki/ANSI_escape_code
        #
        # Such sequences are composed as follows (in shell scripts at least):
        # `\e[<sequences>m`
        #
        # Where `<sequences>` is a list of numbers separated by semicolons ';'.
        # 
        # Particular combinations of numbers mean different things, such as 'bold', 'italic', 'underline'
        # and colors.
        #
        # To define a color you should use:
        # - `38;2;R;G;B` to define RGB foreground.
        # - `48;2;R;G;B` to define RGB background.

        # #7aa6da
        # #70c0b1
        # #b4ec4a
        # #e7c547
        # #e78c45
        # #d54e53
        # #c397d8

        export LESS_TERMCAP_md=$'\e[1m' # Start bold.
        export LESS_TERMCAP_us=$'\e[4;38;2;185;221;74;48;2;0;0;0m' # Start underline.
        export LESS_TERMCAP_so=$'\e[1;48;2;231;197;71;38;2;0;0;0m' # Start standout.

        # Style resets.
        export LESS_TERMCAP_me=$'\e[0m' # End bold.
        export LESS_TERMCAP_ue=$'\e[0m' # End underline.
        export LESS_TERMCAP_se=$'\e[0m' # End standout.
      '';

      initExtraBeforeCompInit = ''
         setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
         setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
         setopt PATH_DIRS           # Perform path search even on command names with slashes.
         setopt AUTO_MENU           # Show completion menu on a successive tab press.
         setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
         setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
         setopt EXTENDED_GLOB       # Needed for file modification glob modifiers with compinit
         unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
         unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.

         # Allow dotfiles completion.
         _comp_options+=(globdots)

         # Case-insensitive (all), partial-word, and then substring completion.
         zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      '';

      completionInit = ''
        autoload -Uz compinit
        # Use -d to indicate the location of the .zcompdump file.
        # https://zsh.sourceforge.io/Doc/Release/Completion-System.html
        compinit -d "${config.xdg.cacheHome}/zsh/zcompdump-$ZSH_VERSION"
      '';

      history = {
        # ignoreAllDups = true;
        ignoreDups = true;
        path = "${config.xdg.dataHome}/zsh/zsh_history";
      };

      shellAliases = {
        "ls"  = "eza";
        "ll"  = "eza --long --header";
        "lla" = "eza --long --header --all";
        ".."   = "cd ..";
        "..."  = "cd ../..";
        "...." = "cd ../../..";

        "dcp"   = "docker compose";
        "dk"    = "docker";
        "dkc"   = "docker container";
        "dkcls" = "docker container ls --all --format 'table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}'";
        "dke"   = "docker exec";
        "dki"   = "docker image";
        "dkils" = "docker image ls --format 'table {{.Repository}}\t{{.Tag}}\t{{.ID}}'";
        "dkl"   = "docker logs";
        "dkv"   = "docker volume";

        "kc"    = "kubectl";
        "kca"   = "kubectl apply";
        "kcar"  = "kubectl api-resources -o wide";
        "kcd"   = "kubectl describe";
        "kcdel" = "kubectl delete";
        "kce"   = "kubectl edit";
        "kcg"   = "kubectl get";
        "kcl"   = "kubectl logs";
        "kcns"  = "kubens";
        "kcp"   = "kubectl patch";
        "kcr"   = "kubectl rollout";
        "kctx"  = "kubectx";

        "sskc" = "starship toggle kubernetes disabled";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
