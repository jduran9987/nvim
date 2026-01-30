return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },

    dependencies = {
      { "williamboman/mason.nvim", config = true },
      { "williamboman/mason-lspconfig.nvim" },
    },

    config = function()
      -- Mason
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "ruff", "bashls", "rust_analyzer", },
        automatic_enable = false,
      })

      -- Capabilities (future-proof for nvim-cmp)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.general = capabilities.general or {}
      capabilities.general.positionEncodings = { "utf-16" }

      -- Lua language server 
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
          },
        },
      })

      -- Pyright
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            },
          },
        },
      })

      -- Ruff
      vim.lsp.config("ruff", {
        capabilities = capabilities,
      })

      -- Bash
      vim.lsp.config("bashls", {
        capabilities = capabilities,
      })

      -- C / C++
      vim.lsp.config("clangd", {
        capabilities = capabilities,
      })

      -- Rust (rust-analyzer)
      vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            check = {
              command = "clippy",
            },
          },
        },
      })

      -- Enable the servers
      vim.lsp.enable({ "lua_ls", "pyright", "ruff", "bashls", "clangd", "rust_analyzer" })

      -- Keymaps (buffer-local, only when LSP attaches)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          -- Identify which LSP just attached
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          -- Ruff: diagnostics + code actions only
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end

          -- Buffer-local keymaps (shared by all LSPs)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })
    end,
  }
}

