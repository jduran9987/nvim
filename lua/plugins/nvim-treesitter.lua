return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime")

      -- Auto-install missing parsers
      vim.g.nvim_treesitter = {
        auto_install = true,
        ensure_installed = {
          "bash", "c", "diff", "html", "javascript", "jsdoc", "json", "jsonc",
          "lua", "luadoc", "markdown", "markdown_inline", "printf", "python",
          "query", "regex", "rust", "toml", "tsx", "typescript", "vim", "vimdoc", "xml", "yaml",
        },
      }

      -- Enable Tree-sitter highlighting for all filetypes
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
