# Portable zsh base (stow package: devops). Safe and functional on its own, so
# prod/linux gets a working, themed shell with no overlay. Machine-specific bits
# (oh-my-zsh, language managers, aliases…) live in ~/.config/zsh/local.zsh,
# supplied by the mac/devcontainer overlay and sourced below — the same pattern
# tmux.conf uses for ~/.config/tmux/local.conf.

# Which environment am I on? Drives the Starship prompt badge + accent colour
# (see ~/.config/starship.toml). Respect a pre-set value so e.g. a non-prod Linux
# box can `export DOTFILES_ENV=linux` in its overlay to opt out of the red PROD
# badge; otherwise detect it the same way bin/bootstrap does.
if [ -z "${DOTFILES_ENV:-}" ]; then
  if [ "$(uname)" = "Darwin" ]; then DOTFILES_ENV=mac
  elif [ -n "${BUILD_ENV:-}" ] || [ -f /.dockerenv ]; then DOTFILES_ENV=devcontainer
  else DOTFILES_ENV=prod
  fi
fi
export DOTFILES_ENV

# Locally-installed binaries (e.g. starship from the devops setup hook on prod).
export PATH="$HOME/.local/bin:$PATH"

export EDITOR=nvim

# Per-machine overlay (oh-my-zsh, rbenv/pyenv, aliases…). Sourced BEFORE the
# prompt init so a framework prompt (oh-my-zsh) can't clobber Starship. A missing
# overlay is a silent no-op, so devops stands alone on any OS.
[ -f ~/.config/zsh/local.zsh ] && source ~/.config/zsh/local.zsh

# Starship prompt — initialised last so it owns the prompt on every machine.
# Guarded so the shell stays usable (plain/oh-my-zsh prompt) if starship is
# missing, e.g. before the setup hook has run or behind a container firewall.
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
