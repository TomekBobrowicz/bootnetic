# bootnetic &nbsp; [![bluebuild build badge](https://github.com/tomekbobrowicz/bootnetic/actions/workflows/build.yml/badge.svg)](https://github.com/tomekbobrowicz/bootnetic/actions/workflows/build.yml)

See the [BlueBuild docs](https://blue-build.org/how-to/setup/) for quick setup instructions for setting up your own repository based on this template.

After setup, it is recommended you update this README to describe your custom image.

## What Makes This Image Different?

This image is based on [`ghcr.io/ublue-os/kinoite-main`](https://github.com/ublue-os/kinoite) (Fedora Kinoite) and adds the following customizations.

### Base & Repositories

- **Base image**: Fedora Kinoite (`kinoite-main`).
- **COPR repositories**: `peterwu/iosevka`, `theblackdon/kineticwe`, `lionheartp/Hyprland`, `linuxgamerlife/lgl-dnf-helper`, `linuxgamerlife/lgl-emoji-picker`.
- **Terra repository** added for extra packages.

### Desktop & Window Management

- **KineticWE** replaces `kwin-common` for enhanced KWin/Wayland effects.

### Added Packages (RPM)

- Theming/tools: `noctalia-git`, `qt5ct`, `qt6ct`, `nwg-look`, `adw-gtk3-theme`
- Terminal: `kitty`, `fish`, `fastfetch`, `btop`, `htop`, `git`, `zoxide`, `eza`, `neovim`
- Fonts: `iosevka-fonts`
- Media: `gwenview`, `haruna`, `zathura`
- Helpers: `lgl-emoji-picker`, `lgl-dnf-helper`

### Removed Packages

- `firefox`, `firefox-langpacks`

### Added Applications (Flatpak)

- `com.google.Chrome`
- `org.equicord.equibop`

### Nix + Home Manager Bootstrap

- Single-user **Nix** is installed on first boot (`nix.mount` bind mounts `/var/nix` → `/nix`; `nix-firstboot.service` runs the installer).
- **Home Manager** config (`home.nix` + `dotfiles/`) sets up: Fish as the default shell, Kitty, Starship, Fastfetch, Zoxide, and Eza.
- Home Manager is configured for user `buber` (update `home.username` / `home.homeDirectory` in `home.nix` to match your user).

> Update this section whenever you add or remove packages, apps, or configuration.

## Installation

> [!WARNING]
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.

To rebase an existing atomic Fedora installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/tomekbobrowicz/bootnetic:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/tomekbobrowicz/bootnetic:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## ISO

If build on Fedora Atomic, you can generate an offline ISO with the instructions available [here](https://blue-build.org/how-to/generate-iso/#_top). These ISOs cannot unfortunately be distributed on GitHub for free due to large sizes, so for public projects something else has to be used for hosting.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/tomekbobrowicz/bootnetic
```
