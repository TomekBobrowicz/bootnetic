{ pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.package = pkgs.nix;

  home.username = "buber"; # Change to your username
  home.homeDirectory = "/home/buber"; # Change to your home path
  home.stateVersion = "26.05"; # Match current HM state version

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # --- Fish Shell Configuration ---
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -e LD_LIBRARY_PATH
      set gsettings (which gsettings 2>/dev/null)
      if test -n "$gsettings"
        # Nix environment integration tweaks if needed
      end
      set -g fish_greeting ""

      # Environment variables
      set -gx EDITOR nvim
      set -gx VISUAL nvim

      # Vi keybindings (if desired)
      # fish_vi_key_bindings

      # Custom prompt or initializers
      if type -q zoxide
        zoxide init fish | source
      end
      starship init fish | source

         '';
    shellAliases = {
      ll = "eza -l --icons";
      ls = "eza --icons";
      ff = "fastfetch";
      rebuild = "home-manager switch --flake .";
      update = "sudo bootc upgrade";
    };
  };
xdg.configFile."fastfetch/config.jsonc".source = ./dotfiles/fastfetch.jsonc;
xdg.configFile."fastfetch/logo.png".source = ./dotfiles/logo.png;

  # --- Kitty Terminal Configuration ---
xdg.configFile."kitty/noctalia.conf".source = ./dotfiles/kittytheme.conf;

programs.kitty = {
    enable = true;
    settings = {
      font_family = "Iosevka";
      font_size = "13.0";
      background_opacity = "0.95";
      confirm_os_window_close = 0;
    };
    extraConfig = '' disable_ligatures never
cursor_shape beam
scrollback_lines 10000
repaint_delay 6
sync_to_monitor yes
confirm_os_window_close 0

# Tab bar
tab_bar_edge            top
tab_bar_style           powerline
tab_powerline_style     slanted
tab_bar_align           left
tab_bar_min_tabs        2
tab_bar_margin_width    0.0
tab_bar_margin_height   2.5 1.5
active_tab_font_style   bold
# inactive_tab_foreground #bfc9bf
# inactive_tab_background #101411
inactive_tab_font_style normal
tab_activity_symbol     " ● "
tab_title_template      "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title[:30]}{title[30:] and '…'} [{index}]"
active_tab_title_template "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title[:30]}{title[30:] and '…'} [{index}]"

shell fish

# Include Noctalia's dynamically generated color palette
      include noctalia.conf

  '';
  };
  # --- Starship Prompt Configuration ---
  programs.starship = {
    enable = true;

    # Automatically integrates with enabled shells (fish, bash, zsh)
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    # Basic configuration options
    settings = {
      add_newline = true;

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
      };

      # Custom module formatting if needed
      package.disabled = false;
    };
  };

  # --- Additional User Packages ---
  home.packages = with pkgs; [
    eza
    fastfetch
    btop
    zoxide

  ];

# xdg.configFile."mimeapps.list".force = true;
xdg.configFile."nix/nix.conf".force = true;

}
