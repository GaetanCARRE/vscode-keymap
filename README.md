# VS Code keymap for Linux

`keybindings.nix` is the source of the 37 custom keybindings: keys, commands,
optional context conditions (`when`), and command arguments (`args`). It does
not install or enable anything. Edit this file to change your shortcuts.

`keybindings.json` is an export for standard VS Code installations.
Home Manager uses the Nix list directly and generates VS Code's JSON configuration
during the rebuild.

## Import into Home Manager

Copy this repository into your Nix configuration, then import the keybindings
into your existing Home Manager configuration:

```nix
programs.vscode.profiles.default.keybindings =
  import ./vscode-keymap/keybindings.nix;
```

Adjust the relative path to match the repository location. Use a Home Manager
version that supports `programs.vscode.profiles`.

### Complete configuration example

If you also want Home Manager to enable VS Code and install VSCodeVim,
add the following to your Home Manager module:

```nix
{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      keybindings = import ./vscode-keymap/keybindings.nix;
      extensions = [ pkgs.vscode-extensions.vscodevim.vim ];
    };
  };
}
```

Allow the unfree `vscode` package in your existing nixpkgs configuration.
This example belongs in a Home Manager module, rather than directly in a NixOS
system module. VSCodeVim is required for shortcuts that depend on Vim modes.

Apply the changes using your usual configuration rebuild command. For standalone Home Manager:

```sh
home-manager switch
```

## Export JSON for a standard installation

Edit only `keybindings.nix`, then regenerate the JSON export:

```sh
nix-instantiate --eval --strict --json keybindings.nix > keybindings.json
```

You can then copy `keybindings.json` to `~/.config/Code/User/keybindings.json`.

Reference: [Home Manager — VS Code](https://home-manager.dev/manual/unstable/options/home-manager/programs/vscode.html).

## GNOME / Forge configuration (NixOS)

`gnome-forge.nix` stores the supplied keyd and GNOME/Forge configuration as a
separate NixOS module. Import it in your NixOS system configuration:

```nix
{
  imports = [ ./vscode-keymap/gnome-forge.nix ];
}
```

This module enables keyd, maps Caps Lock to a Hyper layer, sets four static
workspaces, removes GNOME application shortcuts for keys 1–4, and configures
workspace switching, moving windows, and Forge focus navigation with h/j/k/l.
GNOME and the Forge extension must already be installed and enabled; this module
only adds their settings. It is independent of the VS Code Home Manager setup.

The original modifiers are preserved: `hyper:C-A-S-M` includes Shift, but
workspace switching and Forge focus shortcuts use Control+Alt+Super without Shift.
Caps Lock+1–4 therefore matches the window-moving shortcuts rather than the
workspace-switching shortcuts; the Forge focus shortcuts do not match the Hyper
layer. To use Caps Lock for switching/focus and Caps Lock+Shift for moving windows,
change the layer header to `hyper:C-A-M`.

Reference: [keyd modifier layers](https://github.com/rvaiya/keyd/blob/master/docs/keyd.scd).
