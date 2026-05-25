# Dotfiles

Personal dotfiles and NixOS configuration managed with:

- GNU Stow
- Nix Flakes
- NixOS
- Git


---

# Structure

```text
~/.dotfiles/
├── README.md
├── .stow-local-ignore
│
├── nvim/
│   └── .config/
│       └── nvim/
│
├── kitty/
│   └── .config/
│       └── kitty/
│
├── zsh/
│   ├── .zshrc
│   └── .zprofile
│
├── git/
│   └── .gitconfig
│
├── tmux/
│   └── .tmux.conf
│
└── nixos/
    ├── flake.nix
    ├── flake.lock
    ├── configuration.nix
    ├── hardware-configuration.nix
    └── modules/
```

Each directory mirrors the final filesystem layout relative to `$HOME`.

Example:

```text
nvim/.config/nvim
```

becomes:

```text
~/.config/nvim
```

through symlinks created by GNU Stow.

---

# Requirements

## Install GNU Stow

### NixOS

Add to your system packages:

```nix
environment.systemPackages = with pkgs; [
  stow
];
```

Then rebuild:

```bash
sudo nixos-rebuild switch
```

### Other Linux distros

```bash
sudo pacman -S stow
sudo apt install stow
sudo dnf install stow
```

---

# Clone Repository

```bash
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles
```

---

# GNU Stow Usage

## Symlink Configs

```bash
stow nvim
stow kitty
stow zsh
stow git
stow tmux
```

## Symlink Everything

```bash
stow */
```

---

# Remove Symlinks

```bash
stow -D zsh
```

---

# Restow

Useful after moving files or changing structure.

```bash
stow -R zsh
```

---

# Existing Configs

If configs already exist in `$HOME`, Stow will refuse to overwrite them.

You can either back them up manually:

```bash
mv ~/.zshrc ~/.zshrc.backup
```

or adopt them automatically:

```bash
stow --adopt zsh
```

This moves the existing files into the repository and replaces them with symlinks.

---

# Ignore Files

Optional `.stow-local-ignore`:

```text
\.git
README.md
```

---

# NixOS Configuration

System configuration is managed with Nix Flakes.

Example location:

```text
~/.dotfiles/nixos
```

---

# Enable Flakes

Add this to `/etc/nixos/configuration.nix`:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

Then rebuild:

```bash
sudo nixos-rebuild switch
```

---

# Rebuild System

From inside the `nixos/` directory:

```bash
cd ~/.dotfiles/nixos
sudo nixos-rebuild switch --flake .#hostname
```

Replace `hostname` with your actual system hostname.

Example:

```bash
sudo nixos-rebuild switch --flake .#thinkpad
```

---

# Update Flake Inputs

Update all inputs:

```bash
nix flake update
```

Update a specific input:

```bash
nix flake lock --update-input nixpkgs
```

Then rebuild:

```bash
sudo nixos-rebuild switch --flake .#hostname
```

---

# Flake Commands

## Show flake info

```bash
nix flake show
```

## Check flake

```bash
nix flake check
```

## Update lockfile

```bash
nix flake update
```

---

# Typical Workflow

## Update system

```bash
cd ~/.dotfiles/nixos

nix flake update

sudo nixos-rebuild switch --flake .#hostname
```

## Update dotfiles

```bash
cd ~/.dotfiles

git pull

stow */
```

---

# Git

## Commit changes

```bash
git add .
git commit -m "update configs"
git push
```

---

# Notes

- No Home Manager
- Portable across systems
- Minimal setup
- Symlink-based workflow
- NixOS system config separated from user config
- Works on Linux and macOS

