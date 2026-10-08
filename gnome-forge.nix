# NixOS module for keyd, GNOME workspaces, and Forge keybindings.
# Preserves the supplied configuration, including the Hyper modifier choice.
{ ... }:
{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main.capslock = "layer(hyper)";
        "hyper:C-A-S-M" = {};
      };
    };
  };

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/mutter".dynamic-workspaces = false;
        "org/gnome/desktop/wm/preferences".num-workspaces = 4;

        "org/gnome/shell/keybindings" =
          builtins.listToAttrs (map (i: {
            name = "switch-to-application-${toString i}";
            value = [];
          }) [ 1 2 3 4 ]);

        "org/gnome/desktop/wm/keybindings" =
          builtins.listToAttrs (map (i: {
            name = "switch-to-workspace-${toString i}";
            value = [ "<Control><Alt><Super>${toString i}" ];
          }) [ 1 2 3 4 ])
          // builtins.listToAttrs (map (i: {
            name = "move-to-workspace-${toString i}";
            value = [ "<Control><Alt><Super><Shift>${toString i}" ];
          }) [ 1 2 3 4 ]);

        "org/gnome/shell/extensions/forge/keybindings" = {
          window-focus-left = [ "<Control><Alt><Super>h" ];
          window-focus-down = [ "<Control><Alt><Super>j" ];
          window-focus-up = [ "<Control><Alt><Super>k" ];
          window-focus-right = [ "<Control><Alt><Super>l" ];
        };
      };
    }
  ];
}
