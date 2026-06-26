return {
  "kdheepak/lazygit.nvim",
  -- Self-guard: only load when the lazygit binary is present, so devops is
  -- safe on machines/containers that don't ship it.
  cond = vim.fn.executable("lazygit") == 1,
  cmd = "LazyGit",
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  },
}
