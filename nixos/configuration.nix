# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sdb";
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.

  nix.extraOptions = ''
   binary-caches-parallel-connections = 1
  '';
  
  #haskell
  nix.binaryCaches = [ https://cache.nixos.org/ http://hydra.nixos.org/ http://hydra.cryp.to/ ];
  nix.trustedBinaryCaches = [ "http://hydra.nixos.org" "http://hydra.cryp.to" ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.hostId = "a671cc0d";
  #networking.wireless.enable = true;  # Enables wireless.
  networking.networkmanager.enable = true;
  services.dbus.enable = true;  

  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "de";
    defaultLocale = "de_DE.UTF-8";
  };

  nixpkgs.config.allowUnfree = true;

  # test
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    #haskellPackages.purescript    
    haskellPackages.yi
    xlibs.xev
    kde4.ktorrent
    #automake
    #gnumake
    #sbcl
    #ruby_2_2_0
    #chibi
    #leksah
    sqlite
    wireshark
    vimPlugins.vim-addon-syntax-checker
    vimPlugins.vimshell
    vimPlugins.idris-vim
    vimPlugins.pathogen
    gnome3.nautilus
    kde4.ksnapshot
    imagemagick
    youtube-dl
    maven
    idea.idea-community
    vlc
    #haskellPackages.regexBase
    #haskellPackages.regexPcre
    #haskellPackages.HTTP    
    #haskellPackages.regexPosix
    #haskellPackages.yesod
    #haskellPackages.text
    #haskellPackages.persistent
    #haskellPackages.persistentSqlite
    #haskellPackages.persistentPostgresql
    #haskellPackages.transformersBase
    #haskellPackages.resourcet
    #haskellPackages.monadLogger
    pwgen
    #eclipses.eclipse_sdk_431
    eclipses.eclipse_sdk_442
    #haskellPackages.purescript
    #haskellPackages.cabal2nix
    #haskellPackages.idris
    nodejs
    #opam
    #ocaml
    #ocamlPackages.ocaml_pcre
    #ocamlPackages.utop
    kde4.kdegraphics_thumbnailers
    #haskellPackages.ghc
    #haskellPackages.cabalInstall
    unzip
    gnum4
    kde4.okular
    kde4.ark
    lighttable
    #findutils
    #haskellPackages.xmonad
    #wpa_supplicant_gui
    vim
    wget
    chromium
    networkmanager
    networkmanagerapplet
    emacs
    xlibs.xmodmap
    firefox
    thunderbird
    gnupg
    zsh
    lynx
    #mysql
    #mysqlWorkbench
    oraclejdk8
    pgadmin  
    gitAndTools.gitFull
    postgresql94
    leiningen
    kde4.yakuake
    
  ];

  # List services that you want to enable:

  services.virtualboxHost.enable = true;
  users.extraGroups.vboxusers.members = [ "markus" ];  

  services.locate.enable = true;
  services.locate.period = "33 7 * * *";

  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql93;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "de";
  services.xserver.xkbOptions = "eurosign:e";

  #group networkmanager
  services.xserver.windowManager.icewm.enable = true;
  services.xserver.windowManager.xmonad.enable = true;     # installs xmonad and makes it available
  #services.xserver.windowManager.xmonad.enableContribAndExtras = true; # makes xmonad-contrib and xmonad-extras available
  #services.xserver.windowManager.default       = "xmonad"; # sets it as default
  #services.xserver.desktopManager.default      = "none";   # the plain xmonad experience
  services.xserver.windowManager.default = "icewm";

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.kdm.enable = true;
  services.xserver.desktopManager.kde4.enable = true;  
  
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.xfce.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.guest = {
    isNormalUser = true;
    uid = 1000;
    name = "markus";
    group = "users";
    extraGroups = ["wheel" "networkmanager"];
    createHome = true;
    home = "/home/markus";
  };

}
