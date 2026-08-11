return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },

    dependencies = {
      { "williamboman/mason.nvim", config = true },
      { "williamboman/mason-lspconfig.nvim" },
    },

    config = function()
      -- Neovim's built-in *.tf detection is content-based (disambiguating from the
      -- TinyFugue mud client) and defaults new/empty buffers to filetype "tf" instead
      -- of "terraform", so treesitter/LSP don't attach until the file is saved and
      -- reopened. Force it so Terraform files are recognized immediately.
      vim.filetype.add({ extension = { tf = "terraform" } })

      -- Mason
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "ruff", "bashls", "terraformls" },
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

      -- Terraform
      vim.lsp.config("terraformls", {
        capabilities = capabilities,
        -- Override lspconfig's default on_attach: it calls vim.lsp.codelens.enable,
        -- which doesn't exist on Neovim 0.11.5 and throws an ON_ATTACH_ERROR.
        on_attach = function(_, bufnr)
          if vim.lsp.codelens and vim.lsp.codelens.enable then
            vim.lsp.codelens.enable(true, { bufnr = bufnr })
          end
        end,
      })

      -- Enable the servers
      vim.lsp.enable({ "lua_ls", "pyright", "ruff", "bashls", "clangd", "terraformls" })

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

