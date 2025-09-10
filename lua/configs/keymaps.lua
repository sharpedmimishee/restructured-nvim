local wk = require("which-key")
wk.add({
  -- { "<leader>f", group = "file" }, -- group
    {"<leader>pu", desc = "Update all plugins", function() vim.pack.update() print('Updating all plugins') end},
    {"<leader>c", desc = "Open Oil.nvim", function() vim.cmd("Oil") end },
    {"<leader>xx", desc = "Go to implementation", function() vim.lsp.buf.implementation() end },
    {"<leader>xd", desc = "Go to definition", function() vim.lsp.buf.definition() end },
    {"<leader>xX", desc = "Format current buffer", function() vim.lsp.buf.format() end },
    {"<leader>xc", desc = "Open floating window", function() vim.lsp.buf.hover() end },
    {"<leader>xz", desc = "Open signature help", function() vim.lsp.buf.signature_help() end },
})
