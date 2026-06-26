return {
  {
    "LazyVim/LazyVim",
    keys = {
      {
        "<leader>mx",
        function()
          local line = vim.api.nvim_get_current_line()
          if line:match("%- %[ %]") then
            line = line:gsub("%- %[ %]", "- [x]", 1)
          elseif line:match("%- %[x%]") then
            line = line:gsub("%- %[x%]", "- [ ]", 1)
          end
          vim.api.nvim_set_current_line(line)
        end,
        desc = "Toggle checkbox",
      },
    },
  },
}
