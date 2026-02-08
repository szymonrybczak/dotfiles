# dotfiles

This repo is managed using a git bare repository.

## Quick Setup (New Mac)

```bash
# 1. Install Lix (Nix package manager)
curl -sSf -L https://install.lix.systems/lix | sh -s -- install

# 2. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Clone dotfiles as bare repo
echo ".dot.git" >> ~/.gitignore
git clone --bare git@github.com:szymonrybczak/new-dotfiles.git $HOME/.dot.git
alias dot="git --git-dir=$HOME/.dot.git/ --work-tree=$HOME"
dot config --local status.showUntrackedFiles no

# 4. Checkout dotfiles (backup any conflicting files first)
dot checkout

# 5. Restart your terminal, then build the system (first time)
sudo nix run nix-darwin/nix-darwin-25.11 -- switch --flake ~/.nix#default
# After this, you can use `nix-rebuild` for future rebuilds

# 6. Install tmux plugins
# Open tmux and press: Ctrl+Space then I

# 7. Open neovim to install plugins
nvim
```

## Managing Dotfiles

The `dot` alias works like `git` but for your dotfiles:

```bash
# Check status
dot status

# Add a file
dot add ~/.config/some-config

# Commit changes
dot commit -m "update config"

# Push to remote
dot push
```

## Rebuilding System

After making changes to nix configuration:

```bash
nix-rebuild
```

This will:

- Install/remove packages as defined in `.nix/`
- Apply macOS system defaults
- Install Homebrew casks
- Update fonts

## Setting Up GPG (for commit signing)

```bash
# Generate a new GPG key
gpg --full-generate-key
# Choose: RSA and RSA, 4096 bits, your name and email

# Get your key ID
gpg --list-secret-keys --keyid-format=long
# Look for: sec rsa4096/ABCD1234EFGH5678

# Update .gitconfig with your key ID
# Then enable signing:
git config --global commit.gpgsign true
git config --global tag.gpgSign true

# Export public key for GitHub
gpg --armor --export YOUR_KEY_ID
# Add this to GitHub: Settings → SSH and GPG keys → New GPG key
```

## Directory Structure

```
$HOME/
├── .dot.git/                    # Bare git repo (hidden)
├── .nix/
│   ├── flake.nix               # Nix flake entry point
│   ├── flake.lock              # Locked package versions
│   ├── hosts/darwin/           # macOS-specific config
│   └── common/                 # Shared nix configs
├── .config/
│   ├── aerospace/              # Window manager
│   ├── ghostty/                # Terminal
│   ├── tmux/                   # Terminal multiplexer
│   ├── nvim/                   # Neovim config
│   └── zed/                    # Zed editor
├── .gitconfig                  # Git configuration
├── .zshrc                      # Shell configuration
└── .zprofile                   # Shell profile
```

## What's Included

### Apps (via Homebrew casks)

- 1Password, Raycast, Ghostty, Google Chrome
- Fork, VS Code, Sublime Text, Discord, Spotify, IINA
- Obsidian, CleanShot, DaisyDisk, AppCleaner
- Ice, Latest, MiniSim, The Unarchiver

### CLI Tools (via Nix)

- neovim, tmux, git, lazygit, ripgrep
- fzf, fd, bat, zoxide, yazi
- nodejs, cmake, ninja, gcc
- and more...

### Shell

- Zsh with Spaceship prompt
- fzf-tab, syntax highlighting, autosuggestions
- `n` for Node.js version management
- `rbenv` for Ruby version management
- `sdkman` for Java/Kotlin SDKs

---

## Manual Installs

These apps need to be installed manually (not available via Homebrew or require licenses):

### From Web (Direct Download)

- **Cursor** - https://cursor.sh (AI code editor)
- **Docker Desktop** - https://www.docker.com/products/docker-desktop
- **Karabiner-Elements** - https://karabiner-elements.pqrs.org (keyboard customization)
- **Klack** - https://tryklack.com (mechanical keyboard sounds)
- **Numi** - https://numi.app (calculator)
- **Screen Studio** - https://www.screen.studio (screen recording)
- **SelfControl** - https://selfcontrolapp.com (website blocker)
- **Slack** - https://slack.com
- **TablePlus** - https://tableplus.com (database GUI)
- **Wispr Flow** - https://www.wispr.ai (voice dictation)

### Other/Optional

- **KeyCastr** - Show keystrokes on screen (for screencasts)
- **Raindrop.io** - Bookmark manager
