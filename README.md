# nerdfont-search

A simple Nerd Font icon searcher using fzf.

## Disclaimer

This whole thing was completely vibe-coded with Claude Code. I got tired of having to go over to nerdfonts.com/cheat-sheet to find a glyph
and surprisingly there wasn't much in the way of tools that existed.

## Features

- Search through 12,883+ Nerd Font icons
- Interactive search with fzf
- Copies selected icon to clipboard
- Prints selected icon to stdout

## Installation

### Using Nix Flakes

#### Direct package reference

```nix
{
  inputs.nerdfont-search.url = "github:steven0351/nerdfont-search";

  outputs = { self, nixpkgs, nerdfont-search, ... }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      modules = [
        {
          environment.systemPackages = [
            nerdfont-search.packages.${system}.default
          ];
        }
      ];
    };
  };
}

```
#### Using the overlay

Add to your NixOS or home-manager configuration:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nerdfont-search.url = "github:steven0351/nerdfont-search";
  };

  outputs = { self, nixpkgs, nerdfont-search, ... }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      modules = [
        {
          nixpkgs.overlays = [ nerdfont-search.overlays.default ];
          environment.systemPackages = with pkgs; [
            nerdfont-search
          ];
        }
      ];
    };
  };
}
```


Or install it temporarily:

```bash
nix run github:steven0351/nerdfont-search
```

Or add to your shell:

```bash
nix shell github:steven0351/nerdfont-search
```

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/steven0351/nerdfont-search
cd nerdfont-search

# Generate the icon data
./update-data.sh

# Run the search
./nerdfont-search
```

## Usage

### Neovim Plugin

Requires [fzf-lua](https://github.com/ibhagwan/fzf-lua).

```vim
:NerdFontSearch
:NerdFontSearch git
```

Or from Lua:

```lua
require("nerdfont-search").search()
require("nerdfont-search").search({ query = "git" })
```

**Keybindings:**
- `Enter`: Insert icon at cursor
- `Ctrl-y`: Copy to clipboard

### CLI: Search for icons

```bash
nerdfont-search
# Or use the aliases:
nfs
nf-search

# Start with an initial search term:
nerdfont-search git
nfs python
```

This opens an interactive fzf search. Type to filter icons, use arrow keys to navigate, and press Enter to select. The selected icon will be:
- Printed to stdout
- Copied to your clipboard (macOS/Linux)

You can optionally provide search terms as arguments to start with that query pre-filled.

### Update icon database

When installed via Nix, the icon database is bundled with the package. To get updated icons, update your flake inputs and rebuild.

For manual installations, you can update the database:

```bash
./update-data.sh
```

Options:
- `--keep-data`: Keep the temporary data directory instead of cleaning it up

## Requirements

- fzf
- Python 3 (for updating)
- curl (for updating)
- pbcopy (macOS) or xclip/xsel (Linux) for clipboard support

## Development

Generate the icon data file:

```bash
./update-data.sh
```

Keep temporary files for debugging:

```bash
./update-data.sh --keep-data
```

## License

GPLv3
