# Display this message
default:
  @just --list

# Build Linux Kernel Image for Northwood Beamformer
[group('Build')]
build:
  make -j$(nproc) $makeFlags

# Removes build artifacts and generated configuration files
[group('Build')]
clean:
  @make clean
  @make distclean
  @make mrproper

# Link the nix-build generated linux config to .config
[group('Build')]
link-config:
  ln -sf $NIX_CONFIGFILE .config
  
# Configure linux kernel parameters via menuconfig. You will need to be in the shell with menuconfig = true; in the flake.nix
[group('Build')]
menuconfig:
  make menuconfig

# Configure linux kernel parameters via xconfig. You will need to be in the shell with xconfig = true; in the flake.nix
[group('Build')]
xconfig:
  make xconfig
