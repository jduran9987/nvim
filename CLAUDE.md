# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This is a modular Neovim configuration using lazy.nvim for plugin management.

**Entry point:** `init.lua` loads modules in order: keymaps → options → indent → diagnostics → lazy

**Structure:**
- `lua/config/lazy.lua` - Plugin manager bootstrap and setup
- `lua/plugins/*.lua` - One file per plugin (auto-imported by lazy.nvim)
- `lua/options.lua` - Editor settings (line numbers, tabs, clipboard)
- `lua/keymaps.lua` - Global keybindings
- `lua/indent.lua` - Filetype-specific indent rules (2-space for yaml/json/lua/toml)
- `lua/diagnostics.lua` - LSP diagnostic display settings

**Plugin pattern:** Each file in `lua/plugins/` returns a lazy.nvim spec table. Plugins use event/cmd/keys triggers for lazy loading.

## Key Keybindings

- Leader: `<space>`, LocalLeader: `\`
- `<leader>tf` - Toggle format-on-save (buffer-local)
- `<leader>ff/fg/fb/fh` - Telescope find files/grep/buffers/help
- `-` - Oil file explorer, `<leader>e` - Oil in vsplit
- `gd` / `K` / `<leader>rn` / `<leader>ca` - LSP go-to-def/hover/rename/code-action

## LSP Setup

Configured in `lua/plugins/lsp.lua` using mason.nvim for server management.

**Enabled servers:** lua_ls, pyright, ruff, bashls, clangd, rust_analyzer

**Pattern:** Uses `vim.lsp.config()` for server settings and `vim.lsp.enable()` to activate. Ruff provides diagnostics/code-actions only (hover/formatting disabled).

## Formatting

Handled by conform.nvim (`lua/plugins/formatting.lua`). Python uses ruff_format. Format-on-save can be toggled per-buffer with `<leader>tf`.

## Adding a New Plugin

Create `lua/plugins/<plugin-name>.lua` returning a lazy.nvim spec:
```lua
return {
  "author/plugin-name",
  event = { "BufReadPre", "BufNewFile" },  -- or cmd/keys/ft for lazy loading
  opts = {},
  config = function(_, opts)
    require("plugin-name").setup(opts)
  end,
}
```

## Adding a New LSP Server

In `lua/plugins/lsp.lua`:
1. Add to `ensure_installed` in mason-lspconfig setup
2. Add `vim.lsp.config("server_name", { capabilities = capabilities, settings = {...} })`
3. Add server name to `vim.lsp.enable()` call
