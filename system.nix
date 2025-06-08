# Help is available in configuration.nix(5)

{ inputs, config, pkgs, ... }:

{ 
  imports = [ 
    ./hardware.nix
    inputs.home-manager.nixosModules.home-manager
  ];
  
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.bren = import ./home.nix;
    
    useGlobalPkgs = true;
  }; 

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-14153b07-d8ae-47e3-b230-2111db354065".device = "/dev/disk/by-uuid/14153b07-d8ae-47e3-b230-2111db354065";
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

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  services.keyd.enable = true;
 
  
  services.keyd.keyboards.default = {
    ids = ["*"];
    extraConfig = import ./keyd/global.nix;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
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
    
    wbg
    wlsunset
    
    mpv
    loupe
    resources

    eza
    fd
    fzf
    ripgrep-all
    git
    
    home-manager
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  system.stateVersion = "25.05";

}
