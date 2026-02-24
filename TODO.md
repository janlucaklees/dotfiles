# TODO

High-leverage improvements to make new-system setup faster, more reliable, and more complete.

## Bootstrap & Reliability
- Add a single `bootstrap` entry point that installs prerequisites (git, stow, doas), clones the repo, bootstraps `yay`, and runs module installs in a sane order.
- Provide a `--dry-run` or `--check` mode that validates prerequisites (network, doas config, AUR access, and required commands) before running any install steps.
- Add a `verify` target that runs `bash -n` + `shellcheck` (if available) on all scripts and a `nix flake check` to catch regressions early.
- Introduce basic logging in install scripts (timestamps + module names) and write a run log into `~/.cache/dotfiles/` for postmortem troubleshooting.

## Nix & Home Manager Coverage
- Convert more modules from ad‑hoc `yay` installs to Home Manager (or `nixpkgs`) to make setups reproducible and rollback‑friendly.
- Split `home.nix` into machine profiles (e.g., `laptop`, `desktop`, `work`) with shared core modules and per‑machine overrides.
- Move Hyprland config + scripts into a Home Manager module instead of relying on manual stow.
- Add `home.sessionVariables` for common env (e.g., `EDITOR`, `BROWSER`) to keep shell config minimal and consistent across shells.

## Package & Service Management
- Consolidate package lists into per‑module manifests (either Nix modules or a `packages.txt` per module) so it’s easy to audit and diff.
- Add systemd user services/timers for recurring tasks (cache refreshers, backups, background agents) instead of running them manually.
- Add a `system` module for system‑level packages/services (fwupd, NetworkManager, Bluetooth, etc.) with a single entry point.

## Shell & CLI UX
- Add a standard `bin/` entry for common scripts (launcher, ocrshot, emoji picker, etc.) and ensure they are in `$PATH` via Home Manager.
- Add a `help` command or `make help` output that lists available modules and common workflows.
- Add a `zsh`/`fish`/`bash` compatibility policy and a quick check to keep hooks portable.

## Secrets & Machine-Specific Data
- Introduce `sops-nix` or `agenix` for secrets (SSH keys, tokens, API keys) so they can live in-repo safely.
- Add a local override pattern (e.g., `config.local.nix` or `overrides/`) for machine‑specific settings that should not be committed.

## Documentation & Onboarding
- Create a `README.md` that describes the philosophy, module list, install order, and common tasks.
- Promote the “Post Install Cheat Sheet” into a structured setup guide with explicit prerequisites, expected prompts, and verification steps.
- Add a `TROUBLESHOOTING.md` with common failure modes (AUR keys, doas config, systemd issues, hyprpm errors).

## Maintenance & Cleanup
- Add a script to audit packages for duplicates and unused installs (especially across `yay` + Nix).
- Add a periodic cleanup task for caches/logs (e.g., `~/.cache/dmenu`, `~/.cache/dotfiles`).
- Standardize config locations under XDG (`~/.config`, `~/.local`, `~/.cache`) and document any intentional exceptions.

## UX Polish for New Machines
- Add a “first‑boot” script that sets hostname, locale, timezone, fonts, and enables key services.
- Add a quick “sanity check” script to verify hardware support (audio, BT, fingerprint, display scaling).
