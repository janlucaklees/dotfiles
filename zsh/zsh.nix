{ config, pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  home.packages = with pkgs; [
    nix
    zsh
    eza
    bat
    ripgrep
    autojump
    fzf
  ] ++ lib.optionals isLinux [
    # Fonts are handled differently on macOS
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    material-symbols
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "strug";
      plugins = [ "git" "autojump" "fzf" ];
    };

    shellAliases = {
      cat = "bat";
      cap = "bat --plain";
      ls = "eza --group-directories-first";
      ll = "ls -l";
      la  = "ll -lah";
      cp = "cp -v";
      grep = "rg";

      gco = "git checkout";
      gls = "git status";
      gl = "git log --topo-order --stat";
      gap = "git add --patch";
      gd = "git diff";
      gdc = "git diff --cached";
      ggi = "git commit";
      ggia = "git commit --amend --no-edit";
      ggiae = "git commit --amend";
      ggiap = "git commit --amend --patch";
      ggip = "git commit --patch";
      gri = "git rebase --interactive";

      d = "docker";
      dc = "docker compose";
    } // lib.optionalAttrs isLinux {
      # Linux-only aliases
      sudo = "doas";
      sc = "sudo systemctl";
      scu = "systemctl --user";
    };

    initExtra = ''
      # key-bindings you added manually
      bindkey '^H' backward-kill-word
      bindkey '5~' kill-word

      # Ctrl-Z toggles suspend/resume
      function Resume {
        fg
        zle push-input
        BUFFER=""
        zle accept-line
      }
      zle -N Resume
      bindkey "^Z" Resume

      # Add bun to path if it exists
      [[ -d "$HOME/.cache/.bun/bin" ]] && export PATH="$HOME/.cache/.bun/bin:$PATH"

      # Add meteor to path if it exists
      [[ -d "$HOME/.meteor" ]] && export PATH="$HOME/.meteor:$PATH"

      # EDITOR for git, etc.
      export EDITOR="nvim"

      # Persist last visited directory for terminal launcher
      autoload -Uz add-zsh-hook
      _last_dir_file="''${XDG_CACHE_HOME:-$HOME/.cache}/terminal/last-dir"

      _save_cwd() {
        mkdir -p "''${_last_dir_file:h}" 2>/dev/null || return
        print -r -- "$PWD" >| "''${_last_dir_file}" 2>/dev/null || true
      }

      add-zsh-hook chpwd _save_cwd
    '';

    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      size = 10000;
      save = 10000;
    };
  };

  # xdg.configFile.".zshrc-custom".source = ./config/.zshrc-custom;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;  # pulls in the ^T, ^R, Alt-C bindings :contentReference[oaicite:0]{index=0}
  };

  programs.autojump = {
    enable = true;
    enableZshIntegration = true;  # auto-loads the shell hook :contentReference[oaicite:1]{index=1}
  };
}
