vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "<leader>tf", function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.b[bufnr].format_on_save_enabled =
    not vim.b[bufnr].format_on_save_enabled

  local state = vim.b[bufnr].format_on_save_enabled and "ON" or "OFF"
  vim.notify("Format on save: " .. state, vim.log.levels.INFO)
end, { desc = "Toggle format on save (buffer)" })

vim.keymap.set("n", "]u", function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" and vim.bo[buf].modified then
      vim.api.nvim_set_current_buf(buf)
      return
    end
  end
  vim.notify("No unsaved buffers", vim.log.levels.INFO)
end, { desc = "Jump to an unsaved buffer" })

