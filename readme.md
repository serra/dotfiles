# dotfiles

Portable tool configs (neovim, tmux) for my Mac, a Linux dev box, and the
`django_vines` devcontainer — managed with one [GNU stow](https://www.gnu.org/software/stow/)
repo.

## Install

```bash
git clone <repo-url> ~/.dotfiles
~/.dotfiles/bin/bootstrap
```

`bootstrap` detects the machine, stows the right packages, and runs each
package's binary-install hook. Force a profile when detection is wrong:

```bash
~/.dotfiles/bin/bootstrap mac          # or: linux | devcontainer
```

> **First run needs stow.** `bootstrap` calls `stow`, so install it first:
> `brew install stow` (mac) / `apt install stow` (linux). After that the
> `mac` hook keeps it up to date.

### Per environment

- **Mac** — clone + `bootstrap` → stows `devops mac`, runs `mac/setup`
  (`brew install stow neovim tmux lazygit rstfmt`).
- **Linux dev** — clone + `bootstrap` → stows `devops` only.
- **Devcontainer** — `django_vines`' `.devcontainer/post-create.sh` clones this
  repo and runs `bootstrap` (detected via `BUILD_ENV`). The binaries
  (`neovim`, `tmux`, `lazygit`, `rstfmt`) must be **baked into the image's
  Dockerfile** — the runtime egress firewall blocks apt/PyPI, so
  `devcontainer/setup` is only a best-effort fallback.

## Migrating existing configs in

`~/.config/nvim` and `~/.config/tmux` may already exist as their own dirs (or
git repos). Stow won't overwrite real files, so move them aside first:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.config/tmux ~/.config/tmux.bak
~/.dotfiles/bin/bootstrap
```

Then confirm the symlinks landed in `~/.config` and remove the `.bak` dirs.

## Packages

| Package | Stowed on | Owns |
|---|---|---|
| `devops` | mac, linux, devcontainer | `tmux.conf`, all of `nvim/` — the portable base |
| `mac` | mac only | `tmux/local.conf` (pbcopy), `nvim/.../mac.lua`, `setup` |
| `devcontainer` | container only | `tmux/local.conf` (xclip), `nvim/.../container.lua`, `setup` |

`linux` has no package — `devops` alone covers it. Add one later if it diverges.

## Adding config

- **New portable config** → add it under `devops/.config/...`.
- **Machine-specific tmux** → add lines to that package's
  `.config/tmux/local.conf` (the base ends with `source-file -q
  ~/.config/tmux/local.conf`, so any overlay is picked up; absent overlay is a
  no-op).
- **Machine-specific nvim** → drop a `lua/plugins/*.lua` in the overlay package;
  LazyVim auto-loads every plugin file, so no wiring is needed. Use a filename
  the base doesn't use (`mac.lua`, `container.lua`).
- **Optional binaries** → guard the plugin so `devops` stays safe everywhere,
  e.g. `cond = vim.fn.executable("lazygit") == 1`.

After editing, re-run `bootstrap` (or `stow` the package) and restart the tool.

## Design in one paragraph

One repo, multiple stow packages: every machine stows `devops` plus at most one
mutually-exclusive overlay (`mac` *or* `devcontainer`; the Linux box stows only
`devops`). `devops` must be safe and functional on any OS by itself — portability
lives in **runtime guards inside the config** (executable checks, `source-file
-q`, `if-shell`), not in requiring an overlay. Overlays are **thin and additive**:
they only add files at *new* paths and never edit a file `devops` owns, because
stow symlinks files rather than merging them. Each package also carries an
optional `setup` hook for the binaries its config needs, keeping the
content-vs-provisioning split clean.
