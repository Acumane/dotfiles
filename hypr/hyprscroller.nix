{ pkgs }:

pkgs.callPackage ({ lib, fetchFromGitHub, cmake, hyprlandPlugins }:
  hyprlandPlugins.mkHyprlandPlugin pkgs.hyprland {
    pluginName = "hyprscroller";
    version = "master";
    src = fetchFromGitHub {
      owner = "nasirHo";
      repo = "hyprscroller";
      rev = "ccc2d1ebdcac04992e2fad2bf2540bb54da322dd"; # 0.49
      hash = "sha256-+e4BPjPIGD1pdSM0SujaN7ShWjJHM32OpSu+1eolkMY=";
    };
    nativeBuildInputs = [ cmake ];
    buildInputs = [];
    
    installPhase = ''
      mkdir -p $out/lib
      cp ./hyprscroller.so $out/lib/hyprscroller.so
    '';
    
    meta = {
      homepage = "https://github.com/nasirHo/hyprscroller";
      description = "Hyprland layout plugin providing a scrolling layout like PaperWM";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  }) {}
