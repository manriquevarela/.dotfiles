# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Enable full GPU hardware video acceleration.
  # This offloads video decoding from the CPU to the integrated graphics.
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # Modern driver for media playback (QuickSync / VA-API)
      intel-vaapi-driver # Legacy fallback driver required by some web browsers
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # Automatically turn on Bluetooth when the system boots
  };

  # Force applications to use the modern Intel driver for video decoding.
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  boot = {

    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Fix 13th Gen Intel sleep/wake and idle power hangs.
    # - s2idle: Prevents deep sleep states that the CPU cannot wake up from.
    # - max_cstate=4: Limits power-saving states to stop random wake freezes.
    kernelParams = [
      "mem_sleep_default=s2idle"
      "intel_idle.max_cstate=4"
    ];
    # Force Intel graphics driver to load at the very beginning of boot.
    # This prevents the display manager (login screen) from timing out.
    initrd.kernelModules = [ "i915" ];

    # Use the latest Linux kernel.
    # Essential for 13th Gen hardware stability and power management updates.
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {

    hostName = "nixos"; # Define your hostname.

    # Enable networking
    # Keep NetworkManager enabled for your KDE panel widget
    networkmanager.enable = true;

    # Tell NetworkManager to use iwd instead of wpa_supplicant
    networkmanager.wifi.backend = "iwd";

    # Enable the iwd daemon itself so NetworkManager can talk to it
    wireless.iwd = {
      enable = true;
      settings = {
        Settings = {
          AutoConnect = true;
        };
      };
    };
  };

  # Set your time zone.
  time.timeZone = "America/Costa_Rica";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CR.UTF-8";
    LC_IDENTIFICATION = "es_CR.UTF-8";
    LC_MEASUREMENT = "es_CR.UTF-8";
    LC_MONETARY = "es_CR.UTF-8";
    LC_NAME = "es_CR.UTF-8";
    LC_NUMERIC = "es_CR.UTF-8";
    LC_PAPER = "es_CR.UTF-8";
    LC_TELEPHONE = "es_CR.UTF-8";
    LC_TIME = "es_CR.UTF-8";
  };

  services = {

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    # xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    # displayManager.sddm.enable = true;
    displayManager.plasma-login-manager.enable = true;
    desktopManager.plasma6.enable = true;

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  security.rtkit.enable = true;

  users.users.manrique = {
    isNormalUser = true;
    description = "manrique";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  programs = {

    # Install firefox.
    firefox.enable = true;

    git = {
      enable = true;
      config = {
        user = {
          name = "manrique";
          email = "manrique.varela@gmail.com";
        };

      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # -- apps
    kdePackages.ktorrent

    # ---
    stow
    neovim
    kitty
    google-chrome
    brave
    webex
    citrix_workspace

    # --- LazyVim Runtime & Compiler Dependencies ---
    git # Required for partial clones and updates
    curl # Required for completion engines (e.g., blink.cmp)
    gcc # C compiler required by nvim-treesitter
    gnumake # Build utility for nvim-treesitter and other tools
    unzip # Required for unpacking plugins
    tree-sitter
    tree-sitter-grammars.tree-sitter-java
    tree-sitter-grammars.tree-sitter-nix
    tree-sitter-grammars.tree-sitter-lua
    tree-sitter-grammars.tree-sitter-javascript
    tree-sitter-grammars.tree-sitter-typescript
    tree-sitter-grammars.tree-sitter-tsx
    tree-sitter-grammars.tree-sitter-regex

    # --- Recommended CLI Tools & LSPs ---
    fzf # General fuzzy finding
    ripgrep # Live grep in telescope
    fd # Fast file searching
    lazygit # Git TUI integration
    nodejs # Many LSPs (tsserver, etc.) rely on Node.js
    python3 # Python environment for Python-based LSPs/plugins
    python312Packages.pynvim # Python provider for neovim

    # LSP
    lua-language-server
    nil
    typescript-language-server
    bash-language-server
    vscode-langservers-extracted

    # Formatters
    alejandra # nix
    statix
    beautysh

    lazygit
    fzf
    zoxide
    bat
    eza
    tmux

  ];

  nixpkgs.config.permittedInsecurePackages = [
    # citrix_workspace:
    "libsoup-2.74.3"
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  system.stateVersion = "25.11";
}
