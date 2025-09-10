local opt = vim.opt

opt.number = true
opt.relativenumber = false
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.smartcase = true
opt.ignorecase = false
opt.wrap = true
opt.linebreak = false
opt.cursorline = true
opt.cursorcolumn = false
-- opt.background
opt.showmode = true
opt.showcmd = true
opt.hlsearch = true
opt.incsearch = true
-- opt.backup = true
-- opt.writebackup = true
-- opt.swapfile
-- opt.undofile
opt.autoread = true
-- opt.mouse
opt.spell = true
opt.spelllang = {"en_us", "cjk"}
opt.laststatus = 0
opt.clipboard:append({ "unnamedplus" })
opt.termguicolors = true
opt.shell = "brush"
vim.notify = require("notify")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.completeopt = {
  "fuzzy",
  "popup",
  "menuone",
  "noinsert",
}
