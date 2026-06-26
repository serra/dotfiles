-- macOS-only nvim extras (stow package: mac).
-- LazyVim auto-loads every lua/plugins/*.lua, so this file is layered on top of
-- the devops base just by existing here. Add mac-only plugins/overrides below.
return {
  -- Catppuccin Mocha on the mac (overrides the devops Macchiato default).
  { "catppuccin/nvim", opts = { flavour = "mocha" } },
}
