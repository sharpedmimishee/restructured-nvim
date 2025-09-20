vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {"rust",
    "go",
    "gomod",
    "gosum",
    "rust",
    "v",
    "zig",
    "c",
    "cpp",
    "vimdoc",
    "vim",
    "lua",
    "markdown"},
  callback = function()
    -- syntax highlighting, provided by Neovim
    vim.treesitter.start()
    -- folds, provided by Neovim
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    -- indentation, provided by nvim-treesitter
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})


vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(opts)
    if opts.data.spec.name == 'cord.nvim' and opts.data.kind == 'update' then 
      vim.cmd 'Cord update'
    end
  end
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "launch lua-language-server",
    pattern = "lua",
    callback = function()
        vim.lsp.start({
            name = "lua_ls",
            cmd = { "lua-language-server" },
        })
    end
})
vim.api.nvim_create_autocmd("FileType", {
    desc = "launch rust-analyzer",
    pattern = "rust",
    callback = function()
        vim.lsp.start({
            name = "rust-analyzer",
            cmd = { "rust-analyzer" },
        })
    end
})
vim.api.nvim_create_autocmd("FileType", {
    desc = "launch gopls",
    pattern = "go",
    callback = function()
        vim.lsp.start({
            name = "gopls",
            cmd = { "gopls" },
        })
    end
})
vim.api.nvim_create_autocmd("FileType", {
    desc = "launch v-language server",
    pattern = "v",
    callback = function()
        vim.lsp.start({
            name = "vls",
            cmd = { "vls" },
        })
    end
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method("textDocument/completion") then
            local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
            client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
            vim.lsp.document_color.enable(true, 0, { style = 'background' })
        end
    end,
})
