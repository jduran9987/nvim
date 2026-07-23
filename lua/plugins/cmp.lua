return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },

        completion = {
          autocomplete = { cmp.TriggerEvent.TextChanged },
        },

        -- IMPORTANT: do NOT use cmp.mapping.preset.insert(...)
        -- because it installs a <CR> mapping.
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),

          -- Use Ctrl-y to confirm selections (keep Enter for autopairs/newline)
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        },

        sources = cmp.config.sources({
          { name = "nvim_lsp", keyword_length = 0 },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}

