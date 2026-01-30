-- 2-space indentation for selected filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "yaml", "yml", "json", "lua", "toml" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

