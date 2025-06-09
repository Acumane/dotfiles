# Help is available in home-manager.nix(5)

{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  
  home.username = "bren";
  home.homeDirectory = "/home/bren";

  home.packages = with pkgs; [
    adw-gtk3
    google-cursor
    papirus-icon-theme
    # papirus-folders
    # papirus-nord
    nerd-fonts.jetbrains-mono
    # (nerdfonts.override { fonts = [ "Hermit" ]; })
    # (writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    eza
    fd
    fzf
    sysz
    ripgrep
    ripgrep-all
    bat
    grc
    zoxide
    trash-cli
    xdg-utils
    file
    entr
    jq
    
    yt-dlp
    scrcpy
    mkvtoolnix
    exiftool
    docker-compose
    quickemu

  ];

  # Dotfiles
  home.file = {
    ".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };
    ".config/hypr".source = ./hypr;
    ".config/kitty".source = ./kitty;
    ".config/keyd/app.conf".source = ./keyd/app.conf;
    ".config/zsh/alias.zsh".source = ./zsh/alias.zsh;
    ".config/zsh/.zshrc".source = ./zsh/zshrc;
    ".config/gtk-4.0/gtk.css".source = ./gtk/gtk.css;

    ".local/bin/bt".source = ./scripts/bt;
    ".local/bin/batt".source = ./scripts/batt;
    ".local/bin/wm".source = ./scripts/wm;

    ".local/lib/hyprscroller.so".source = 
      "${pkgs.callPackage ./hypr/hyprscroller.nix {}}/lib/hyprscroller.so";
  };

  home.sessionVariables = rec {
    # EDITOR = "nvim";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Bren Paul";
    userEmail = "brenpaul@machindustries.com";
  };

  gtk = with pkgs; {
    enable = true;
    theme.name = "adw-gtk3-dark";
    iconTheme = {
      package = papirus-icon-theme;
      name = "Papirus-Dark";
    };
    cursorTheme = {
      package = google-cursor;
      name = "GoogleDot-Blue";
      size = 20;
    };
  };
  
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    music = "${config.home.homeDirectory}/audio";
    videos = "${config.home.homeDirectory}/media";
    pictures = "${config.home.homeDirectory}/img";
    download = "${config.home.homeDirectory}/dl";
    documents = "${config.home.homeDirectory}/docs";
    templates = null; desktop = null; publicShare = null;
  };
  
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "";
    };
    "org/gnome/nautilus/icon-view" = {
      captions = [ "size" ];
      default-zoom-level = "small-plus";
    };
    "org/gnome/nautilus/preferences" = {
      show-create-link = true;
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
    };
  };
  
  home.file.".config/gtk-3.0/bookmarks".text = ''
    file:///home/bren/dl Downloads
    file:///home/bren/nix Nix
  '';

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];
  };
  
  xdg.mimeApps.defaultApplications = {
    "text/*" = [ "cursor.desktop" ];
    "image/*" = [ "loupe.desktop" ];
    "video/*" = [ "mpv.desktop" ];
    "application/pdf" = [ "evince.desktop" ];
  };
  
  programs.zsh = {
    enable = true;
  };
}
