default: clean configure build

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

# Configure Linux Kernel Image for Northwood Beamformer
[group('Build')]
configure:
  runPhase configurePhase

# Configure linux kernel parameters via menuconfig. You will need to be in the shell with menuconfig = true; in the flake.nix
[group('Build')]
menuconfig:
  make menuconfig

# Configure linux kernel parameters via xconfig. You will need to be in the shell with xconfig = true; in the flake.nix
[group('Build')]
xconfig:
  make xconfig
