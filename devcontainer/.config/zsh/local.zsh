# Devcontainer zsh overlay (stow package: devcontainer), sourced by devops/.zshrc
# before the starship init — the same hook the mac overlay uses.

# django_vines container env: /entrypoint builds DATABASE_URL from the POSTGRES_*
# vars (and waits for Postgres), mirroring the bash path in the project's
# .devcontainer/bashrc.override.sh. It sets errexit/pipefail/nounset and ends with
# `exec "$@"` (a no-op with no args), so reset the options after to keep the
# interactive shell usable. Guarded on /entrypoint so this stays inert on any box
# without it (mac, linux).
if [ -f /entrypoint ]; then
  source /entrypoint
  set +o errexit
  set +o pipefail
  set +o nounset
fi

# Persistent zsh history (the project's bash path uses the mounted ~/.bash_history).
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
