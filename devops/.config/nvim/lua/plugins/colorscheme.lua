-- Catppuccin colourscheme, per-environment flavour (stow package: devops).
-- Base default = Macchiato (the production look). The mac/devcontainer overlays
-- (lua/plugins/mac.lua, container.lua) override `flavour`; LazyVim loads those
-- files after this one, so their flavour wins on those machines. Prod (linux,
-- no overlay) keeps Macchiato.
return {
  { "catppuccin/nvim", name = "catppuccin", opts = { flavour = "macchiato" } },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },
}
