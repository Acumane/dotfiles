# Help is available in configuration.nix(5)

{ inputs, config, pkgs, lib, ... }:

{ 
  imports = [ 
    ./hardware.nix
    inputs.home-manager.nixosModules.home-manager
  ];
  
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
  
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.bren = import ./home.nix;
    # backupFileExtension = "backup";
    useGlobalPkgs = true;
  }; 
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "stilas"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.bren = {
      isNormalUser = true;
      description = "Bren";
      extraGroups = [ "networkmanager" "wheel" "keyd" ];
    };
  };

  # programs.rofi.enable = true;
  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  environment.etc = {
    "zshenv".source = lib.mkForce ./zsh/zshenv;
    "keyd/default.conf".source = lib.mkForce ./keyd/global.conf;
  };
  services.keyd.enable = true;
  systemd.services.keyd.restartIfChanged = true;

  systemd.user.services.keyd-application-mapper = {
    description = "Application-Specific mappings for keyd";
    documentation = [ "man:keyd-application-mapper" ];
    after = [ "graphical-session.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.keyd}/bin/keyd-application-mapper -d";
      Restart = "on-failure";
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    hyprland
    (callPackage ./hypr/hyprscroller.nix {})
    inputs.raise.defaultPackage.${system}
    rofi
    acpi
    # niri

    neovim
    vim
    kitty
    vscode
    code-cursor
    firefox
    keyd
    niri
    wget
    zsh

    plymouth

    wbg
    dunst
    swaybg
    wlsunset
    wlr-randr
    hyprpicker
    hypridle
    swayosd
    playerctl

    mpv
    loupe
    resources
    decibels
    evince
    papers

    go
    cargo
    python3
    cmake
    ninja
    gcc


    eza
    fd
    fzf
    ripgrep-all
    git
    git-lfs
    
    home-manager
  ];
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  system.stateVersion = "25.05";

}
