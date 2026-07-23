return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    init = function()
      local rust_analyzer_bin = vim.fn.expand("~/.rustup/toolchains/stable-aarch64-apple-darwin/bin/rust-analyzer")
      vim.g.rustaceanvim = {
        server = {
          cmd = { rust_analyzer_bin },
          capabilities = vim.lsp.protocol.make_client_capabilities(),
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              check = { command = "clippy" },
            },
          },
        },
      }
    end,
  },
}
