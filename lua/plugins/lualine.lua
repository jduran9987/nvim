return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local function venv()
      local venv_path = os.getenv("VIRTUAL_ENV")
      if not venv_path or venv_path == "" then
        return ""
      end
      return "🐍 " .. vim.fn.fnamemodify(venv_path, ":t")
    end
    
    local function unsaved_buffers()
      local count = 0
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf)
          and vim.bo[buf].buftype == ""
          and vim.bo[buf].modified
        then
          count = count + 1
        end
      end

      if count == 0 then
        return ""
      end

      return "● " .. count .. " unsaved"
    end

    require("lualine").setup({
      options = {
        theme = "auto",
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = {
          venv,
          "filename",
        },
        lualine_x = { unsaved_buffers, "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}

