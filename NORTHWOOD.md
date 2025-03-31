# Northwood Altera Linux

See [Building Linux Kernel](https://www.rocketboards.org/foswiki/Documentation/BuildingBootloaderStratix10#Building_Linux_Kernel) from the Building Bootloader Stratix10 tutorial provided by Altera.

## Developer Environment
```bash
$ nix develop .#
```

This will drop you into a shell with all of the required tools to compile the Altera fork of the linux kernel.


### menuconfig
Uncomment out `# menuconfig = true` in the `flake.nix` and reenter your shell with `nix develop .#`

### xconfig
Uncomment out `# xconfig = true` in the `flake.nix` and reenter your shell with `nix develop .#`

## Building
Enter the shell and see supported aliases using just.

```bash
northwood@build4:~/linux-socfpga$ just
Available recipes:
    default     # Display this message

    [Build]
    build       # Build Linux Kernel Image for Northwood Beamformer
    clean       # Removes build artifacts and generated configuration files
    link-config # Link the nix-build generated linux config to .config
    menuconfig  # Configure linux kernel parameters via menuconfig. You will need to be in the shell with menuconfig = true; in the flake.nix
    xconfig     # Configure linux kernel parameters via xconfig. You will need to be in the shell with xconfig = true; in the flake.nix
```
