# Repository Guidelines

## Project Structure & Module Organization
This repository contains personal Linux dotfiles and setup modules, organized by feature.
- Top level: `flake.nix`, `home.nix`, and root `Makefile` for Home Manager and system updates.
- Feature directories (for example `hyprland/`, `zsh/`, `terminal/`, `pipewire/`, `docker/`) contain module-specific install/config logic.
- Config files are typically staged under `*/config/` and applied with GNU Stow.
- Helper scripts live beside their module (for example `hyprland/config/.config/hypr/*.sh`).

## Build, Test, and Development Commands
Use these commands from the repository root unless noted.
- `make install`: reload Hyprland plugins and apply Home Manager (`home-manager switch --flake .#MiniPluginBaby`).
- `make update`: update Arch packages (`yay -Syu`), Hyprland plugins, Nix flake inputs, and firmware.
- `make -C hyprland install`: install Hyprland-related packages.
- `make -C <module> config`: stow module config into `$HOME` (example: `make -C terminal config`).
- `bash -n path/to/script.sh`: quick syntax check for shell scripts before commit.

## Coding Style & Naming Conventions
- Shell scripts: use `#!/usr/bin/env bash` and prefer `set -euo pipefail` for new scripts.
- Indentation: tabs in `Makefile`s, 2 spaces in shell conditionals/blocks.
- Keep filenames descriptive and lowercase (examples: `launch-fzf.sh`, `hyprsunset-manager.sh`).
- Prefer small, single-purpose scripts colocated with the module they configure.

## Testing Guidelines
There is no centralized automated test suite yet.
- Validate shell changes with `bash -n` and, where possible, run the script manually.
- For Hyprland config changes, reload and verify keybindings/workflow interactively.
- For Nix/Home Manager changes, run `home-manager switch --flake .#MiniPluginBaby` and confirm no evaluation errors.

## Commit & Pull Request Guidelines
Git history uses short, capitalized, action-oriented summaries (examples: `Added shortcut for color picking`, `Fixed path for tofimoji script`).
- Keep commit messages focused on one change.
- PRs should include: purpose, affected modules/paths, manual verification steps, and screenshots for visual/UI changes (bars, launchers, lock screen, themes).
- Link related issues/tasks when applicable.

## Security & Configuration Tips
- Do not commit secrets, tokens, or machine-specific private keys.
- Prefer environment variables or local, untracked overrides for sensitive values.
