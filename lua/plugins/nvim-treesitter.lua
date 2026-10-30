return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime")

      -- Install parsers (main branch API; no-op for ones already installed)
      require("nvim-treesitter").install({
        "bash", "c", "diff", "go", "gomod", "gosum", "gowork", "gotmpl",
        "hcl", "html", "javascript", "jsdoc", "json",
        "lua", "luadoc", "markdown", "markdown_inline", "printf", "python",
        "query", "regex", "rust", "terraform", "toml", "tsx",
        "typescript", "vim", "vimdoc", "xml", "yaml",
      })

      -- JSONL has no parser of its own; the json parser handles one value per line
      vim.treesitter.language.register("json", "jsonl")

      -- Enable Tree-sitter highlighting for all filetypes
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
