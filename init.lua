vim.env.PATH = vim.env.HOME .. "/.cargo/bin:" .. vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

require("keymaps")
require("options")
require("indent")
require("diagnostics")
require("config.lazy")
