# nvim

My Neovim config, built on [lazy.nvim](https://github.com/folke/lazy.nvim). Plugins install themselves on first launch, but several features depend on tools that live outside Neovim. They're listed below.

## Install

```bash
git clone git@github.com:jduran9987/nvim.git ~/.config/nvim
nvim
```

lazy.nvim bootstraps itself and installs every plugin. Mason then installs the language servers listed under [Mason](#installed-by-mason-automatic).

## External dependencies

### Core

| Tool | Needed for | Install (macOS) |
|---|---|---|
| Neovim 0.11+ (tested on 0.12) | `vim.lsp.config` / `vim.lsp.enable` API | `brew install neovim` |
| git | lazy.nvim bootstrap, plugin installs, gitsigns | `brew install git` |
| A [Nerd Font](https://www.nerdfonts.com/) set as your terminal font | Icons in lualine, oil, telescope | `brew install --cask font-meslo-lg-nerd-font` |

### Tree-sitter

The config uses the `main` branch of nvim-treesitter, which compiles parsers locally.

| Tool | Needed for | Install |
|---|---|---|
| tree-sitter CLI 0.25+ | Building parsers | `brew install tree-sitter` or `cargo install tree-sitter-cli` |
| C compiler (`cc`) | Building parsers | `xcode-select --install` |
| curl, tar | Downloading parser sources | Ship with macOS |

### Telescope

| Tool | Needed for | Install |
|---|---|---|
| ripgrep (`rg`) | `<leader>fg` live grep, `<leader>ff` find files | `brew install ripgrep` |
| make | Building telescope-fzf-native (skipped if missing) | `xcode-select --install` |
| fd (optional) | Faster `<leader>ff` | `brew install fd` |

### Installed by Mason (automatic)

Mason installs these into `~/.local/share/nvim/mason/bin` and puts that folder on Neovim's PATH. Most of them are npm packages, so Mason needs **Node.js/npm**. The rest are downloaded binaries, which need **curl** and **unzip**.

| Tool | Used for | How it gets installed |
|---|---|---|
| lua-language-server | Lua LSP | `ensure_installed`, automatic |
| pyright | Python LSP | `ensure_installed`, automatic (npm) |
| ruff | Python diagnostics and `ruff_format` formatting | `ensure_installed`, automatic |
| bash-language-server | Bash LSP | `ensure_installed`, automatic (npm) |
| terraform-ls | Terraform LSP | `ensure_installed`, automatic |
| prettier | JSON / JSONC formatting | **Manual:** `:MasonInstall prettier` |

### Installed outside Mason

| Tool | Used for | Install |
|---|---|---|
| Go toolchain | gopls, goimports, gofumpt | [go.dev/dl](https://go.dev/dl/) |
| gopls | Go LSP | `go install golang.org/x/tools/gopls@latest` |
| goimports | Go formatting | `go install golang.org/x/tools/cmd/goimports@latest` |
| gofumpt | Go formatting | `go install mvdan.cc/gofumpt@latest` |
| rustup (stable toolchain) | Rust | [rustup.rs](https://rustup.rs/) |
| rust-analyzer | Rust LSP, via rustaceanvim | `rustup component add rust-analyzer` |
| clippy | Rust check-on-save | `rustup component add clippy` |
| rustfmt | Rust formatting | `rustup component add rustfmt` |
| clangd | C / C++ LSP | `xcode-select --install` (or `brew install llvm`) |
| jq | JSONL formatting (`jq -c .`) | Ships with macOS 15+, or `brew install jq` |

`init.lua` adds `~/go/bin` and `~/.cargo/bin` to Neovim's PATH, so the Go and Rust tools are found even if your shell doesn't include those folders.

The rust-analyzer path in `lua/plugins/rust.lua` is hardcoded to `~/.rustup/toolchains/stable-aarch64-apple-darwin/`, so it assumes an Apple Silicon Mac on the stable toolchain. Edit that path on any other platform.

## Checking your setup

- `:checkhealth` covers lazy.nvim, Mason, nvim-treesitter, and telescope.
- `:Mason` shows what Mason has installed.
- `:ConformInfo` shows which formatter each filetype uses and whether it's available.

## Formatting

conform.nvim handles formatting, and format-on-save is **off by default**. Turn it on for the current buffer with `<leader>tf`.

| Filetype | Formatter |
|---|---|
| Python | ruff_format |
| Go | goimports, gofumpt |
| Rust | rustfmt |
| JSON / JSONC | prettier |
| JSONL | jq -c (keeps one record per line) |
