vim.loader.enable()

vim.pack.add({
    "https://github.com/monaqa/dial.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/stevearc/oil.nvim",
    {src="https://github.com/nvim-treesitter/nvim-treesitter", version="main"},
    "https://github.com/nvim-treesitter/nvim-treesitter-context",
    "https://github.com/oribarilan/lensline.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/hoob3rt/lualine.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/uga-rosa/ccc.nvim",
    "https://github.com/j-hui/fidget.nvim",
    "https://github.com/akinsho/bufferline.nvim",
    "https://github.com/echasnovski/mini.splitjoin",
    "https://github.com/echasnovski/mini.surround",
    "https://github.com/echasnovski/mini.cursorword",
    "https://github.com/vyfor/cord.nvim",
    "https://github.com/echasnovski/mini.pairs",
    "https://github.com/gelguy/wilder.nvim",
    "https://github.com/dstein64/vim-startuptime"
})
--configs
require("configs.lualine")
require("configs.keymaps")
require("configs.settings")
require("configs.treesitter")
require("configs.autocmd")
require("configs.dial")
require("gitsigns").setup()
--setups
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("configs.oil")
    end
})
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
        require("fidget").setup()
    end
})
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function ()
        require("bufferline").setup()
        require("mini.splitjoin").setup()
        require("mini.surround").setup()
        require("mini.cursorword").setup()
        require("lensline").setup()
    end
})
vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        require("mini.pairs").setup()
    end
})
vim.api.nvim_create_autocmd("CmdLineEnter", {
    callback = function()
        require("configs.ccc")
        require("configs.wilder")
    end
})

vim.pack.add({
    vim.fn.expand("file:///$HOME/documents/devs/luanium.nvim"),
    vim.fn.expand("file:///$HOME/documents/devs/floatization.nvim"),
})

require("floatization").setup({ key = true })
vim.cmd("colorscheme luanium")
