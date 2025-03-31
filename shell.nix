{ pkgs ? import <nixpkgs> {}
, target ? "aarch64-multiplatform"
, system
# Optionally add dependencies for xconfig and menu config 
, menuconfig ? false
, xconfig ? false
, fit-generation ? false
}:
let
  lib = pkgsBuild.lib;
  # If we are aarch64-linux, then we do not need a cross-toolchain.
  # Otherwise, grab the pkgsCross
  #
  # Notes on cross-compilation
  # https://nixos.wiki/wiki/Cross_Compiling#Lazy_cross-compiling
  # https://matthewbauer.us/blog/beginners-guide-to-cross.html
  shouldCross = system == "aarch64-linux";
  pkgsCross =
    if shouldCross
    then builtins.trace "using native pkgs" pkgs
    else builtins.trace "using pkgsCross" pkgs.pkgsCross.${target};
  # Even if we are cross-compiling we still want the pkg-config and friends for the machine we are building on, not building for.
  pkgsBuild = pkgsCross.buildPackages;
  menuconfigAttrs = if menuconfig then [ pkgsBuild.pkg-config pkgsBuild.ncurses ] else [];
  xconfigAttrs = if xconfig then [ pkgsBuild.pkg-config pkgsBuild.qt5.qtbase ] else [];
  fitGenerationAttrs = if fit-generation then [ pkgsBuild.zstd pkgsBuild.xz pkgsBuild.ubootTools ] else [];
  # We want to use the same build environment that our nix derivation uses but with some new friends.
  #
  # This is why we choose to use overrideAttrs
  # https://ryantm.github.io/nixpkgs/using/overrides/#sec-pkg-overrideAttrs
  configfile = pkgsCross.altera-linux.configfile;
  initrd = if fit-generation then pkgsCross.beamformer.netbootRamdisk else "";
  fit-config = if fit-generation then pkgsBuild.beamformer-fit-config else "";
  drv = pkgsCross.altera-linux.overrideAttrs(final: prev: {
    # give it a new name so we can differentiate between nix build derivations and nix shell roots
    pname = "northwood-altera-linux";
    nativeBuildInputs = builtins.concatLists [
      # our build tools for
      prev.nativeBuildInputs
      # add our optional inputs
      menuconfigAttrs
      xconfigAttrs
      fitGenerationAttrs
    ];
    shellHook = ''
      echo "================================================"
      echo "==         Caveat Lector                      =="
      echo "================================================"
      echo "This shell pulls in a few extraneous dependencies"
      echo "The linux configfile is stored in $NIX_CONFIGFILE and can be copied locally using `just link-config`"
    '' + lib.strings.optionalString fit-generation ''
      echo "Initrd stored in \$INITRD environment variable."
      echo "Fit Image stored in \$FIT_CONFIG"
      echo "See the buildPhase of northwood-nixpkgs/pkgs/machines/beamformer/generate-fit.nix for building image"

    '';
    NIX_CONFIGFILE=configfile;
    INITRD="${initrd}/initrd.zst";
    FIT_CONFIG=fit-config;
  });
in
drv
