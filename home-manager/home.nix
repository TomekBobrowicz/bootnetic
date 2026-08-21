{ config, pkgs, ... }:

{
  # --- Nix Configuration ---
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;

  # --- Home Manager ---
  home.username = "buber";
  home.homeDirectory = "/home/buber";
  home.stateVersion = "26.05";

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

      # Zoxide
      if type -q zoxide
        zoxide init fish | source
      end

      # Starship
      starship init fish | source
    '';

    shellAliases = {
      ll = "eza -l --icons";
      ls = "eza --icons=always";
      ff = "fastfetch";

    # Nix / Home Manager
      hms = "nh home switch ~/.config/home-manager";
      hmu = "nh home switch ~/.config/home-manager --update";

    # Cleanup
      ngc = "nh clean all";

      update = "sudo bootc upgrade";

    };
  };

  # --- XDG Config Files ---
  xdg.configFile."fastfetch/config.jsonc".source =
    ./dotfiles/fastfetch.jsonc;

  xdg.configFile."fastfetch/logo.png".source =
    ./dotfiles/logo.png;

  xdg.configFile."logo.svg".source =
    ./dotfiles/logo.svg;

  xdg.configFile."kitty/noctalia.conf".source =
    ./dotfiles/kittytheme.conf;

  # --- Kitty Terminal Configuration ---
  programs.kitty = {
    enable = true;

    settings = {
      font_family = "Iosevka";
      font_size = "13.0";
      background_opacity = "0.95";
      confirm_os_window_close = 0;
    };

    extraConfig = ''
      disable_ligatures never
      cursor_shape beam
      scrollback_lines 10000
      repaint_delay 6
      sync_to_monitor yes

      # Tab bar
      tab_bar_edge top
      tab_bar_style powerline
      tab_powerline_style slanted
      tab_bar_align left
      tab_bar_min_tabs 2
      tab_bar_margin_width 0.0
      tab_bar_margin_height 2.5 1.5
      active_tab_font_style bold
      inactive_tab_font_style normal
      tab_activity_symbol " ● "

      tab_title_template "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title[:30]}{title[30:] and '…'} [{index}]"

      active_tab_title_template "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title[:30]}{title[30:] and '…'} [{index}]"

      shell fish

      # Include Noctalia's dynamically generated color palette
      include noctalia.conf
    '';
  };

  # --- Starship Prompt Configuration ---
  programs.starship = {
    enable = true;

    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      format = "$username$hostname$directory$git_branch$character";

      username = {
        show_always = true;
        format = "[$user]($style)";
        style_user = "bold blue";
      };

      hostname = {
        ssh_only = false;
        format = "@[$hostname]($style) ";
        style = "bold green";
      };
    };
  };

  # --- Additional User Packages ---
  home.packages = with pkgs; [
    eza
    fastfetch
    btop
    zoxide
    nh
  ];

  # --- Nix User Configuration ---
  xdg.configFile."nix/nix.conf".force = true;
}
