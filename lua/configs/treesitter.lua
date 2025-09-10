require("nvim-treesitter").setup({
    install_dir = vim.fn.stdpath('data') .. '/site'
})


-- why I always stuck on compling :(
-- require("nvim-treesitter").install({
--     "rust",
--     "go",
--     "v",
--     "zig",
--     "c",
--     "cpp",
--     "typescript",
--     "vimdoc",
--     "vim",
--     "markdown"
-- })
