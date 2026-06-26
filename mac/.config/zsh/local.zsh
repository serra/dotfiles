# macOS zsh overlay (stow package: mac), sourced by the devops base ~/.zshrc.
# Holds the mac-specific shell: oh-my-zsh + plugins, language managers, aliases,
# PATH tweaks. The prompt itself is drawn by Starship (see devops/.zshrc), so the
# oh-my-zsh theme is intentionally left empty here.

# Path to your oh-my-zsh installation.
export ZSH="/Users/marijn/.oh-my-zsh"

# Prompt is owned by Starship (initialised in ~/.zshrc, after this file). Leave
# the oh-my-zsh theme empty so it doesn't draw a competing prompt; oh-my-zsh
# still provides completions and the plugins below.
ZSH_THEME=""

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(git dotenv kubectl)

source $ZSH/oh-my-zsh.sh

# User configuration

eval "$(rbenv init - zsh)"

eval "$(pyenv init -)"

eval "$(zoxide init zsh)"

# Created by `pipx` on 2023-12-08 14:57:44
export PATH="$PATH:/Users/marijn/.local/bin"
# Space-free pipx home (default ~/Library/Application Support/pipx has a space).
export PIPX_HOME="$HOME/.local/pipx"

alias bv='bump-my-version'
alias bvpt='bump-my-version bump patch --tag'

fpath+=~/.zfunc; autoload -Uz compinit; compinit

export PATH="/opt/homebrew/Cellar/mariadb@10.6/10.6.21/bin:$PATH"

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
