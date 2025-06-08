# Help is available in home-manager.nix(5)

{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  
  home.username = "bren";
  home.homeDirectory = "/home/bren";

  home.packages = with pkgs; [
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Dotfiles
  home.file = {
    ".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };
  };
  

  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];
  };

}


