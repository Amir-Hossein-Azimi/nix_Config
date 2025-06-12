# welcome to my config, i am amir.

{ config, pkgs, lib, 

# if you enabled stable repo in flakes
#pkgs-stable, 

inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

####################################################
# New Install Guide:
#
# switch to unstable branch before anything
# sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
# sudo nix-channel --update && sudo nixos-rebuild switch --upgrade
#
# json to nix
# https://github.com/uncenter/json-to-nix
#
# always make sure to check this for boot delay
# sudo systemd-analyze blame
#
# nixos options
# https://search.nixos.org/options
#
# for inspiration, in github search: "language:nix the-term-you-are-looking-for"
#####################################################
#####################################################
# program and services

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
 
  # nix gc
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 7d";
  nix.gc.persistent = true;
  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;

  # nix channel
  nix.channel.enable = false;

## gaming:
# steam options:
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
    extraPkgs = pkgs: with pkgs; [
      gamescope
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
#            (writeShellScriptBin "launch-gamescope" ''
#              if [ -z "$WAYLAND_DISPLAY" ]; then
#                exec nice -n -11 -- gamescope "$@"
#              else
#                exec env LD_PRELOAD="" nice -n -11 -- gamescope "$@"
#              fi
#            '')
    ];
  };
  extest.enable = true;
  protontricks.enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];

# steam gamescope:
# gotta manually add (yes, i log errors, lol):
# gamemoderun gamescope --hdr-enabled --adaptive-sync -r 120 -W 1920 -H 1080 --expose-wayland --backend wayland --hdr-itm-enable --fullscreen -- %command% &> ~/lol.txt
   gamescopeSession = {
	enable = true;
	env = {
      ENABLE_HDR_WSI = "1";
      DXVK_HDR = "1";
      ENABLE_GAMESCOPE_WSI = "1";
      WLR_RENDERER = "vulkan";
      LD_PRELOAD = "";
    };
};
};


# steam gamescope seem to HATE this, thus, ba bai...
#programs.gamescope = {
#     enable = true;
#     capSysNice = true;
#};

#programs.gamemode = {
#	 enable = true;
#	settings = {
# https://man.archlinux.org/man/extra/gamemode/gamemoded.8.en
#  general = {
#    renice = 10;
#  };

#  # Warning: GPU optimisations have the potential to damage hardware
#  gpu = {
#    apply_gpu_optimisations = "accept-responsibility";
#    gpu_device = 1;
#  };

#  custom = {
#    start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
#    end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
#
#  };
#};
#};

#   boot.kernel.sysctl = {
#     "vm.max_map_count" = 2147483642;
#   };

#   security.pam.loginLimits = [
#     {
#       domain = "*";
#       type = "soft";
#       item = "memlock";
#       value = "unlimited";
#     }
#   ];

## virtualization:
# waydroid - horrible with most google play stuff not working fine.
#  virtualisation.waydroid.enable = true;

# virt-manager
#   virtualisation.libvirtd.enable = true;
#   programs.virt-manager.enable = true;

#  # docker, unneeded boot delay
#    virtualisation.docker = {
#    enable = true;
#    enableNvidia = true;
#  };

#  hardware.nvidia-container-toolkit.enable = true;
#  virtualisation.docker.storageDriver = "btrfs";
#  virtualisation.docker.daemon.settings = {
#  data-root = "/run/media/amir/Games/docker-chan/";
#};

#  virtualisation.docker.rootless = {
#  enable = true;
#  setSocketVariable = true;
#};

## programs:
  # enable binaries
  programs.nix-ld.enable = true;
#  services.envfs.enable = true;

  # enable appimage
#  programs.appimage = {
#  enable = true;
#  binfmt = true;
#};

  # dependency for binaries
#  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages

#  ];

   #enable flatpak service
#   services.flatpak.enable = true;
#   xdg.portal.enable = true;
#  services.flatpak.uninstallUnmanaged = true;
#  services.flatpak.update.onActivation = true;
#  services.flatpak.update.auto = {
#     enable = true;
#     onCalendar = "daily"; # Default value
#  };

#  services.flatpak.packages = [
#    { appId = "moe.launcher.an-anime-game-launcher"; origin = "launcher-moe";  }
#    { appId = "moe.launcher.the-honkers-railway-launcher"; origin = "launcher-moe";  }
#    { appId = "com.usebottles.bottles"; origin = "flathub";  }
#    https://flathub.org/apps/io.github.flattool.Warehouse
#    "com.valvesoftware.Steam.CompatibilityTool.Proton-GE"
#    "io.github.kukuruzka165.materialgram"
#    "org.yuzu_emu.yuzu"
#    "com.github.tchx84.Flatseal"
#    ];

#  services.flatpak.overrides = {
#    "net.lutris.Lutris".Context = {filesystems = [ "/run/media/amir/Games/" ];};
#    "com.valvesoftware.Steam".Context = {filesystems = [ "/run/media/amir/Games/" ];};
#    "org.yuzu_emu.yuzu".Context = {filesystems = [ "/run/media/amir/Games/" "/home/amir/Desktop/" ];};
#    "moe.launcher.the-honkers-railway-launcher".Context = {filesystems = [ "/run/media/amir/Games/" ];};
#    "io.github.kukuruzka165.materialgram".Context = {filesystems = [ "/home/amir" ];};
#    "moe.launcher.an-anime-game-launcher".Context = {filesystems = [ "/run/media/amir/Games/" ];};
#};

#	services.flatpak.remotes = [
#	  {name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";}
#	  {name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo";}
#	  {name = "fedora-testing"; location = "oci+https://registry.fedoraproject.org#testing";}
#	  {name = "fedora"; location = "oci+https://registry.fedoraproject.org";}
#	  {name = "elementary"; location = "https://flatpak.elementary.io/repo.flatpakrepo";}
#	  {name = "gnome-nightly"; location = "https://nightly.gnome.org/gnome-nightly.flatpakrepo";}
#	  {name = "launcher-moe"; location = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo";}
#	];

# system packages
# List packages installed in system profile. To search, run:
# $ nix search package
  environment.systemPackages = with pkgs; [
# official repo search:
# https://search.nixos.org/ 
xorg.libXt
xorg.libX11


neohtop

wget # i search for it

# gnome
dconf-editor
desktop-file-utils
#kde
kdePackages.okular
kdePackages.konsole
qalculate-qt

# sddm
sddm-sugar-dark #sddm theme
libsForQt5.qt5.qtgraphicaleffects 
libsForQt5.qt5.qtquickcontrols2

#### cheatsheet, use ai instead
#cht-sh
#tldr

#### gaming
steam-run
heroic
#suyu
#torzu
steamtinkerlaunch
love
#ryujinx-greemdev
protontricks
prismlauncher
protonup-qt
dxvk
winetricks
wineWowPackages.unstableFull
gamescope
mcontrolcenter
#lutris
#shattered-pixel-dungeon
#shorter-pixel-dungeon
#tower-pixel-dungeon
#rkpd2

####
#### media
#suwayomi-server
#libreoffice
ani-cli
#stremio
mpv-shim-default-shaders
#smplayer - didn't worked in wayland
#qmplay2 - needs to compile, weird.
upscayl
imagemagickBig
mpv
ffmpeg-full
kdePackages.gwenview

# compression
unrar-wrapper
p7zip

####
## android tools
  android-tools
  libarchive
  android-udev-rules
  scrcpy

## wifi stuff
#  cowpatty
#  aircrack-ng
#  wirelesstools
#  bettercap
#  hashcat
#  airgeddon
#  wifite2
#  wpa_supplicant
#  pixiewps
#  iw
#  pciutils
#  crunch
#  mdk4
#  hostapd
#  lighttpd
#  hcxdumptool
#  ettercap
#  wireshark
#  dnsmasq
#  reaverwps
#  tcpdump
#  bully
#  asleap
#  john
#  hcxtools
########
#### vpn stuff
   pptp
   nekoray
   openvpn
   networkmanager-openvpn
  #sing-box
  #hiddify-app
  #libreswan
  #warp-plus
  #proxychains-ng
  wg-netmanager
  #sing-geoip
  #protonvpn-cli
  #v2rayn

####
#### web stuff
#wget
motrix
httping
aria
#proton-pass
#ungoogled-chromium
google-chrome
mumble
ayugram-desktop
#rclone
speedtest-go
git
curl
flatpak
sshpass
#cloudflared
ntfs3g
usbutils
gparted
exfatprogs
####
#### programing
  #python3

   #.....
  vscodium-fhs
  conda
  #bun
  #gcc
  #git-lfs
  nodejs
  #deno
  #aider-chat-full

#### appimage stuff
#gearlever

#### idk
fortune
pokemonsay
lolcat
tree
btop 
nvtopPackages.full
kdePackages.kate
#ventoy-full
#ventoy-full-qt
fastfetch
nemo-with-extensions
obsidian

#######################
# nur repo:
# https://nur.nix-community.org/
#######################
#nur.repos.novel2430.zen-browser-bin

########################
# flake stuff
########################
#inputs.elyprism.packages.${system}.default


################################################
# stable repo separation because i said so
################################################
#pkgs-stable.libreoffice
libreoffice
];


#####################################################
#####################################################
# services / systemd

  # Enablse touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
    hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };

# cloudflare
services.cloudflare-warp.enable = true;

# power profiles
services.power-profiles-daemon.enable = true;


#  systemd.services.warp-plus = {
#    description = "Warp Plus Service";
#    after = [ "network.target" ];
#    wantedBy = [ "multi-user.target" ];
#    serviceConfig = {
#      Type = "simple";
#      ExecStart = "{inputs.warp-plus}/warp-plus -b 127.0.0.1:2080 --scan";
#    };
#  };

 # podman
#    virtualisation = {
#     podman = {
#      enable = true;
#
#      # Create a `docker` alias for podman, to use it as a drop-in replacement
#      dockerCompat = true;
#
#      # Required for containers under podman-compose to be able to talk to each other.
#      defaultNetwork.settings.dns_enabled = true;
#    };
#  };

###

###### auto mount: bug: because after use it sleep had problem

#  fileSystems = {
 #   "/run/media/amir/Games" = {
 #     device = "/dev/sda3";
 #     fsType = "ntfs";
 #     options = [ "defaults" "noauto" "x-systemd.automount" ];
 #    mountPoint = "/run/media/amir/Games";
 #   };
 # };

services.devmon.enable = true;
services.gvfs.enable = true; 
services.udisks2.enable = true;

####################################################
####################################################
# fonts:

fonts.packages = with pkgs; [
  noto-fonts
  nerd-fonts.symbols-only
#  font-awesome
  nerd-fonts.fira-code
  nerd-fonts.droid-sans-mono
#  material-icons     # Google's Material Design icons
#  material-design-icons
  noto-fonts-cjk-sans
  noto-fonts-emoji
#  powerline-fonts
#  powerline-symbols
#  liberation_ttf
#  fira-code
#  fira-code-symbols
#  mplus-outline-fonts.githubRelease
#  google-fonts
#  vazir-fonts
#  dina-font
#  proggyfonts
];

#####################################################
######################################################
# nvidia related settings

  # cuda support
#  nixpkgs.config.cudaSupport = true;
#  programs.nix-required-mounts.presets.nvidia-gpu.enable = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  # nvidia pipeline
  #hardware.nvidia.forceFullCompositionPipeline = true;

    hardware.graphics = {
    enable = true;
    # needed by nvidia-docker
    enable32Bit = true;
  };

  # nvidia driver
##  boot.kernelParams = [
## "module_blacklist=i915"
## "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
## "nvidia-drm.fbdev=1"
## "binder_linux.devices=binder,hwbinder,vndbinder"];

#  boot.kernelModules = [
#    "binder_linux"
#    "ashmem_linux"
#    "memfd"
#  ];
#  boot.extraModulePackages = with config.boot.kernelPackages; [
    # Add any extra module packages here
#  ];

 boot.initrd.kernelModules = [ "nvidia" ];
 services.xserver.videoDrivers = ["nvidia"];
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    nvidiaSettings = true;
    prime = {
	offload = {
	enable = true;
	enableOffloadCmd = true;
	};
#        # Make sure to use the correct Bus ID values for your system!
		intelBusId = "PCI:0:2:0";
		nvidiaBusId = "PCI:1:0:0";
                # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
	};
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

#####################################################
#####################################################
# networking

   #services.openvpn.servers = {
    #myVPN = {
      #config = ''
        #config /home/amir/Downloads/SirjanConf/Sirjan.ovpn
        #auth-user-pass /home/amir/Downloads/SirjanConf/Sirjan.cred
        #verb 9
      #'';
     # autoStart = false;
    #};
  #};
  networking.networkmanager = {
   enable = true;
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.wifi.macAddress = "random";
  networking.networkmanager.wifi.powersave = false;
  # networking.firewall.allowedUDPPorts = [ 16000 ];

  # Configure network proxy if necessary
  #networking.proxy.default = "127.0.0.1:2080";
  #networking.proxy.noProxy = "localhost, 127.0.0.0/8, ::1";



  networking.nameservers = [
  #"1.1.1.1"
#  "1.0.0.1"
  #"8.8.8.8"
#  "8.8.4.4"
];

  #tor
#  services.tor.enable = true;
#  services.tor.client.enable = true;

  # proxychains:
#  programs.proxychains.proxies = { myproxy =
#  { type = "socks4";
#    host = "127.0.0.1";
#    port = 9050;
#  };
#};

  # add crt manually
#  security.pki.certificateFiles =["${pkgs.cacert}/home/amir/Public/mitmproxy-ca-cert.crt"];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall = {
  enable = true;
  allowedTCPPorts = [ 1723 ];       # PPTP control port
  allowedUDPPorts = [ ];
  extraCommands = ''
    iptables -A INPUT -p gre -j ACCEPT
  '';
};
  #services.sing-box.enable = true;
  #services.xray.enable = true;

#####################################################
#####################################################
# audio related settings

  # Enable sound with pipewire.
  # sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    #alsa.enable = true;
    #alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.pipewire.wireplumber.extraConfig."11-bluetooth-policy" = {
    "wireplumber.settings" = {
      "bluetooth.autoswitch-to-headset-profile" = false;
    };
  };


  system.stateVersion = "25.05"; # Did you read the comment?

################################################
################################################
# home-manager/user related/configs

  # Define a user account. Don't foget to set a password with ‘passwd’.
  users.users.amir = {
    isNormalUser = true;
    description = "amirhossein";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker"];
    shell = pkgs.fish;
    packages = with pkgs; [
    #kate
    #thunderbird
    ];
  };


  # stylix
  stylix = { 
enable = true;
base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
cursor.name = "Sweet-cursors";
cursor.package = pkgs.sweet-nova;
cursor.size = 24;
fonts.monospace = { package = pkgs.dejavu_fonts; name = "DejaVu Sans Mono"; };
fonts.sansSerif = { package = pkgs.open-sans; name = "Open Sans"; };
fonts.serif = { package = pkgs.dejavu_fonts; name = "DejaVu Serif"; };
fonts.emoji = { package = pkgs.noto-fonts-color-emoji; name = "Noto Color Emoji"; };
polarity = "dark";
image = pkgs.fetchurl {
    url = "https://4kwallpapers.com/images/wallpapers/super-saiyan-goku-3840x2160-13279.jpg";
    hash = "sha256-+mVkk3wQ61Vab6lGE71wvtzeIt7ZboWN+oDEiF6TR7c=";
 };
 #https://www.pixelstalk.net/wp-content/uploads/image12/A-tranquil-anime-cityscape-wallpaper-with-simple-shapes-and-a-muted-calming-color-palette.jpg
 #sha256-RHdg4aKmLgFL1jn84KjjeERg2LOPQIQSCgimD+j5+t4=
#for download from internet and cache
enableReleaseChecks = false;

targets.qt.enable = false;


};


# Enable the Flakes feature and the accompanying new nix command-line tool
nix.settings.experimental-features = [ "nix-command" "flakes" ];


# disable useless helpers
documentation.dev.enable = false;
documentation.man = {
  man-db.enable = false;
  mandoc.enable = false;
};
programs.command-not-found.enable = false;

# pokemon in my shell:
#environment.shellInit = "fortune | pokemonsay -t --no-name";

##############################################################
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  programs.xwayland.enable = true;

  #kde
  services.desktopManager.plasma6.enable = true;
 # services.xserver.desktopManager.plasma5.enable = true;



  environment.plasma6.excludePackages = with pkgs.kdePackages; [
   plasma-browser-integration
   konsole
   elisa
   dolphin
   khelpcenter
   kinfocenter
   discover
   kwalletmanager
];



  # login manager
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  #uncomment for kde 6
  services.displayManager.sddm.extraPackages = [ pkgs.sddm-astronaut ];
  services.displayManager.sddm.theme = "${pkgs.sddm-astronaut}/share/sddm/themes/sddm-astronaut-theme";

  programs.dconf.enable = true;

  # Enable automatic login for the user.
  #services.displayManager.autoLogin.enable = false;
  #services.displayManager.autoLogin.user = "amir";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
 # systemd.services."getty@tty1".enable = true;
 # systemd.services."autovt@tty1".enable = true;


#################################################################

  # Optional but good practice: Ensure Polkit service is enabled
  # security.polkit.enable = true;




 # fish shell
  programs.fish.enable = true;
  programs.fish.useBabelfish = true;


  nix.settings.trusted-users = [ "root" "amir" ];

# regional settings

  # Set your time zone.
  time.timeZone = "Asia/Tehran";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # environment related stuff

### keyboard
# Configure keymap in X11
services.xserver.xkb = {
  layout   = "us,ir";
  variant  = "";
  options  = "grp:alt_shift_toggle";
};


### add to shell to make cuda work for binaries
    environment.variables = {
    #CUDA_PATH = "${pkgs.cudatoolkit}";
    EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
    EXTRA_CCFLAGS = "-I/usr/include";
    DOTNET_SYSTEM_GLOBALIZATION_PREDEFINED_CULTURES_ONLY= "false";
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1";
#    browser_executable_path = "/run/current-system/sw/bin/chromium";
    NIXPKGS_ALLOW_UNFREE = "1";
    OBSIDIAN_ARGS = "--disable-gpu";
  };

environment.sessionVariables = {
   #because program with x11 had this problem
#  WLR_NO_HARDWARE_CURSORS = "1";
#  ELECTRON_OZONE_PLATFORM_HINT = "wayland";
#  NIXOS_OZONE_WL = "1";
};

### add aliases
  environment.shellAliases = {
#  podman = "docker";
  blame = "systemd-analyze blame";
  config = "sudo nano /etc/nixos/configuration.nix";
  update-sys = "rm -rf /home/amir/.gtkrc-2.0 && sudo nixos-rebuild switch --fast --flake /etc/nixos/";
  upgrade-sys = "rm -rf /home/amir/.gtkrc-2.0 && cd /etc/nixos/ && sudo nix flake update && sudo nixos-rebuild switch --upgrade --flake /etc/nixos/ && sudo nixos-rebuild boot --upgrade --flake /etc/nixos/ && cd ~ && conda-shell -c 'conda init fish && conda install python=3.11 -y && pip install -U ipython g4f[all] gallery-dl orjson'";
  copilot = "npx copilot-api@latest start";
  fixwifi = "sudo airmon-ng stop wlp0s20f3mon && sudo systemctl start wpa_supplicant.service && sudo systemctl start NetworkManager.service";
  clean = "sudo rm -rf /root/.cache && sudo nix-collect-garbage -d && sudo nix-store --optimize && sudo rm -rf /tmp/ && sudo mkdir /tmp && sudo chmod 1777 /tmp && sudo flatpak remove --unused && pip cache purge && sudo rm -rf ~/.cache/ && sudo rm -rf /root/.nix-defexpr/channels && sudo rm -rf /nix/var/nix/profiles/per-user/root/channels && sudo rm -rf /root/.nix-defexpr/channels";
  rollback = "sudo nix-rebuild --rollback switch";
  flakes = "sudo nano /etc/nixos/flake.nix";
  htop = "btop";
  myip = "curl ipinfo.io --proxy ''";
  chat = "sgpt --no-cache --repl temp";
  weather = "curl 'wttr.in/?format=4' --proxy ''";
#  warp = "/home/amir/bin/warp-plus -b 127.0.0.1:2080 --scan";
  proxies = "ssh -f -N -L 1080:localhost:443 ubuntu@193.123.76.61 && ssh -f -N -L 2080:localhost:2080 ubuntu@193.123.76.61";
  g4f-rs = "sudo systemctl restart g4f-gui.service && sudo systemctl restart g4f-api.service";
  rs = "sudo systemctl restart sing-box.service";
  neofetch = "fastfetch";
  gnome-reset = "dconf reset -f / && dconf watch /";
  home-manager-issues = "journalctl -u home-manager-amir.service";
  rx = "sudo systemctl restart xray.service";
  yt-music = "yt-dlp --extract-audio --audio-format best";
  server-deploy = "ssh ubuntu@193.123.76.61";
  server-personal = "ssh ubuntu@139.185.37.1";
  server-oldpersonal = "sshpass -p '123' ssh g1010yzd1@s4.serv00.com";
  nix-alien = "nix run github:thiagokokada/nix-alien#nix-alien --";
  com = "7z a -t7z -m0=lzma2 -mx=9 -mfb=273 -md=1536m -mmt=on -myx=9 -mtm=on -mtc=on -mta=on -sccUTF-8 -bt -bb3";
  nix-alien-ld = "nix run github:thiagokokada/nix-alien#nix-alien-ld --";
  nix-alien-find-libs = "nix run github:thiagokokada/nix-alien#nix-alien-find-libs --";
  quote = "fortune | pokemonsay -t --no-name";
  aria2 = "aria2c -x12 -j4 -m 0 -c --max-upload-limit 100K --human-readable --auto-save-interval=10 --disk-cache=64M --no-file-allocation-limit=64M --save-session-interval=10 --bt-detach-seed-only=true --check-certificate=false --max-file-not-found=10 --retry-wait=10 --connect-timeout=10 --timeout=10 --min-split-size=1M --http-accept-gzip=true --remote-time=true --summary-interval=0 --content-disposition-default-utf8=true --file-allocation=none --bt-enable-lpd=true --bt-hash-check-seed=true --bt-max-peers=128 --bt-prioritize-piece=head --bt-remove-unselected-file=true --bt-seed-unverified=false --bt-tracker-connect-timeout=10 --bt-tracker-timeout=10 --dht-entry-point=dht.transmissionbt.com:6881 --dht-entry-point6=dht.transmissionbt.com:6881 --enable-dht=true --enable-dht6=true --enable-peer-exchange=true --max-download-limit 3mb";
  l = "ls -lhGXA";
  silly = "/run/media/amir/Games/ai/SillyTavern/start.sh";
  arch-install = "distrobox create --root --nvidia -n arch --image quay.io/toolbx/arch-toolbox:latest -I --unshare-all --home /run/media/amir/Games/.distrobox/ --absolutely-disable-root-password-i-am-really-positively-sure";
  arch-rm = "distrobox-stop --root arch && distrobox-rm --root arch";
  arch = "distrobox enter --root arch";
  phone = "scrcpy --max-fps=60 -K --render-driver=opengl --turn-screen-off --disable-screensaver --power-off-on-close";
  snekoray = "sudo nekoray";
};

#####################################
# brave policies
#####################################
#"DnsOverHttpsTemplates": "https://1.1.1.1/dns-query",
  environment.etc."brave/policies/managed/policies.json".text = ''
{
  "ShowFullURLs": true,
  "WideAddressBar": true,
  "TorDisabled": true,
  "BraveSyncUrl": "",
  "DefaultGeolocationSetting": 2,
  "DefaultNotificationsSetting": 2,
  "BookmarksBarEnabled": true,
  "DefaultSerialGuardSetting": 2,
  "CloudReportingEnabled": false,
  "DriveDisabled": true,
  "PasswordManagerEnabled": false,
  "PasswordSharingEnabled": false,
  "DefaultSensorsSetting": 2,
  "MetricsReportingEnabled": false,
  "SafeBrowseExtendedReportingEnabled": false,
  "AutomaticallySendAnalytics": false,
  "DnsOverHttpsMode": "automatic",

  "BraveRewardsDisabled": true,
  "BraveVPNDisabled": true,
  "BraveWalletDisabled": true,
  "BraveAIChatEnabled": false,
  "BraveRewardsIconHidden": true,
  "HardwareAccelerationModeEnabled": true,
  "MemorySaverEnabled": true,
  "BackgroundModeEnabled": false,
  "DefaultSearchProviderEnabled": true,
  "DefaultSearchProviderName": "Startpage",
  "DefaultSearchProviderSearchURL": "www.google.com",
  "NewTabPageLocation": "https://www.google.com",
  "SyncDisabled": true,
  "BraveSyncEnabled": false,
  "ShieldsAdvancedView": true,
  "BraveExperimentalAdblockEnabled": true,
  "DefaultLocalFontsSetting": 2,
  "PasswordLeakDetectionEnabled": false,
  "QuickAnswersEnabled": false,
  "SafeBrowseSurveysEnabled": false,
  "SafeBrowseDeepScanningEnabled": false,
  "DeviceActivityHeartbeatEnabled": false,
  "DeviceMetricsReportingEnabled": false,
  "HeartbeatEnabled": false,
  "LogUploadEnabled": false,
  "ReportAppInventory": [
    ""
  ],
  "ReportDeviceActivityTimes": false,
  "ReportDeviceAppInfo": false,
  "ReportDeviceSystemInfo": false,
  "ReportDeviceUsers": false,
  "ReportWebsiteTelemetry": [
    ""
  ],
  "AlternateErrorPagesEnabled": false,
  "AutofillCreditCardEnabled": false,
  "BrowserGuestModeEnabled": false,
  "BrowserSignin": 0,
  "BuiltInDnsClientEnabled": false,
  "DefaultBrowserSettingEnabled": false,
  "ParcelTrackingEnabled": false,
  "RelatedWebsiteSetsEnabled": false,
  "ShoppingListEnabled": false,
  "ExtensionManifestV2Availability": 2,
}
'';
##########################################


### Home manager settings/configs:
# home manager options:
# https://nix-community.github.io/home-manager/options.xhtml
# https://home-manager-options.extranix.com/
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "";
  home-manager.sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
  
  home-manager.users.amir = {
   programs.git = {
    enable = true;
    userName  = "Amir-Hossein-Azimi";
    userEmail = "tweaterinestageram20@gmail.com";
   };


 #kde
# if you want to change stuff, disable plasma manager, do your own settings, then export using:
# nix run github:nix-community/plasma-manager
# and add your own
  programs.plasma = {
    enable = true;
    shortcuts = {
      "ActivityManager"."switch-to-activity-e2cb32e1-a872-4387-88b3-85dc4ef2f19a" = [ ];
      "KDE Keyboard Layout Switcher"."Switch keyboard layout to English (US)" = [ ];
      "KDE Keyboard Layout Switcher"."Switch keyboard layout to Persian (with Persian keypad)" = [ ];
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = "Meta+Alt+L";
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "none,Meta+Alt+K,Switch to Next Keyboard Layout";
      "kaccess"."Toggle Screen Reader On and Off" = "Meta+Alt+S";
      "kcm_touchpad"."Disable Touchpad" = "Touchpad Off";
      "kcm_touchpad"."Enable Touchpad" = "Touchpad On";
      "kcm_touchpad"."Toggle Touchpad" = ["Touchpad Toggle" "Meta+Ctrl+Touchpad Toggle" "Meta+Ctrl+Zenkaku Hankaku,Touchpad Toggle" "Touchpad Toggle" "Meta+Ctrl+Touchpad Toggle" "Meta+Ctrl+Zenkaku Hankaku"];
      "kmix"."decrease_microphone_volume" = "Microphone Volume Down";
      "kmix"."decrease_volume" = "Volume Down";
      "kmix"."decrease_volume_small" = "Shift+Volume Down";
      "kmix"."increase_microphone_volume" = "Microphone Volume Up";
      "kmix"."increase_volume" = "Volume Up";
      "kmix"."increase_volume_small" = "Shift+Volume Up";
      "kmix"."mic_mute" = ["Microphone Mute" "Meta+Volume Mute,Microphone Mute" "Meta+Volume Mute,Mute Microphone"];
      "kmix"."mute" = "Volume Mute";
      "ksmserver"."Halt Without Confirmation" = "none,,Shut Down Without Confirmation";
      "ksmserver"."Lock Session" = ["Meta+L" "Screensaver,Meta+L" "Screensaver,Lock Session"];
      "ksmserver"."Log Out" = "Ctrl+Alt+Del";
      "ksmserver"."Log Out Without Confirmation" = "none,,Log Out Without Confirmation";
      "ksmserver"."LogOut" = "none,,Log Out";
      "ksmserver"."Reboot" = "none,,Reboot";
      "ksmserver"."Reboot Without Confirmation" = "none,,Reboot Without Confirmation";
      "ksmserver"."Shut Down" = "none,,Shut Down";
      "kwin"."Activate Window Demanding Attention" = "Meta+Ctrl+A";
      "kwin"."Cycle Overview" = [ ];
      "kwin"."Cycle Overview Opposite" = [ ];
      "kwin"."Decrease Opacity" = "none,,Decrease Opacity of Active Window by 5%";
      "kwin"."Edit Tiles" = "none,,Toggle Tiles Editor";
      "kwin"."Expose" = "Ctrl+F9";
      "kwin"."ExposeAll" = ["Ctrl+F10" "Launch (C),Ctrl+F10" "Launch (C),Toggle Present Windows (All desktops)"];
      "kwin"."ExposeClass" = "Ctrl+F7";
      "kwin"."ExposeClassCurrentDesktop" = [ ];
      "kwin"."Grid View" = "Meta+G";
      "kwin"."Increase Opacity" = "none,,Increase Opacity of Active Window by 5%";
      "kwin"."Kill Window" = "Meta+Ctrl+Esc";
      "kwin"."Move Tablet to Next Output" = [ ];
      "kwin"."MoveMouseToCenter" = "Meta+F6";
      "kwin"."MoveMouseToFocus" = "Meta+F5";
      "kwin"."MoveZoomDown" = [ ];
      "kwin"."MoveZoomLeft" = [ ];
      "kwin"."MoveZoomRight" = [ ];
      "kwin"."MoveZoomUp" = [ ];
      "kwin"."Overview" = "Meta+W";
      "kwin"."Setup Window Shortcut" = "none,,Setup Window Shortcut";
      "kwin"."Show Desktop" = "Meta+D";
      "kwin"."Switch One Desktop Down" = "Meta+Ctrl+Down";
      "kwin"."Switch One Desktop Up" = "Meta+Ctrl+Up";
      "kwin"."Switch One Desktop to the Left" = "Meta+Ctrl+Left";
      "kwin"."Switch One Desktop to the Right" = "Meta+Ctrl+Right";
      "kwin"."Switch Window Down" = "Meta+Alt+Down";
      "kwin"."Switch Window Left" = "Meta+Alt+Left";
      "kwin"."Switch Window Right" = "Meta+Alt+Right";
      "kwin"."Switch Window Up" = "Meta+Alt+Up";
      "kwin"."Switch to Desktop 1" = ["Meta+1" "Ctrl+F1,Ctrl+F1,Switch to Desktop 1"];
      "kwin"."Switch to Desktop 10" = "none,,Switch to Desktop 10";
      "kwin"."Switch to Desktop 11" = "none,,Switch to Desktop 11";
      "kwin"."Switch to Desktop 12" = "none,,Switch to Desktop 12";
      "kwin"."Switch to Desktop 13" = "none,,Switch to Desktop 13";
      "kwin"."Switch to Desktop 14" = "none,,Switch to Desktop 14";
      "kwin"."Switch to Desktop 15" = "none,,Switch to Desktop 15";
      "kwin"."Switch to Desktop 16" = "none,,Switch to Desktop 16";
      "kwin"."Switch to Desktop 17" = "none,,Switch to Desktop 17";
      "kwin"."Switch to Desktop 18" = "none,,Switch to Desktop 18";
      "kwin"."Switch to Desktop 19" = "none,,Switch to Desktop 19";
      "kwin"."Switch to Desktop 2" = ["Ctrl+F2" "Meta+2,Ctrl+F2,Switch to Desktop 2"];
      "kwin"."Switch to Desktop 20" = "none,,Switch to Desktop 20";
      "kwin"."Switch to Desktop 3" = ["Ctrl+F3" "Meta+3,Ctrl+F3,Switch to Desktop 3"];
      "kwin"."Switch to Desktop 4" = ["Meta+4" "Ctrl+F4,Ctrl+F4,Switch to Desktop 4"];
      "kwin"."Switch to Desktop 5" = "Meta+5,,Switch to Desktop 5";
      "kwin"."Switch to Desktop 6" = "Meta+6,,Switch to Desktop 6";
      "kwin"."Switch to Desktop 7" = "Meta+7,,Switch to Desktop 7";
      "kwin"."Switch to Desktop 8" = "Meta+8,,Switch to Desktop 8";
      "kwin"."Switch to Desktop 9" = "Meta+9,,Switch to Desktop 9";
      "kwin"."Switch to Next Desktop" = "none,,Switch to Next Desktop";
      "kwin"."Switch to Next Screen" = "none,,Switch to Next Screen";
      "kwin"."Switch to Previous Desktop" = "none,,Switch to Previous Desktop";
      "kwin"."Switch to Previous Screen" = "none,,Switch to Previous Screen";
      "kwin"."Switch to Screen 0" = "none,,Switch to Screen 0";
      "kwin"."Switch to Screen 1" = "none,,Switch to Screen 1";
      "kwin"."Switch to Screen 2" = "none,,Switch to Screen 2";
      "kwin"."Switch to Screen 3" = "none,,Switch to Screen 3";
      "kwin"."Switch to Screen 4" = "none,,Switch to Screen 4";
      "kwin"."Switch to Screen 5" = "none,,Switch to Screen 5";
      "kwin"."Switch to Screen 6" = "none,,Switch to Screen 6";
      "kwin"."Switch to Screen 7" = "none,,Switch to Screen 7";
      "kwin"."Switch to Screen Above" = "none,,Switch to Screen Above";
      "kwin"."Switch to Screen Below" = "none,,Switch to Screen Below";
      "kwin"."Switch to Screen to the Left" = "none,,Switch to Screen to the Left";
      "kwin"."Switch to Screen to the Right" = "none,,Switch to Screen to the Right";
      "kwin"."Toggle Night Color" = [ ];
      "kwin"."Toggle Window Raise/Lower" = "none,,Toggle Window Raise/Lower";
      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
      "kwin"."Walk Through Windows Alternative" = "none,,Walk Through Windows Alternative";
      "kwin"."Walk Through Windows Alternative (Reverse)" = "none,,Walk Through Windows Alternative (Reverse)";
      "kwin"."Walk Through Windows of Current Application" = "Alt+`";
      "kwin"."Walk Through Windows of Current Application (Reverse)" = "Alt+~";
      "kwin"."Walk Through Windows of Current Application Alternative" = "none,,Walk Through Windows of Current Application Alternative";
      "kwin"."Walk Through Windows of Current Application Alternative (Reverse)" = "none,,Walk Through Windows of Current Application Alternative (Reverse)";
      "kwin"."Window Above Other Windows" = "none,,Keep Window Above Others";
      "kwin"."Window Below Other Windows" = "none,,Keep Window Below Others";
      "kwin"."Window Close" = "Alt+F4";
      "kwin"."Window Custom Quick Tile Bottom" = "none,,Custom Quick Tile Window to the Bottom";
      "kwin"."Window Custom Quick Tile Left" = "none,,Custom Quick Tile Window to the Left";
      "kwin"."Window Custom Quick Tile Right" = "none,,Custom Quick Tile Window to the Right";
      "kwin"."Window Custom Quick Tile Top" = "none,,Custom Quick Tile Window to the Top";
      "kwin"."Window Fullscreen" = "none,,Make Window Fullscreen";
      "kwin"."Window Grow Horizontal" = "none,,Expand Window Horizontally";
      "kwin"."Window Grow Vertical" = "none,,Expand Window Vertically";
      "kwin"."Window Lower" = "none,,Lower Window";
      "kwin"."Window Maximize" = "Meta+PgUp";
      "kwin"."Window Maximize Horizontal" = "none,,Maximize Window Horizontally";
      "kwin"."Window Maximize Vertical" = "none,,Maximize Window Vertically";
      "kwin"."Window Minimize" = "Meta+PgDown";
      "kwin"."Window Move" = "none,,Move Window";
      "kwin"."Window Move Center" = "none,,Move Window to the Center";
      "kwin"."Window No Border" = "none,,Toggle Window Titlebar and Frame";
      "kwin"."Window On All Desktops" = "none,,Keep Window on All Desktops";
      "kwin"."Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
      "kwin"."Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
      "kwin"."Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
      "kwin"."Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
      "kwin"."Window One Screen Down" = "none,,Move Window One Screen Down";
      "kwin"."Window One Screen Up" = "none,,Move Window One Screen Up";
      "kwin"."Window One Screen to the Left" = "none,,Move Window One Screen to the Left";
      "kwin"."Window One Screen to the Right" = "none,,Move Window One Screen to the Right";
      "kwin"."Window Operations Menu" = "Alt+F3";
      "kwin"."Window Pack Down" = "none,,Move Window Down";
      "kwin"."Window Pack Left" = "none,,Move Window Left";
      "kwin"."Window Pack Right" = "none,,Move Window Right";
      "kwin"."Window Pack Up" = "none,,Move Window Up";
      "kwin"."Window Quick Tile Bottom" = "Meta+Down";
      "kwin"."Window Quick Tile Bottom Left" = "none,,Quick Tile Window to the Bottom Left";
      "kwin"."Window Quick Tile Bottom Right" = "none,,Quick Tile Window to the Bottom Right";
      "kwin"."Window Quick Tile Left" = "Meta+Left";
      "kwin"."Window Quick Tile Right" = "Meta+Right";
      "kwin"."Window Quick Tile Top" = "Meta+Up";
      "kwin"."Window Quick Tile Top Left" = "none,,Quick Tile Window to the Top Left";
      "kwin"."Window Quick Tile Top Right" = "none,,Quick Tile Window to the Top Right";
      "kwin"."Window Raise" = "none,,Raise Window";
      "kwin"."Window Resize" = "none,,Resize Window";
      "kwin"."Window Shade" = "none,,Shade Window";
      "kwin"."Window Shrink Horizontal" = "none,,Shrink Window Horizontally";
      "kwin"."Window Shrink Vertical" = "none,,Shrink Window Vertically";
      "kwin"."Window to Desktop 1" = "Meta+!,,Window to Desktop 1";
      "kwin"."Window to Desktop 10" = "Meta+),,Window to Desktop 10";
      "kwin"."Window to Desktop 11" = "none,,Window to Desktop 11";
      "kwin"."Window to Desktop 12" = "none,,Window to Desktop 12";
      "kwin"."Window to Desktop 13" = "none,,Window to Desktop 13";
      "kwin"."Window to Desktop 14" = "none,,Window to Desktop 14";
      "kwin"."Window to Desktop 15" = "none,,Window to Desktop 15";
      "kwin"."Window to Desktop 16" = "none,,Window to Desktop 16";
      "kwin"."Window to Desktop 17" = "none,,Window to Desktop 17";
      "kwin"."Window to Desktop 18" = "none,,Window to Desktop 18";
      "kwin"."Window to Desktop 19" = "none,,Window to Desktop 19";
      "kwin"."Window to Desktop 2" = "Meta+@,,Window to Desktop 2";
      "kwin"."Window to Desktop 20" = "none,,Window to Desktop 20";
      "kwin"."Window to Desktop 3" = "Meta+#,,Window to Desktop 3";
      "kwin"."Window to Desktop 4" = "Meta+$,,Window to Desktop 4";
      "kwin"."Window to Desktop 5" = "Meta+%,,Window to Desktop 5";
      "kwin"."Window to Desktop 6" = "Meta+^,,Window to Desktop 6";
      "kwin"."Window to Desktop 7" = "Meta+&,,Window to Desktop 7";
      "kwin"."Window to Desktop 8" = "Meta+*,,Window to Desktop 8";
      "kwin"."Window to Desktop 9" = "Meta+(,,Window to Desktop 9";
      "kwin"."Window to Next Desktop" = "none,,Window to Next Desktop";
      "kwin"."Window to Next Screen" = "Meta+Shift+Right";
      "kwin"."Window to Previous Desktop" = "none,,Window to Previous Desktop";
      "kwin"."Window to Previous Screen" = "Meta+Shift+Left";
      "kwin"."Window to Screen 0" = "none,,Move Window to Screen 0";
      "kwin"."Window to Screen 1" = "none,Meta+!,Move Window to Screen 1";
      "kwin"."Window to Screen 2" = "none,Meta+@,Move Window to Screen 2";
      "kwin"."Window to Screen 3" = "none,Meta+#,Move Window to Screen 3";
      "kwin"."Window to Screen 4" = "none,Meta+$,Move Window to Screen 4";
      "kwin"."Window to Screen 5" = "none,Meta+%,Move Window to Screen 5";
      "kwin"."Window to Screen 6" = "none,Meta+^,Move Window to Screen 6";
      "kwin"."Window to Screen 7" = "none,Meta+&,Move Window to Screen 7";
      "kwin"."Window to Screen 8" = "none,Meta+*,Move Window to Screen 8";
      "kwin"."Window to Screen 9" = "none,Meta+(,Move Window to Screen 9";
      "kwin"."Window to Screen 10" = "none,Meta+),Move Window to Screen 10";
      "kwin"."disableInputCapture" = "Meta+Shift+Esc";
      "kwin"."view_actual_size" = "none,Meta+0,Zoom to Actual Size";
      "kwin"."view_zoom_in" = ["Meta++" "Meta+=,Meta++" "Meta+=,Zoom In"];
      "kwin"."view_zoom_out" = "Meta+-";
      "mediacontrol"."mediavolumedown" = "none,,Media volume down";
      "mediacontrol"."mediavolumeup" = "none,,Media volume up";
      "mediacontrol"."nextmedia" = "Media Next";
      "mediacontrol"."pausemedia" = "Media Pause";
      "mediacontrol"."playmedia" = "none,,Play media playback";
      "mediacontrol"."playpausemedia" = "Media Play";
      "mediacontrol"."previousmedia" = "Media Previous";
      "mediacontrol"."stopmedia" = "Media Stop";
      "org_kde_powerdevil"."Decrease Keyboard Brightness" = "Keyboard Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness" = "Monitor Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
      "org_kde_powerdevil"."Hibernate" = "Hibernate";
      "org_kde_powerdevil"."Increase Keyboard Brightness" = "Keyboard Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness" = "Monitor Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
      "org_kde_powerdevil"."PowerDown" = "Power Down";
      "org_kde_powerdevil"."PowerOff" = "Power Off";
      "org_kde_powerdevil"."Sleep" = "Sleep";
      "org_kde_powerdevil"."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
      "org_kde_powerdevil"."Turn Off Screen" = [ ];
      "org_kde_powerdevil"."powerProfile" = ["Battery" "Meta+B,Battery" "Meta+B,Switch Power Profile"];
      "plasmashell"."activate application launcher" = ["Meta" "Alt+F1,Meta" "Alt+F1,Activate Application Launcher"];
      "plasmashell"."activate task manager entry 1" = "none,,Activate Task Manager Entry 1";
      "plasmashell"."activate task manager entry 10" = "none,,Activate Task Manager Entry 10";
      "plasmashell"."activate task manager entry 2" = "none,,Activate Task Manager Entry 2";
      "plasmashell"."activate task manager entry 3" = "none,,Activate Task Manager Entry 3";
      "plasmashell"."activate task manager entry 4" = "none,,Activate Task Manager Entry 4";
      "plasmashell"."activate task manager entry 5" = "none,,Activate Task Manager Entry 5";
      "plasmashell"."activate task manager entry 6" = "none,,Activate Task Manager Entry 6";
      "plasmashell"."activate task manager entry 7" = "none,,Activate Task Manager Entry 7";
      "plasmashell"."activate task manager entry 8" = "none,,Activate Task Manager Entry 8";
      "plasmashell"."activate task manager entry 9" = "none,,Activate Task Manager Entry 9";
      "plasmashell"."clear-history" = "none,,Clear Clipboard History";
      "plasmashell"."clipboard_action" = "Meta+Ctrl+X";
      "plasmashell"."cycle-panels" = "Meta+Alt+P";
      "plasmashell"."cycleNextAction" = "none,,Next History Item";
      "plasmashell"."cyclePrevAction" = "none,,Previous History Item";
      "plasmashell"."manage activities" = "Meta+Q";
      "plasmashell"."next activity" = "Meta+A,none,Walk through activities";
      "plasmashell"."previous activity" = "Meta+Shift+A,none,Walk through activities (Reverse)";
      "plasmashell"."repeat_action" = "none,,Manually Invoke Action on Current Clipboard";
      "plasmashell"."show dashboard" = "Ctrl+F12";
      "plasmashell"."show-barcode" = "none,,Show Barcode…";
      "plasmashell"."show-on-mouse-pos" = "Meta+V";
      "plasmashell"."stop current activity" = "Meta+S";
      "plasmashell"."switch to next activity" = "none,,Switch to Next Activity";
      "plasmashell"."switch to previous activity" = "none,,Switch to Previous Activity";
      "plasmashell"."toggle do not disturb" = "none,,Toggle do not disturb";
      "services/kitty.desktop"."_launch" = ["Meta+T" "Ctrl+Alt+T"];
      "services/nemo.desktop"."_launch" = "Meta+E";
      "services/org.kde.dolphin.desktop"."_launch" = [ ];
      "services/org.kde.konsole.desktop"."_launch" = [ ];
     # "services/org.kde.spectacle.desktop"."FullScreenScreenShot" = [ ];
      #"services/org.kde.spectacle.desktop"."RecordRegion" = ["Shift+Ins" "Meta+R"];
      #"services/org.kde.spectacle.desktop"."RecordScreen" = "Shift+Print";
     # "services/org.kde.spectacle.desktop"."RectangularRegionScreenShot" = "Ins";
     # "services/org.kde.spectacle.desktop"."_launch" = ["Print"];
      "services/services.kitty.desktop"."_launch" = ["Ctrl+Alt+T" "Meta+T"];
      "services/services.org.kde.konsole.desktop"."_launch" = [ ];
      "services/services.org.kde.krunner.desktop"."_launch" = ["Meta+Space" "Alt+F2" "Search" "Alt+Space"];
      #"services/services.org.kde.spectacle.desktop"."FullScreenScreenShot" = [ ];
      #"services/services.org.kde.spectacle.desktop"."RecordRegion" = ["Meta+Shift+R" "Meta+R" "Shift+Ins"];
      #"services/services.org.kde.spectacle.desktop"."RecordScreen" = ["Meta+Alt+R" "Shift+Print"];
      #"services/services.org.kde.spectacle.desktop"."RectangularRegionScreenShot" = ["Ins" "Meta+Shift+Print"];
      #"services/services.org.kde.spectacle.desktop"."_launch" = "Print";
      "services/services.plasma-manager-commands.desktop"."launch-kitty1" = "Ctrl+Alt+T";
      "services/services.plasma-manager-commands.desktop"."launch-kitty2" = "Meta+T";
    };
    configFile = {
      "baloofilerc"."General"."dbVersion" = 2;
      "baloofilerc"."General"."exclude filters" = "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.tfstate*,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.terraform,.venv,venv,core-dumps,lost+found";
      "baloofilerc"."General"."exclude filters version" = 9;
      "baloofilerc"."General"."foldersx5b$ex5d" = "$HOME/,/run/media/nako/Games/";
      "baloofilerc"."General"."index hidden folders" = true;
      "dolphinrc"."General"."ViewPropsTimestamp" = "2025,5,23,17,7,32.442";
      "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize" = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Static Size" = 22;
      "kactivitymanagerdrc"."activities"."e2cb32e1-a872-4387-88b3-85dc4ef2f19a" = "Default";
      "kactivitymanagerdrc"."main"."currentActivity" = "e2cb32e1-a872-4387-88b3-85dc4ef2f19a";
      "kcminputrc"."Libinput.1267.12678.MSFT0001:01 04F3:3186 Touchpad"."PointerAccelerationProfile" = 2;
      "kcminputrc"."Mouse"."cursorSize" = 24;
      "kcminputrc"."Mouse"."cursorTheme" = "Sweet-cursors";
      "kded5rc"."Module-browserintegrationreminder"."autoload" = false;
      "kded5rc"."Module-device_automounter"."autoload" = false;
      "kdeglobals"."DirSelect Dialog"."DirSelectDialog Size" = "820,581";
      "kdeglobals"."General"."UseSystemBell" = true;
      "kdeglobals"."Icons"."Theme" = "candy-icons";
      "kdeglobals"."KDE"."widgetStyle" = "BreezeDark";
      "kdeglobals"."KFileDialog Settings"."Allow Expansion" = false;
      "kdeglobals"."KFileDialog Settings"."Automatically select filename extension" = true;
      "kdeglobals"."KFileDialog Settings"."Breadcrumb Navigation" = true;
      "kdeglobals"."KFileDialog Settings"."Decoration position" = 2;
      "kdeglobals"."KFileDialog Settings"."LocationCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."PathCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."Show Bookmarks" = false;
      "kdeglobals"."KFileDialog Settings"."Show Full Path" = false;
      "kdeglobals"."KFileDialog Settings"."Show Inline Previews" = true;
      "kdeglobals"."KFileDialog Settings"."Show Preview" = false;
      "kdeglobals"."KFileDialog Settings"."Show Speedbar" = true;
      "kdeglobals"."KFileDialog Settings"."Show hidden files" = false;
      "kdeglobals"."KFileDialog Settings"."Sort by" = "Name";
      "kdeglobals"."KFileDialog Settings"."Sort directories first" = true;
      "kdeglobals"."KFileDialog Settings"."Sort hidden files last" = false;
      "kdeglobals"."KFileDialog Settings"."Sort reversed" = false;
      "kdeglobals"."KFileDialog Settings"."Speedbar Width" = 140;
      "kdeglobals"."KFileDialog Settings"."View Style" = "DetailTree";
      "kdeglobals"."KScreen"."ScreenScaleFactors" = "eDP-1=1;";
      "kdeglobals"."KScreen"."XwaylandClientsScale" = false;
      "kdeglobals"."Shortcuts"."Paste" = "Ctrl+V";
      "kdeglobals"."WM"."activeBackground" = "30,30,46";
      "kdeglobals"."WM"."activeBlend" = "249,226,175";
      "kdeglobals"."WM"."activeForeground" = "205,214,244";
      "kdeglobals"."WM"."inactiveBackground" = "30,30,46";
      "kdeglobals"."WM"."inactiveBlend" = "69,71,90";
      "kdeglobals"."WM"."inactiveForeground" = "205,214,244";
      "krunnerrc"."Plugins"."baloosearchEnabled" = true;
      "ksplashrc"."KSplash"."Engine" = "none";
      "ksplashrc"."KSplash"."Theme" = "None";
      "kwalletrc"."Wallet"."Close When Idle" = false;
      "kwalletrc"."Wallet"."Close on Screensaver" = false;
      "kwalletrc"."Wallet"."Default Wallet" = "kdewallet";
      "kwalletrc"."Wallet"."Enabled" = false;
      "kwalletrc"."Wallet"."Idle Timeout" = 10;
      "kwalletrc"."Wallet"."Launch Manager" = false;
      "kwalletrc"."Wallet"."Leave Manager Open" = false;
      "kwalletrc"."Wallet"."Leave Open" = true;
      "kwalletrc"."Wallet"."Prompt on Open" = false;
      "kwalletrc"."Wallet"."Use One Wallet" = true;
      "kwalletrc"."org.freedesktop.secrets"."apiEnabled" = true;
      "kwinrc"."Activities.LastVirtualDesktop"."e2cb32e1-a872-4387-88b3-85dc4ef2f19a" = "Desktop_2";
      "kwinrc"."Activities/LastVirtualDesktop"."e2cb32e1-a872-4387-88b3-85dc4ef2f19a" = "Desktop_1";
      "kwinrc"."Desktops"."Id_1" = "Desktop_1";
      "kwinrc"."Desktops"."Id_10" = "Desktop_10";
      "kwinrc"."Desktops"."Id_2" = "Desktop_2";
      "kwinrc"."Desktops"."Id_3" = "Desktop_3";
      "kwinrc"."Desktops"."Id_4" = "Desktop_4";
      "kwinrc"."Desktops"."Id_5" = "Desktop_5";
      "kwinrc"."Desktops"."Id_6" = "Desktop_6";
      "kwinrc"."Desktops"."Id_7" = "Desktop_7";
      "kwinrc"."Desktops"."Id_8" = "Desktop_8";
      "kwinrc"."Desktops"."Id_9" = "Desktop_9";
      "kwinrc"."Desktops"."Number" = 10;
      "kwinrc"."Desktops"."Rows" = 10;
      "kwinrc"."Effect-shakecursor"."Magnification" = 2;
      "kwinrc"."Tiling"."padding" = 4;
      "kwinrc"."Tiling.eb491a77-2ca2-5509-b23e-c0f20051f42e"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/eb491a77-2ca2-5509-b23e-c0f20051f42e"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Xwayland"."XwaylandEavesdrops" = "All";
      "kwinrc"."Xwayland"."XwaylandEavesdropsMouse" = true;
      "kwinrc"."org.kde.kdecoration2"."theme" = "__aurorae__svg__Sweet-Dark";
      "kxkbrc"."Layout"."DisplayNames" = ",";
      "kxkbrc"."Layout"."LayoutList" = "us,ir";
      "kxkbrc"."Layout"."Options" = "grp:alt_shift_toggle";
      "kxkbrc"."Layout"."ResetOldOptions" = true;
      "kxkbrc"."Layout"."Use" = true;
      "kxkbrc"."Layout"."VariantList" = ",pes_keypad";
      "plasma-localerc"."Formats"."LANG" = "en_US.UTF-8";
      "plasmaparc"."General"."RaiseMaximumVolume" = true;
      "plasmaparc"."General"."VolumeStep" = 10;
      "plasmarc"."Theme"."name" = "default";
      "spectaclerc"."General"."clipboardGroup" = "PostScreenshotCopyImage";
      "spectaclerc"."ImageSave"."translatedScreenshotsFolder" = "Screenshots";
      "spectaclerc"."VideoSave"."translatedScreencastsFolder" = "Screencasts";
    };
    dataFile = {

    };
  };


dconf = {
  enable = true;
  settings = {
    # --- Existing Cinnamon Settings ---
    "org/cinnamon/desktop/applications/terminal" = {
      exec = "kitty";
      # exec-arg = ""; # argument
    };

    # --- Existing GNOME Desktop Application Settings ---
    "org/gnome/desktop/applications/terminal" = {
       exec = "kitty";
    };

    };
  };




#   programs.nix-index.enable = true;
   services.mpris-proxy.enable = true;
  

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
	{ id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
  	{ id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # proton pass
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
        { id = "mkplpffahhkjfocfbfapcemhhkgmljpn"; } # dark theme
        { id = "hipekcciheckooncpjeljhnekcoolahp"; } # Tabliss
	{ id = "cbghhgpcnddeihccjmnadmkaejncjndb"; } # vesktop web 
    ];
    commandLineArgs = [
      "--disable-features=WebRtcAllowInputVolumeAdjustment --ozone-platform=wayland --enable-gpu-rasterization --enable-zero-copy --ignore-gpu-blocklist --enable-vulkan --enable-parallel-downloading --enable-features=brave-adblock-experimental-list-default --password-store=basic"
    ];
  };



# librewolf

#stylix.targets.librewolf.enable = false;
stylix.targets.librewolf.profileNames = [ "Default" ];

programs.librewolf = {
  enable = true;
  package = pkgs.librewolf-bin;
  profiles.Default = {
      id = 0;
      name = "Default";
      isDefault = true;

      search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
        "NixOS Options" = {
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@no" ];
        };
        "Perplexity" = {
          urls = [
            {
              template = "https://perplexity.ai/";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@p" ];
        };
        "Startpage" = {
          urls = [
            {
              template = "https://www.startpage.com/do/dsearch";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
        };
      };

      search.force = true;
      search.default = "Startpage";
      search.privateDefault = "Startpage";
      search.order = ["Startpage" "Perplexity" "Nix Packages" "NixOS Options"];



};


  policies = {
# https://mozilla.github.io/policy-templates/
#    librewolf has already sane defaults and better not touch it.
#
#    DisableTelemetry = true;
#    DisableFirefoxStudies = true;
#    DisableAppUpdate = true;
#    AppUpdateURL = "https://localhost/";
     Preferences = {
	"network.trr.mode" = 3;
	"network.trr.uri" = "https://1.1.1.1/dns-query";
	"keyword.enabled" = true;
	"oolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };

############################
# declarable extension
# id:
# about:support -> look for add-ons
# install_id:
# https://addons.mozilla.org/firefox/downloads/latest/ id /latest.xpi
# automatic extracting:
# https://github.com/mkaply/queryamoid/releases/tag/v0.2
    ExtensionSettings = {
      "queryamoid@kaply.com" = {
        install_url = "https://github.com/mkaply/queryamoid/releases/download/v0.2/query_amo_addon_id-0.2-fx.xpi";
        installation_mode = "force_installed";
      };
      "uBlock0@raymondhill.net" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        installation_mode = "force_installed";
      };
      "ImprovedTube" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-addon/latest.xpi";
        installation_mode = "force_installed";
      };
      "magnolia@12.34" = {
        install_url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-latest.xpi";
        installation_mode = "force_installed";
      };
      "{74145f27-f039-47ce-a470-a662b129930a}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
        installation_mode = "force_installed";
      };
      "{5cce4ab5-3d47-41b9-af5e-8203eea05245}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/control-panel-for-twitter/latest.xpi";
        installation_mode = "force_installed";
      };
      "addon@darkreader.org" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        installation_mode = "force_installed";
      };
      "deArrow@ajay.app" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/dearrow/latest.xpi";
        installation_mode = "force_installed";
      };
      "{5384767E-00D9-40E9-B72F-9CC39D655D6F}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/epubreader/latest.xpi";
        installation_mode = "force_installed";
      };
      "{f025edeb-947f-46f6-b625-e5ad70f99ba6}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/%E3%82%AF%E3%83%83%E3%82%AD%E3%83%BCjson%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E5%87%BA%E5%8A%9B-for-puppeteer/latest.xpi";
        installation_mode = "force_installed";
      };
      "7esoorv3@alefvanoon.anonaddy.me" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/libredirect/latest.xpi";
        installation_mode = "force_installed";
      };
      "linkgopher@oooninja.com" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/link-gopher/latest.xpi";
        installation_mode = "force_installed";
      };
      "{2ea2bfef-af69-4427-909c-34e1f3f5a418}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/live-stream-downloader/latest.xpi";
        installation_mode = "force_installed";
      };
      "{943b8007-a895-44af-a672-4f4ea548c95f}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/markdown-viewer-webext/latest.xpi";
        installation_mode = "force_installed";
      };
      "multithreaded-download-manager@qw.linux-2g64.local" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/multithreaded-download-manager/latest.xpi";
        installation_mode = "force_installed";
      };
      "page-assist@nazeem" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/page-assist/latest.xpi";
        installation_mode = "force_installed";
      };
      "jid1-MnnxcxisBPnSXQ@jetpack" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
        installation_mode = "force_installed";
      };
      "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
        installation_mode = "force_installed";
      };
      "vpn@proton.ch" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-vpn-firefox-extension/latest.xpi";
        installation_mode = "force_installed";
      };
      "{46abbc04-ce38-475f-9ef8-e0a4a59d0c9f}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/reddit-enhancer/latest.xpi";
        installation_mode = "force_installed";
      };
      "{9076cefe-e6f8-4883-a480-9f968bd09249}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/reddit-nsfw-unblocker/latest.xpi";
        installation_mode = "force_installed";
      };
      "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
        installation_mode = "force_installed";
      };
      "i@diygod.me" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/rsshub-radar/latest.xpi";
        installation_mode = "force_installed";
      };
      "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/search_by_image/latest.xpi";
        installation_mode = "force_installed";
      };
      "sponsorBlocker@ajay.app" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
        installation_mode = "force_installed";
      };
      "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/traduzir-paginas-web/latest.xpi";
        installation_mode = "force_installed";
      };
      "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/violentmonkey/latest.xpi";
        installation_mode = "force_installed";
      };
      "{b86e4813-687a-43e6-ab65-0bde4ab75758}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/localcdn-fork-of-decentraleyes/latest.xpi";
        installation_mode = "force_installed";
      };
      "webextension@metamask.io" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ether-metamask/latest.xpi";
        installation_mode = "force_installed";
      };
      "{b5501fd1-7084-45c5-9aa6-567c2fcf5dc6}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ruffle_rs/latest.xpi";
        installation_mode = "force_installed";
      };
      "{22b0eca1-8c02-4c0d-a5d7-6604ddd9836e}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/nicothin-space/latest.xpi";
        installation_mode = "force_installed";
      };
      "extension@tabliss.io" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/tabliss/latest.xpi";
        installation_mode = "force_installed";
      };
    };

 };
};


# firefox end
###################

stylix.targets.gtk.enable = false;

gtk = {
      enable = true;
      theme.name = "Sweet-Dark";
      theme.package = pkgs.sweet;
      iconTheme.name = "candy-icons";
      iconTheme.package = pkgs.candy-icons;
      gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
};

stylix.targets.qt.enable = false;
  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/Sweet".source = "${pkgs.sweet-nova}/share/Kvantum/Sweet";
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Sweet
    '';
  };

#########
# kitty config
########

programs.kitty = {
enable = true;
enableGitIntegration = true;
shellIntegration = {
      enableBashIntegration = true;
      enableFishIntegration = true;
};

keybindings = {
    "kitty_mod"   = "ctrl";
    # Clipboard
    "ctrl+shift+c" = "copy_to_clipboard"; # macOS specific
    "ctrl+shift+v" = "paste_from_clipboard";
    "ctrl+v" = "paste_from_clipboard"; # macOS specific
    "ctrl+shift+s" = "paste_from_selection";
    "shift+insert" = "paste_from_selection";
    "ctrl+shift+o" = "pass_selection_to_program";

    # Scrolling
    "ctrl+shift+up" = "scroll_line_up";
    "ctrl+shift+k" = "scroll_line_up";
    "opt+ctrl+page_up" = "scroll_line_up"; # macOS specific
    "ctrl+up" = "scroll_line_up"; # macOS specific
    "ctrl+shift+down" = "scroll_line_down";
    "ctrl+shift+j" = "scroll_line_down";
    "opt+ctrl+page_down" = "scroll_line_down"; # macOS specific
    "ctrl+down" = "scroll_line_down"; # macOS specific
    "ctrl+shift+page_up" = "scroll_page_up";
    "ctrl+page_up" = "scroll_page_up"; # macOS specific
    "ctrl+shift+page_down" = "scroll_page_down";
    "ctrl+page_down" = "scroll_page_down"; # macOS specific
    "ctrl+shift+home" = "scroll_home";
    "ctrl+home" = "scroll_home"; # macOS specific
    "ctrl+shift+end" = "scroll_end";
    "ctrl+end" = "scroll_end"; # macOS specific
    "ctrl+shift+z" = "scroll_to_prompt -1";
    "ctrl+shift+x" = "scroll_to_prompt 1";
    "ctrl+shift+h" = "show_scrollback";
    "ctrl+shift+g" = "show_last_command_output";

    # Window management
    "ctrl+shift+enter" = "new_window";
    "ctrl+shift+n" = "new_os_window";
    "ctrl+shift+w" = "close_window";
    "shift+ctrl+d" = "close_window"; # macOS specific
    "ctrl+shift+]" = "next_window";
    "ctrl+shift+[" = "previous_window";
    "ctrl+shift+f" = "move_window_forward";
    "ctrl+shift+b" = "move_window_backward";
    "ctrl+shift+`" = "move_window_to_top"; # backtick key
    "ctrl+shift+r" = "start_resizing_window";
    "ctrl+r" = "start_resizing_window"; # macOS specific
    "ctrl+shift+1" = "first_window";
    "ctrl+1" = "first_window"; # macOS specific
    "ctrl+shift+2" = "second_window";
    "ctrl+2" = "second_window"; # macOS specific
    "ctrl+shift+3" = "third_window";
    "ctrl+3" = "third_window"; # macOS specific
    "ctrl+shift+4" = "fourth_window";
    "ctrl+4" = "fourth_window"; # macOS specific
    "ctrl+shift+5" = "fifth_window";
    "ctrl+5" = "fifth_window"; # macOS specific
    "ctrl+shift+6" = "sixth_window";
    "ctrl+6" = "sixth_window"; # macOS specific
    "ctrl+shift+7" = "seventh_window";
    "ctrl+7" = "seventh_window"; # macOS specific
    "ctrl+shift+8" = "eighth_window";
    "ctrl+8" = "eighth_window"; # macOS specific
    "ctrl+shift+9" = "ninth_window";
    "ctrl+9" = "ninth_window"; # macOS specific
    "ctrl+shift+0" = "tenth_window"; # No ctrl+0 for tenth, ctrl+0 is reset font size
    "ctrl+shift+f7" = "focus_visible_window";
    "ctrl+shift+f8" = "swap_with_window";

    # Tab management
    "ctrl+right" = "next_tab";
    "ctrl+left" = "previous_tab";
    "ctrl+shift+t" = "new_tab";
    "ctrl+t" = "new_tab"; # macOS specific
    "ctrl+shift+q" = "close_tab";
    "shift+ctrl+w" = "close_os_window"; # macOS specific
    "ctrl+shift+." = "move_tab_forward";
    "ctrl+shift+," = "move_tab_backward";
    "ctrl+shift+alt+t" = "set_tab_title";
    "shift+ctrl+i" = "set_tab_title"; # macOS specific

    # Layout management
    "ctrl+shift+l" = "next_layout";

    # Font sizes
    "ctrl+shift+equal" = "change_font_size all +2.0";
    "ctrl+shift+plus" = "change_font_size all +2.0"; # Typically same as 'equal' without shift
    "ctrl+shift+kp_add" = "change_font_size all +2.0";
    "ctrl+plus" = "change_font_size all +2.0"; # macOS specific
    "ctrl+equal" = "change_font_size all +2.0"; # macOS specific
    "shift+ctrl+equal" = "change_font_size all +2.0"; # macOS specific (for + key)
    "ctrl+shift+minus" = "change_font_size all -2.0";
    "ctrl+shift+kp_subtract" = "change_font_size all -2.0";
    "ctrl+minus" = "change_font_size all -2.0"; # macOS specific
    "shift+ctrl+minus" = "change_font_size all -2.0"; # macOS specific (for _ key)
    "ctrl+shift+backspace" = "change_font_size all 0";
    "ctrl+0" = "change_font_size all 0"; # macOS specific

    # Select and act on visible text (hints kitten)
    "ctrl+shift+e" = "open_url_with_hints";
    "ctrl+shift+p>f" = "kitten hints --type path --program -";
    "ctrl+shift+p>shift+f" = "kitten hints --type path";
    "ctrl+shift+p>l" = "kitten hints --type line --program -";
    "ctrl+shift+p>w" = "kitten hints --type word --program -";
    "ctrl+shift+p>h" = "kitten hints --type hash --program -";
    "ctrl+shift+p>n" = "kitten hints --type linenum";
    "ctrl+shift+p>y" = "kitten hints --type hyperlink";

    # Miscellaneous
    "ctrl+shift+f1" = "show_kitty_doc overview";
    "ctrl+shift+f11" = "toggle_fullscreen";
    "ctrl+ctrl+f" = "toggle_fullscreen"; # macOS specific
    "ctrl+shift+f10" = "toggle_maximized";
    "opt+ctrl+s" = "toggle_macos_secure_keyboard_entry"; # macOS specific
    "ctrl+shift+u" = "kitten unicode_input";
    "ctrl+ctrl+space" = "kitten unicode_input"; # macOS specific
    "ctrl+shift+f2" = "edit_config_file";
    "ctrl+," = "edit_config_file"; # macOS specific
    "ctrl+shift+escape" = "kitty_shell window";
    "ctrl+shift+a>m" = "set_background_opacity +0.1";
    "ctrl+shift+a>l" = "set_background_opacity -0.1";
    "ctrl+shift+a>1" = "set_background_opacity 1";
    "ctrl+shift+a>d" = "set_background_opacity default";
    "ctrl+shift+delete" = "clear_terminal reset active";
    "option+ctrl+k" = "clear_terminal scrollback active"; # macOS specific
    "ctrl+shift+f5" = "load_config_file";
    "ctrl+ctrl+," = "load_config_file"; # macOS specific (Note: ctrl+, is edit_config_file, this is ctrl+ctrl+,)
    "ctrl+shift+f6" = "debug_config";
    "opt+ctrl+," = "debug_config"; # macOS specific

    # macOS specific application controls
    "ctrl+h" = "hide_macos_app"; # macOS specific
    "opt+ctrl+h" = "hide_macos_other_apps"; # macOS specific
    "ctrl+m" = "minimize_macos_window"; # macOS specific
};
};



##############
# ghostty config
##############

programs.ghostty = {
enable = false;
clearDefaultKeybinds = true;
enableBashIntegration = true;
enableFishIntegration = true;
settings = {
  theme = "Adventure";
  font-size = 10;
  keybind = [
"super+ctrl+shift+plus=equalize_splits"
"super+ctrl+shift+up=resize_split:up,10"
"super+ctrl+shift+down=resize_split:down,10"
"super+ctrl+shift+right=resize_split:right,10"
"super+ctrl+shift+left=resize_split:left,10"
"ctrl+alt+shift+j=write_screen_file:open"
"super+ctrl+left_bracket=goto_split:previous"
"super+ctrl+right_bracket=goto_split:next"
"ctrl+alt+up=goto_split:up"
"ctrl+alt+down=goto_split:down"
"ctrl+alt+right=goto_split:right"
"ctrl+alt+left=goto_split:left"
"ctrl+a=select_all"
"ctrl+shift+c=copy_to_clipboard"
"ctrl+down=new_split:down"
"ctrl+shift+i=inspector:toggle"
"ctrl+shift+v=paste_from_clipboard"
"ctrl+shift+n=new_window"
"ctrl+shift+up=new_split:right"
"ctrl+shift+q=quit"
"ctrl+shift+t=new_tab"
"ctrl+shift+j=write_screen_file:paste"
"ctrl+shift+w=close_tab"
"ctrl+shift+comma=reload_config"
"shift+right=next_tab"
"shift+left=previous_tab"
"ctrl+shift+page_up=jump_to_prompt:-1"
"ctrl+shift+page_down=jump_to_prompt:1"
"ctrl+shift+enter=toggle_split_zoom"
"ctrl+shift+tab=previous_tab"
"alt+1=goto_tab:1"
"alt+2=goto_tab:2"
"alt+3=goto_tab:3"
"alt+4=goto_tab:4"
"alt+5=goto_tab:5"
"alt+6=goto_tab:6"
"alt+7=goto_tab:7"
"alt+8=goto_tab:8"
"alt+9=last_tab"
"alt+f4=close_window"
"ctrl+0=reset_font_size"
"ctrl+comma=open_config"
"ctrl+minus=decrease_font_size:1"
"ctrl+equal=increase_font_size:1"
"ctrl+insert=copy_to_clipboard"
"ctrl+page_up=previous_tab"
"ctrl+page_down=next_tab"
"ctrl+enter=toggle_fullscreen"
"ctrl+tab=next_tab"
"shift+up=adjust_selection:up"
"shift+down=adjust_selection:down"
"shift+right=adjust_selection:right"
"shift+left=adjust_selection:left"
"shift+home=scroll_to_top"
"shift+end=scroll_to_bottom"
"shift+insert=paste_from_selection"
"shift+page_up=scroll_page_up"
"shift+page_down=scroll_page_down"
  ];
};
};


# yt-dlp 
programs.yt-dlp = {
enable = true;
settings = {
  embed-thumbnail = true;
  embed-subs = true;
  sub-langs = "en,fa";
  write-sub = true;
  embed-chapters = true;
  sponsorblock-remove = "all";
  audio-format = "best";
  merge-output-format = "mp4"; # Or another suitable container format
  format = "bestvideo[height<=?720][vcodec!=?vp9][vcodec!=?av01]+bestaudio/best[height<=?720][vcodec!=?vp9][vcodec!=?av01]";
  downloader = "aria2c";
  downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
};
};
########################################
# gallery-dl
programs.gallery-dl = {
enable = true;
settings = {
  extractor.base-directory = "./";
  extractor.directory = ["{manga}" "{manga} c{chapter} - {title}"];
  extractor.mangadex = {
        lang = ["fa" "en"];
        postprocessors = {
    "name" = "zip";
    "compression" = "lzma";
    "extension" = "cbz";
};

};

downloader.retries = -1;

};

};
#########################################
# mpv

programs.mpv.config = {
save-volume = "yes";
audio-pitch-correction = "no";
sub-auto = "fuzzy";
profile = "high-quality";
ytdl-format = "bestvideo+bestaudio";
slang = "en,fa";
tscale = "sphinx";
tscale-blur = 0.65;
# what is problm : video always 100Pe for every
"save-position-on-quit" = "yes";
volume = "65";

};

programs.mpv.bindings = {
  # Clear Shaders
  "CTRL+0" = ''no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"'';

  # 1. Anime4K Mode A+A (HQ) - Your Custom Chain
  "CTRL+1" = ''no-osd change-list glsl-shaders set "${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders/Anime4K_Restore_CNN_VL.glsl:${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders/Anime4K_Restore_CNN_M.glsl:${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A+A (HQ)"''; 
  # Top-tier perceptual quality for anime upscaling (demanding). Best for significant upscale ratios (e.g., 720p->4K).
  
  # 2. FSRCNNX_x2_16-0-4-1.glsl
  "CTRL+2" = ''no-osd change-list glsl-shaders set "${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders/FSRCNNX_x2_16-0-4-1.glsl"; show-text "Shader: FSRCNNX x2 (16-0-4-1)"''; 
  # High-quality AI-based general upscaler (x2). Very sharp, detailed. GPU intensive.

  # 3. FSR.glsl (AMD FidelityFX Super Resolution 1.0)
  "CTRL+3" = ''no-osd change-list glsl-shaders set "${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders/FSR.glsl"; show-text "Shader: AMD FSR 1.0"''; 
  # Spatial upscaler with sharpening. Good balance of quality and performance, less demanding than AI.
  
  # 4. NVScaler.glsl (NVIDIA Image Scaling)
  "CTRL+4" = ''no-osd change-list glsl-shaders set "${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders/NVScaler.glsl"; show-text "Shader: NVScaler (NVIDIA Image Scaling)"''; 
  # Spatial upscaler with sharpening (similar to FSR). Good performance-to-quality, especially on NVIDIA.
  
  "Ctrl+=" = "add sub-scale +0.1";
  "Ctrl+-" = "add sub-scale -0.1";
  "[" = "add speed -0.01";
  "]" = "add speed 0.01";
};


# mpv bindings
#home.file.".config/mpv/input.conf".text = ''
#[ add speed -0.01
#] add speed 0.01
#Ctrl+= add sub-scale +0.1
#Ctrl+- add sub-scale -0.1
#'';



####
# mpv scripting
# check nix's repo (has 61 atm):
# https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=mpvScripts.
# also complete list:
# https://github.com/stax76/awesome-mpv
programs.mpv.enable = true;
programs.mpv.scripts = with pkgs.mpvScripts; [
uosc
thumbfast
#for not sleep
inhibit-gnome

];
# end of mpv



# set default format
# to find out the format, example:
# xdg-mime query filetype proxy-image.png
# ----------------------
# default .desktop location:
# ~/.local/share/applications
# /run/current-system/sw/share/applications
#
# if doesn't work remove (home-manager error), look for mimeapps:
# rm ~/.local/share/applications/mimeapps.list
# rm ~/.config/mimeapps.list
#
# to add manually:
# https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.desktopEntries
#
# setting default:

  xdg.configFile."mimeapps.list".force = true;

  xdg.mimeApps = {
    enable = true; # Make sure xdg.mimeApps is enabled
    defaultApplications = {
      "text/markdown" = "org.kde.kate.desktop";
      "text/plain" = "org.kde.kate.desktop";
      "application/json" = "org.kde.kate.desktop";
      "image/jpeg" = "org.kde.gwenview.desktop";
      "image/png" = "org.kde.gwenview.desktop";
      "image/gif" = "org.kde.gwenview.desktop";
      "image/bmp" = "org.kde.gwenview.desktop";
      "image/tiff" = "org.kde.gwenview.desktop";
      "image/webp" = "org.kde.gwenview.desktop";
      "image/svg+xml" = "org.kde.gwenview.desktop";
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
      "x-scheme-handler/chrome" = "google-chrome.desktop";
      "x-scheme-handler/mailto" = "google-chrome.desktop";
      "application/x-extension-htm" = "google-chrome.desktop";
      "application/x-extension-html" = "google-chrome.desktop";
      "application/x-extension-shtml" = "google-chrome.desktop";
      "application/xhtml+xml" = "google-chrome.desktop";
      "application/xml" = "google-chrome.desktop";
      "application/x-extension-xhtml" = "google-chrome.desktop";
      "application/x-extension-xht" = "google-chrome.desktop";
      #"application/vnd.comicbook+zip" = "okularApplication_comicbook.desktop";
      #"application/pdf" = "okularApplication_comicbook.desktop";
    }; };



## vesktop config
programs.vesktop = {
enable = true;
settings = {
  appBadge = true;
  arRPC = false;
  checkUpdates = false;
  customTitleBar = false;
  disableMinSize = true;
  minimizeToTray = true;
  tray = true;
  splashBackground = "#000000";
  splashColor = "#ffffff";
  splashTheming = true;
  staticTitle = true;
  hardwareAcceleration = true;
  discordBranch = "canary";
};


#vencord.useSystem = true;
vencord.settings = {
  notifyAboutUpdates = true;
  autoUpdate = true;
  autoUpdateNotification = true;
  useQuickCss = false;
  themeLinks = [

  ];
  enabledThemes = [
  ];
  enableReactDevtools = false;
  frameless = false;
  transparent = false;
  winCtrlQ = false;
  disableMinSize = false;
  winNativeTitleBar = false;
  plugins = {
    AlwaysAnimate = {
      enabled = true;
    };
    AlwaysTrust = {
      enabled = true;
      domain = true;
      file = true;
    };
    AnonymiseFileNames = {
      enabled = false;
      method = 0;
      randomisedLength = 7;
    };
    BadgeAPI = {
      enabled = true;
    };
    CommandsAPI = {
      enabled = true;
    };
    ContextMenuAPI = {
      enabled = true;
    };
    MemberListDecoratorsAPI = {
      enabled = true;
    };
    MessageAccessoriesAPI = {
      enabled = true;
    };
    MessageDecorationsAPI = {
      enabled = true;
    };
    MessageEventsAPI = {
      enabled = true;
    };
    MessagePopoverAPI = {
      enabled = true;
    };
    NoticesAPI = {
      enabled = true;
    };
    ServerListAPI = {
      enabled = true;
    };
    SettingsStoreAPI = {
      enabled = true;
    };
    "WebRichPresence (arRPC)" = {
      enabled = false;
    };
    BANger = {
      enabled = false;
      source = "https://i.imgur.com/wp5q52C.mp4";
    };
    BetterFolders = {
      enabled = false;
      sidebar = true;
      closeAllHomeButton = false;
      sidebarAnim = true;
      closeAllFolders = false;
      forceOpen = false;
      closeOthers = false;
      keepIcons = false;
      showFolderIcon = 1;
    };
    BetterGifAltText = {
      enabled = false;
    };
    BetterNotesBox = {
      enabled = false;
    };
    BetterRoleDot = {
      enabled = false;
      bothStyles = false;
      copyRoleColorInProfilePopout = false;
    };
    BetterUploadButton = {
      enabled = true;
    };
    BlurNSFW = {
      enabled = false;
    };
    CallTimer = {
      enabled = true;
      format = "stopwatch";
    };
    ClearURLs = {
      enabled = true;
    };
    ColorSighted = {
      enabled = false;
    };
    ConsoleShortcuts = {
      enabled = false;
    };
    CrashHandler = {
      enabled = true;
      attemptToPreventCrashes = true;
      attemptToNavigateToHome = false;
    };
    CustomRPC = {
      enabled = true;
      type = 0;
      timestampMode = 1;
      appID = "1211920200346370058";
      appName = "Grand Theft Auto VI";
      details = "Lucia's revenge";
      state = "Chapter 1";
      imageBig = "https://gtaforums.com/uploads/monthly_2024_01/gta-6-logo-oled-game-4k-3840x2160_1702946037.jpg.thumb.webp.f5c51c57a1fc89e392c2c94ffa578680.webp";
      imageBigTooltip = "Early Access v1.00";
      imageSmall = "https://static.wikia.nocookie.net/undertaleyellow/images/2/2b/Wild_Revolver_item.png/revision/latest?cb=20240107122333";
      imageSmallTooltip = "Apply for beta program";
      buttonOneText = "";
      buttonOneURL = "";
      buttonTwoURL = "";
      buttonTwoText = "";
    };
    EmoteCloner = {
      enabled = true;
    };
    Experiments = {
      enabled = false;
      enableIsStaff = false;
      forceStagingBanner = false;
    };
    F8Break = {
      enabled = false;
    };
    FakeNitro = {
      enabled = true;
      enableEmojiBypass = true;
      enableStickerBypass = true;
      enableStreamQualityBypass = true;
      transformStickers = true;
      transformEmojis = true;
      transformCompoundSentence = true;
      emojiSize = 48;
      stickerSize = 512;
      useHyperLinks = true;
      hyperLinkText = "{{NAME}}";
      disableEmbedPermissionCheck = true;
    };
    FakeProfileThemes = {
      enabled = true;
      nitroFirst = true;
    };
    Fart2 = {
      enabled = false;
      volume = {
      };
    };
    FixInbox = {
      enabled = true;
    };
    ForceOwnerCrown = {
      enabled = true;
    };
    FriendInvites = {
      enabled = false;
    };
    GameActivityToggle = {
      enabled = true;
      oldIcon = false;
    };
    GifPaste = {
      enabled = false;
    };
    iLoveSpam = {
      enabled = true;
    };
    IgnoreActivities = {
      enabled = false;
      listMode = 0;
      idsList = "";
      ignorePlaying = false;
      ignoreStreaming = false;
      ignoreListening = false;
      ignoreWatching = false;
      ignoreCompeting = false;
    };
    ImageZoom = {
      enabled = true;
      saveZoomValues = true;
      preventCarouselFromClosingOnClick = true;
      invertScroll = true;
      zoom = {
      };
      size = {
      };
      zoomSpeed = {
      };
      nearestNeighbour = false;
      square = true;
    };
    InvisibleChat = {
      enabled = true;
      savedPasswords = "omori";
    };
    KeepCurrentChannel = {
      enabled = true;
    };
    LastFMRichPresence = {
      enabled = false;
    };
    LoadingQuotes = {
      enabled = true;
      replaceEvents = true;
      enableDiscordPresetQuotes = false;
      additionalQuotes = "";
      additionalQuotesDelimiter = "|";
      enablePluginPresetQuotes = true;
    };
    MemberCount = {
      enabled = true;
      memberList = true;
      toolTip = true;
    };
    MessageClickActions = {
      enabled = false;
      enableDeleteOnClick = true;
      enableDoubleClickToEdit = true;
      enableDoubleClickToReply = true;
      requireModifier = false;
    };
    MessageLinkEmbeds = {
      enabled = false;
      listMode = "blacklist";
      idList = "";
      automodEmbeds = "never";
    };
    MessageLogger = {
      enabled = true;
      deleteStyle = "overlay";
      ignoreBots = true;
      ignoreSelf = true;
      ignoreUsers = "";
      ignoreChannels = "";
      ignoreGuilds = "";
      logEdits = true;
      logDeletes = true;
      collapseDeleted = false;
      inlineEdits = true;
    };
    MessageTags = {
      enabled = false;
    };
    MoreCommands = {
      enabled = true;
    };
    MoreKaomoji = {
      enabled = true;
    };
    MoreUserTags = {
      tagSettings = {
        WEBHOOK = {
          text = "Webhook";
          showInChat = true;
          showInNotChat = true;
        };
        OWNER = {
          text = "Owner";
          showInChat = true;
          showInNotChat = true;
        };
        ADMINISTRATOR = {
          text = "Admin";
          showInChat = true;
          showInNotChat = true;
        };
        MODERATOR_STAFF = {
          text = "Staff";
          showInChat = true;
          showInNotChat = true;
        };
        MODERATOR = {
          text = "Mod";
          showInChat = true;
          showInNotChat = true;
        };
        VOICE_MODERATOR = {
          text = "VC Mod";
          showInChat = true;
          showInNotChat = true;
        };
      };
    };
    Moyai = {
      enabled = false;
      volume = {
      };
      triggerWhenUnfocused = true;
      ignoreBots = true;
    };
    NoBlockedMessages = {
      enabled = true;
      ignoreMessages = false;
    };
    NoDevtoolsWarning = {
      enabled = false;
    };
    NoF1 = {
      enabled = true;
    };
    NoReplyMention = {
      enabled = false;
      userList = "1234567890123445,1234567890123445";
      shouldPingListed = true;
      inverseShiftReply = false;
    };
    NoScreensharePreview = {
      enabled = false;
    };
    NoTrack = {
      enabled = true;
      disableAnalytics = true;
    };
    NoUnblockToJump = {
      enabled = true;
    };
    NSFWGateBypass = {
      enabled = true;
    };
    oneko = {
      enabled = false;
    };
    petpet = {
      enabled = true;
    };
    PinDMs = {
      enabled = false;
      pinOrder = 0;
      dmSectioncollapsed = false;
    };
    PlainFolderIcon = {
      enabled = false;
    };
    PlatformIndicators = {
      enabled = true;
      list = true;
      badges = true;
      messages = true;
      colorMobileIndicator = true;
    };
    QuickMention = {
      enabled = false;
    };
    QuickReply = {
      enabled = false;
    };
    ReadAllNotificationsButton = {
      enabled = true;
    };
    RelationshipNotifier = {
      enabled = true;
      offlineRemovals = true;
      groups = true;
      servers = true;
      friends = true;
      friendRequestCancels = true;
      notices = true;
    };
    RevealAllSpoilers = {
      enabled = true;
    };
    ReverseImageSearch = {
      enabled = true;
    };
    ReviewDB = {
      enabled = false;
    };
    RoleColorEverywhere = {
      enabled = false;
    };
    SendTimestamps = {
      enabled = false;
      replaceMessageContents = true;
    };
    ServerListIndicators = {
      enabled = true;
      mode = 3;
    };
    Settings = {
      enabled = true;
      settingsLocation = "aboveActivity";
    };
    ShikiCodeblocks = {
      enabled = true;
      theme = "https://raw.githubusercontent.com/shikijs/shiki/0b28ad8ccfbf2615f2d9d38ea8255416b8ac3043/packages/shiki/themes/dark-plus.json";
      tryHljs = "SECONDARY";
      useDevIcon = "GREYSCALE";
      bgOpacity = 100;
    };
    ShowAllMessageButtons = {
      enabled = true;
    };
    ShowConnections = {
      enabled = true;
      iconSpacing = 1;
      iconSize = 32;
    };
    ShowHiddenChannels = {
      enabled = true;
      showMode = 0;
      hideUnreads = true;
      defaultAllowedUsersAndRolesDropdownState = true;
    };
    ShowMeYourName = {
      enabled = true;
      mode = "nick-user";
      displayNames = false;
      inReplies = false;
    };
    SilentMessageToggle = {
      enabled = false;
    };
    SilentTyping = {
      enabled = false;
    };
    SortFriendRequests = {
      enabled = true;
      showDates = false;
    };
    SpotifyControls = {
      enabled = true;
      hoverControls = false;
    };
    SpotifyCrack = {
      enabled = true;
      noSpotifyAutoPause = true;
      keepSpotifyActivityOnIdle = true;
    };
    SpotifyShareCommands = {
      enabled = false;
    };
    StartupTimings = {
      enabled = true;
    };
    SupportHelper = {
      enabled = true;
    };
    TextReplace = {
      enabled = false;
    };
    TimeBarAllActivities = {
      enabled = false;
    };
    TypingIndicator = {
      enabled = true;
      includeCurrentChannel = true;
      includeMutedChannels = false;
      includeBlockedUsers = true;
      indicatorMode = 3;
    };
    TypingTweaks = {
      enabled = true;
      showAvatars = true;
      showRoleColors = true;
      alternativeFormatting = true;
    };
    Unindent = {
      enabled = false;
    };
    ReactErrorDecoder = {
      enabled = false;
    };
    UrbanDictionary = {
      enabled = true;
    };
    UserVoiceShow = {
      enabled = true;
      showInUserProfileModal = true;
      showInMemberList = true;
      showInMessages = true;
    };
    USRBG = {
      enabled = false;
      nitroFirst = true;
      voiceBackground = true;
    };
    UwUifier = {
      enabled = false;
    };
    VoiceChatDoubleClick = {
      enabled = false;
    };
    VcNarrator = {
      enabled = false;
      volume = 1;
      rate = 1;
      joinMessage = "{{USER}} joined";
      leaveMessage = "{{USER}} left";
      moveMessage = "{{USER}} moved to {{CHANNEL}}";
      muteMessage = "{{USER}} Muted";
      unmuteMessage = "{{USER}} unmuted";
      deafenMessage = "{{USER}} deafened";
      undeafenMessage = "{{USER}} undeafened";
      sayOwnName = false;
      latinOnly = false;
      voice = "Afrikaans espeak-ng";
    };
    VencordToolbox = {
      enabled = false;
    };
    ViewIcons = {
      enabled = true;
      format = "webp";
      imgSize = "1024";
    };
    ViewRaw = {
      enabled = true;
      clickMethod = "Left";
    };
    WebContextMenus = {
      enabled = true;
      addBack = true;
    };
    GreetStickerPicker = {
      enabled = true;
      greetMode = "Greet";
    };
    WhoReacted = {
      enabled = false;
    };
    Wikisearch = {
      enabled = false;
    };
    FavoriteEmojiFirst = {
      enabled = true;
    };
    NoRPC = {
      enabled = false;
    };
    NoSystemBadge = {
      enabled = false;
    };
    PermissionsViewer = {
      enabled = true;
      permissionsSortOrder = 0;
      defaultPermissionsDropdownState = false;
    };
    Translate = {
      enabled = true;
      showChatBarButton = true;
      service = "google";
      deeplApiKey = "";
      autoTranslate = false;
      showAutoTranslateTooltip = true;
      receivedInput = "auto";
      receivedOutput = "en";
      sentInput = "auto";
      sentOutput = "en";
    };
    ValidUser = {
      enabled = true;
    };
    VolumeBooster = {
      enabled = true;
      multiplier = 2;
    };
    NoPendingCount = {
      enabled = true;
      hideFriendRequestsCount = true;
      hideMessageRequestsCount = true;
      hidePremiumOffersCount = true;
    };
    NoProfileThemes = {
      enabled = true;
    };
    UnsuppressEmbeds = {
      enabled = false;
    };
    MutualGroupDMs = {
      enabled = false;
    };
    BiggerStreamPreview = {
      enabled = true;
    };
    FavoriteGifSearch = {
      enabled = false;
    };
    NormalizeMessageLinks = {
      enabled = true;
    };
    OpenInApp = {
      enabled = true;
      spotify = true;
      steam = true;
      epic = true;
      tidal = true;
      itunes = true;
    };
    PreviewMessage = {
      enabled = false;
    };
    "AI Noise Suppression" = {
      enabled = true;
      isEnabled = false;
    };
    SecretRingToneEnabler = {
      enabled = true;
      onlySnow = true;
    };
    VoiceMessages = {
      enabled = true;
      noiseSuppression = true;
      echoCancellation = true;
    };
    CopyUserURLs = {
      enabled = true;
    };
    FixSpotifyEmbeds = {
      enabled = false;
      volume = 10;
    };
    WebKeybinds = {
      enabled = true;
    };
    Dearrow = {
      enabled = false;
      hideButton = false;
      replaceElements = 0;
    };
    PictureInPicture = {
      enabled = false;
    };
    ThemeAttributes = {
      enabled = false;
    };
    OnePingPerDM = {
      enabled = true;
      channelToAffect = "both_dms";
      allowMentions = false;
      allowEveryone = false;
    };
    PermissionFreeWill = {
      enabled = true;
      lockout = true;
      onboarding = true;
    };
    NoMosaic = {
      enabled = false;
    };
    NoTypingAnimation = {
      enabled = false;
    };
    SuperReactionTweaks = {
      enabled = true;
      superReactByDefault = false;
      unlimitedSuperReactionPlaying = false;
      superReactionPlayingLimit = 0;
    };
    ClientTheme = {
      enabled = true;
      color = "000000";
    };
    FixImagesQuality = {
      enabled = false;
    };
    Decor = {
      enabled = false;
    };
    NotificationVolume = {
      enabled = false;
      notificationVolume = 100;
    };
    XSOverlay = {
      enabled = false;
    };
    BetterGifPicker = {
      enabled = true;
    };
    FixCodeblockGap = {
      enabled = false;
    };
    FixYoutubeEmbeds = {
      enabled = true;
    };
    ChatInputButtonAPI = {
      enabled = true;
    };
    DisableCallIdle = {
      enabled = true;
    };
    NewGuildSettings = {
      enabled = true;
      guild = true;
      everyone = true;
      role = true;
      events = true;
      highlights = true;
      messages = 3;
      showAllChannels = true;
    };
    BetterRoleContext = {
      enabled = true;
    };
    ResurrectHome = {
      enabled = false;
    };
    FriendsSince = {
      enabled = true;
    };
    BetterSettings = {
      enabled = true;
      disableFade = true;
      organizeMenu = true;
      eagerLoad = true;
    };
    OverrideForumDefaults = {
      enabled = false;
      defaultLayout = 1;
      defaultSortOrder = 0;
    };
    UnlockedAvatarZoom = {
      enabled = false;
    };
    ShowHiddenThings = {
      enabled = true;
      showTimeouts = true;
      showInvitesPaused = true;
      showModView = true;
      disableDiscoveryFilters = true;
      disableDisallowedDiscoveryFilters = true;
    };
    BetterSessions = {
      enabled = true;
      backgroundCheck = false;
    };
    ImplicitRelationships = {
      enabled = true;
      sortByAffinity = true;
    };
    StreamerModeOnStream = {
      enabled = false;
    };
    ImageLink = {
      enabled = false;
    };
    MessageLatency = {
      enabled = true;
      latency = 2;
      detectDiscordKotlin = true;
      showMillis = false;
    };
    PauseInvitesForever = {
      enabled = false;
    };
    ReplyTimestamp = {
      enabled = true;
    };
    VoiceDownload = {
      enabled = true;
    };
    WebScreenShareFixes = {
      enabled = true;
    };
    ShowTimeoutDuration = {
      enabled = true;
      displayStyle = "ssalggnikool";
    };
    PartyMode = {
      enabled = false;
      superIntensePartyMode = 1;
    };
    AutomodContext = {
      enabled = false;
    };
    CtrlEnterSend = {
      enabled = false;
      submitRule = "ctrl+enter";
      sendMessageInTheMiddleOfACodeBlock = true;
    };
    CustomIdle = {
      enabled = false;
      idleTimeout = {
      };
      remainInIdle = true;
    };
    NoDefaultHangStatus = {
      enabled = false;
    };
    NoServerEmojis = {
      enabled = false;
    };
    ReplaceGoogleSearch = {
      enabled = false;
    };
    ValidReply = {
      enabled = true;
    };
    DontRoundMyTimestamps = {
      enabled = true;
    };
    MaskedLinkPaste = {
      enabled = false;
    };
    Summaries = {
      enabled = true;
      summaryExpiryThresholdDays = 3;
    };
    ServerInfo = {
      enabled = true;
    };
    MessageUpdaterAPI = {
      enabled = true;
    };
    AppleMusicRichPresence = {
      enabled = false;
    };
    CopyEmojiMarkdown = {
      enabled = false;
    };
    NoOnboardingDelay = {
      enabled = true;
    };
    UserSettingsAPI = {
      enabled = true;
    };
    YoutubeAdblock = {
      enabled = true;
    };
    ConsoleJanitor = {
      enabled = true;
      disableLoggers = false;
      disableSpotifyLogger = true;
      whitelistedLoggers = "GatewaySocket; Routing/Utils";
    };
    MentionAvatars = {
      enabled = false;
    };
    AlwaysExpandRoles = {
      enabled = true;
    };
    CopyFileContents = {
      enabled = false;
    };
    NoMaskedUrlPaste = {
      enabled = false;
    };
    StickerPaste = {
      enabled = false;
    };
    FullSearchContext = {
      enabled = true;
    };
    AccountPanelServerProfile = {
      enabled = true;
      prioritizeServerProfile = false;
    };
    UserMessagesPronouns = {
      enabled = false;
      pronounsFormat = "LOWERCASE";
      showSelf = true;
      showInMessages = true;
      showInProfile = true;
    };
    DynamicImageModalAPI = {
      enabled = true;
    };
    FullUserInChatbox = {
      enabled = false;
    };
    IrcColors = {
      enabled = false;
    };
    HideMedia = {
      enabled = false;
    };
  };
  notifications = {
    timeout = 5000;
    position = "bottom-right";
    useNative = "always";
    logLimit = 50;
  };
  cloud = {
    authenticated = false;
    url = "https://api.vencord.dev/";
    settingsSync = false;
    settingsSyncVersion = 1746383745596;
  };
  macosTranslucency = false;
  eagerPatches = false;
};
};

home.stateVersion = "25.05";

};
}
