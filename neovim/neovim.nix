{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    
    plugins = with pkgs.vimPlugins; [
      emmet-vim
      nord-nvim
    ];

    extraConfig = ''
      set autoindent expandtab tabstop=2 shiftwidth=2
      set number

      :inoremap <C-H> <C-W>

      " Enable Nord theme
      colorscheme nord
    '';
  };
}
