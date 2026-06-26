-- Devcontainer-only nvim overlay (stow package: devcontainer).
-- LazyVim auto-loads this on top of the devops base. Copilot needs an
-- interactive GitHub device login that doesn't fit the container flow, so
-- disable it here. Add other container trims (heavy Mason installs, etc) below.
return {
  { "zbirenbaum/copilot.lua", enabled = false },
}
