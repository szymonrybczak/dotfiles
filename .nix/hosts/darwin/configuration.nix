{ pkgs, ... }:

let
  constants = {
    username = "szymon";
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
      "sdkman/tap"
      "nikitabobko/tap"
    ];
    brews = [
      "n"
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
      "appcleaner"
      "cleanshot"
      "daisydisk"
      "discord"
      "fork"
      "ghostty"
      "google-chrome"
      "iina"
      "jordanbaird-ice"
      "latest"
      "minisim"
      "obsidian"
      "raycast"
      "spotify"
      "sublime-text"
      "the-unarchiver"
      "visual-studio-code"
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
    dock.tilesize = 36;
    dock.magnification = true;
    dock.largesize = 54;
    dock.show-process-indicators = true;
    dock.wvous-bl-corner = 1; # Disable
    dock.wvous-br-corner = 1;
    dock.wvous-tl-corner = 2; # Mission Control
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
    NSGlobalDomain.AppleEnableMouseSwipeNavigateWithScrolls = false;
    NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls = false;
    NSGlobalDomain.AppleScrollerPagingBehavior = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleShowScrollBars = "WhenScrolling";
    NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
    NSGlobalDomain.NSTableViewDefaultSizeMode = 2; # Medium sidebar icons
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain.InitialKeyRepeat = 15;
  };

  system.stateVersion = 6;
}
