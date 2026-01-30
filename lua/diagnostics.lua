vim.diagnostic.config({
    virtual_text = {
        spacing = 2,
        prefix = "●",
    },
    underline = true,
    signs = true,
    update_in_insert = false,
    float = {
        border = "rounded",
        source = "if_many",
    },
})

