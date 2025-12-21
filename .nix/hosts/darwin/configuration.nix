{ pkgs, ... }:

let
  constants = {
    username = "szymonrybczak";
  };
in
{
  imports = [
    ../../common/nix.nix
    ../../common/packages.nix
  ];

  system.primaryUser = "${constants.username}";

  environment.systemPackages = with pkgs; [
    gnupg
    pinentry_mac # gpg agent
    scrcpy # android screen mirroring
    watchman
    ccache
    idb-companion
    xcbeautify
    cloudflared
    yt-dlp
    podman
    podman-compose
    vfkit # needed for podman
    gh
  ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap"; # remove brews not in the list
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    taps = [
      "oven-sh/bun"
      "sdkman/tap"
      "nikitabobko/tap"
    ];
    brews = [
      "bun"
      "n"
      "opencode"
      "pnpm"
      "yarn"
      "sdkman-cli"
      "rbenv"
      "ruby-build"
      "cocoapods"
      "xcode-build-server"
      "wifi-password"
    ];
    casks = [
      "1password"
      "aerospace"
      "android-studio"
      "appcleaner"
      "cleanshot"
      "daisydisk"
      "discord"
      "fork"
      "ghostty"
      "google-chrome"
      "iina"
      "jordanbaird-ice"
      "karabiner-elements"
      "latest"
      "minisim"
      "obsidian"
      "raycast"
      "spotify"
      "sublime-text"
      "the-unarchiver"
      "visual-studio-code"
      "zed"
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  programs.zsh.enable = true;

  security.pam.services.sudo_local = {
    touchIdAuth = true;
  };

  system.defaults = {
    dock.autohide = true;
    dock.mineffect = "scale";
    dock.minimize-to-application = true;
    dock.mru-spaces = false;
    dock.tilesize = 48;
    dock.magnification = true;
    dock.largesize = 64;
    dock.show-process-indicators = true;
    dock.wvous-bl-corner = 1; # Disable
    dock.wvous-br-corner = 1;
    dock.wvous-tl-corner = 1; # Disable
    dock.wvous-tr-corner = 1;
    finder.AppleShowAllExtensions = true;
    finder.FXDefaultSearchScope = "SCcf"; # Search current folder
    finder.FXEnableExtensionChangeWarning = false;
    finder.FXRemoveOldTrashItems = true;
    finder.FXPreferredViewStyle = "Nlsv"; # List view
    finder.NewWindowTarget = "Home";
    finder.ShowPathbar = true;
    magicmouse.MouseButtonMode = "TwoButton";
    menuExtraClock.Show24Hour = false; # 12-hour clock
    menuExtraClock.ShowDate = 0; # Show date when space is available
    screencapture.location = "~/Desktop";
    spaces.spans-displays = false;
    trackpad.Clicking = true;
    WindowManager.EnableStandardClickToShowDesktop = false;
    WindowManager.EnableTiledWindowMargins = false;
    WindowManager.EnableTilingByEdgeDrag = true;
    WindowManager.EnableTopTilingByEdgeDrag = true;
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
    NSGlobalDomain.AppleEnableMouseSwipeNavigateWithScrolls = true;
    NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls = true;
    NSGlobalDomain.AppleScrollerPagingBehavior = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleShowScrollBars = "WhenScrolling";
    NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
    NSGlobalDomain.NSTableViewDefaultSizeMode = 2; # Medium sidebar icons
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain.InitialKeyRepeat = 15;
  };

  # Clear default apps from Dock on activation
  system.activationScripts.postActivation.text = ''
    # Remove all persistent apps from Dock
    defaults write com.apple.dock persistent-apps -array
    killall Dock || true
  '';

  system.stateVersion = 6;
}
