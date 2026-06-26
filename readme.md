# dotfiles

Portable tool configs (neovim, tmux, zsh) for my Mac, a Linux dev box, and the
`django_vines` devcontainer — managed with one [GNU stow](https://www.gnu.org/software/stow/)
repo. A shared [Catppuccin](https://catppuccin.com/) theme with a different
flavour per environment ties nvim, tmux and the shell prompt together — see
[Theming](#theming).

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

- **Mac** — clone + `bootstrap` → stows `devops mac`, runs `devops/setup` then
  `mac/setup` (`brew install stow neovim tmux lazygit starship` + `pipx install
  rstfmt` — rstfmt is a PyPI package, not a Homebrew formula).
- **Linux dev / prod** — clone + `bootstrap` → stows `devops` only and runs
  `devops/setup` (installs `starship` to `~/.local/bin` and clones the pinned
  `catppuccin/tmux` theme for the themed prompt + status bar).
- **Devcontainer** — `django_vines`' `.devcontainer/post-create.sh` clones this
  repo and runs `bootstrap` (detected via `BUILD_ENV`). The binaries
  (`neovim`, `tmux`, `lazygit`, `rstfmt`, `starship`) and the `catppuccin/tmux`
  theme clone must be **baked into the image's Dockerfile** — the runtime egress
  firewall blocks apt/PyPI/the starship installer/GitHub clones, so `devops/setup`
  and `devcontainer/setup` are only a best-effort fallback.

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

| Package        | Stowed on                | Owns                                                                       |
| -------------- | ------------------------ | -------------------------------------------------------------------------- |
| `devops`       | mac, linux, devcontainer | `.zshrc`, `tmux.conf`, all of `nvim/`, `starship.toml`, `setup` — the base |
| `mac`          | mac only                 | `zsh/local.zsh`, `tmux/local.conf` (pbcopy), `nvim/.../mac.lua`, `setup`   |
| `devcontainer` | container only           | `tmux/local.conf` (xclip), `nvim/.../container.lua`, `setup`               |

`linux` has no package — `devops` alone covers it. Add one later if it diverges.

## Theming

One [Catppuccin](https://catppuccin.com/) theme family across nvim, tmux and the
shell prompt, with a **different flavour + accent per environment** so a glance
tells you where you are:

| Environment  | Flavour   | Accent | Prompt badge     |
| ------------ | --------- | ------ | ---------------- |
| mac          | Mocha     | blue   | ` mac `          |
| devcontainer | Frappé    | green  | ` devcontainer ` |
| prod / linux | Macchiato | red    | ` PROD `         |

Red on prod is a deliberate "you are on production" signal.

How each tool is themed, following the base-plus-overlay rule (`devops` carries
the prod defaults; the overlay re-sets them):

- **nvim** — `catppuccin/nvim` via `devops/.../plugins/colorscheme.lua` (default
  flavour Macchiato). The `mac`/`devcontainer` overlays set their flavour in
  `mac.lua`/`container.lua`; LazyVim loads overlay files last, so they win.
- **tmux** — the [`catppuccin/tmux`](https://github.com/catppuccin/tmux) plugin
  (manual install, pinned `v2.3.0`), cloned by the setup hooks to
  `~/.config/tmux/plugins/catppuccin/tmux`. The base sets the Macchiato/red
  defaults; each overlay's `tmux/local.conf` re-sets `@catppuccin_flavor` and the
  `@env_*` badge knobs. These are sourced _before_ the plugin runs, and the
  status line is assembled _after_ (so the plugin's `@thm_*` palette is ready).
  The `run` is guarded on the plugin being present, so devops still gives a plain
  bar before setup has cloned it.
- **zsh** — [Starship](https://starship.rs/) with a shared `starship.toml`. The
  per-env badge + accent are chosen from `$DOTFILES_ENV` (exported by `.zshrc`,
  detected like `bootstrap`; pre-set it to override, e.g. `linux` to drop the
  PROD badge). Starship is initialised last in `.zshrc`, so it owns the prompt
  while oh-my-zsh (mac only) keeps providing completions/plugins.

## Adding config

- **New portable config** → add it under `devops/.config/...`.
- **Machine-specific tmux** → add lines to that package's
  `.config/tmux/local.conf` (the base ends with `source-file -q
~/.config/tmux/local.conf`, so any overlay is picked up; absent overlay is a
  no-op).
- **Machine-specific nvim** → drop a `lua/plugins/*.lua` in the overlay package;
  LazyVim auto-loads every plugin file, so no wiring is needed. Use a filename
  the base doesn't use (`mac.lua`, `container.lua`).
- **Machine-specific zsh** → add a `.config/zsh/local.zsh` to the overlay package
  (the base `.zshrc` ends with `source ~/.config/zsh/local.zsh`, picked up if
  present). It is sourced _before_ the Starship init, so an oh-my-zsh prompt
  can't clobber it.
- **Optional binaries** → guard the plugin so `devops` stays safe everywhere,
  e.g. `cond = vim.fn.executable("lazygit") == 1`.

After editing, re-run `bootstrap` (or `stow` the package) and restart the tool.

## Design in one paragraph

One repo, multiple stow packages: every machine stows `devops` plus at most one
mutually-exclusive overlay (`mac` _or_ `devcontainer`; the Linux box stows only
`devops`). `devops` must be safe and functional on any OS by itself — portability
lives in **runtime guards inside the config** (executable checks, `source-file
-q`, `if-shell`), not in requiring an overlay. Overlays are **thin and additive**:
they only add files at _new_ paths and never edit a file `devops` owns, because
stow symlinks files rather than merging them. Each package also carries an
optional `setup` hook for the binaries its config needs, keeping the
content-vs-provisioning split clean.
