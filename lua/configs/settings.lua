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
opt.cmdheight = 0
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
-- opt.shell = "brush"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.completeopt = {
  "fuzzy",
  "popup",
  "menuone",
  -- "noinsert",
  "noselect"
}
require('vim._extui').enable({
     enable = true, -- Whether to enable or disable the UI.
     msg = { -- Options related to the message module.
       ---@type 'cmd'|'msg' Where to place regular messages, either in the
       ---cmdline or in a separate ephemeral message window.
       target = 'cmd',
       timeout = 4000, -- Time a message is visible in the message window.
     },
    })
