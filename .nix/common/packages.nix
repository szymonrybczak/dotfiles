{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    nixd
    nixfmt-rfc-style
    lua-language-server
    stylua
    typescript-language-server
    nodejs
    gcc
    nano
    neovim
    wget
    git
    git-extras
    git-lfs
    git-delta # for better git diffs
    gitmux
    tmux
    tree
    btop # activity monitor
    jq # json parser
    fd # find replacement
    fzf # fuzzy finder
    zoxide # cd replacement
    bat # cat replacement
    yazi # file manager
    ncdu # disk usage
    hyperfine # benchmarking tool
    lazydocker
    lazygit # git TUI
    imagemagick
    ffmpeg
    termsvg
    ripgrep # fast grep replacement
    cmake
    ninja
    coreutils
    curl
    stow # for dotfile management if needed
  ];
}
