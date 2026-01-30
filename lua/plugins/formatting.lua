return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "ruff_format" },
        },
        format_on_save = function(bufnr)
          if vim.b[bufnr].format_on_save_enabled ~= true then
            return false
          end

          return {
            timeout_ms = 2000,
            lsp_fallback = false,
          }
        end,
      })
    end,
  },
}

