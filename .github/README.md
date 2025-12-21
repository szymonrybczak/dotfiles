# dotfiles

This repo is managed using a git bare repository.

## Quick Setup (New Mac)

```bash
# 1. Install Lix (Nix package manager)
curl -sSf -L https://install.lix.systems/lix | sh -s -- install

# 2. Clone dotfiles as bare repo
echo ".dot.git" >> ~/.gitignore
git clone --bare git@github.com:szymonrybczak/new-dotfiles.git $HOME/.dot.git
alias dot="git --git-dir=$HOME/.dot.git/ --work-tree=$HOME"
dot config --local status.showUntrackedFiles no

# 3. Checkout dotfiles (backup any conflicting files first)
dot checkout

# 4. Restart your terminal, then build the system
nix-rebuild

# 5. Install tmux plugins
# Open tmux and press: Ctrl+Space then I

# 6. Open neovim to install plugins
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
