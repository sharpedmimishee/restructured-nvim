-- Disable unnecessary built-in plugins
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
}

for _, plugin in ipairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- Disable RPC
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local options = {
  updatetime = 250,
  timeoutlen = 300,

  clipboard = "unnamedplus",

  swapfile = false,
  backup = false,
  undofile = true,

  shada = "!,'100,<50,s10,h",

  number = true,
  termguicolors = true,
  signcolumn = "yes",

  autocomplete = true,
  completeopt = {
    "menu",
    "menuone",
    "noselect",
    "fuzzy",
    "popup",
  },
  complete = ".,w,b,u,t,o,k",
  pumborder = "rounded",
  autocompletedelay = 200,

  expandtab = true,
  tabstop = 4,
  shiftwidth = 4,
  smarttab = true,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

require("vim._core.ui2").enable({
  enable = true,
})

-- Clipboard

if vim.env.WAYLAND_DISPLAY then
  -- Wayland
  vim.g.clipboard = {
    name = "wl-clipboard",

    copy = {
      ["+"] = "wl-copy --type text/plain",
      ["*"] = "wl-copy --primary --type text/plain",
    },

    paste = {
      ["+"] = "wl-paste --no-newline",
      ["*"] = "wl-paste --primary --no-newline",
    },

    cache_enabled = 1,
  }
else
  -- X11
  vim.g.clipboard = {
    name = "xclip",

    copy = {
      ["+"] = "xclip -selection clipboard",
      ["*"] = "xclip -selection primary",
    },

    paste = {
      ["+"] = "xclip -selection clipboard -o",
      ["*"] = "xclip -selection primary -o",
    },

    cache_enabled = 1,
  }
end

-- vim.pack
vim.pack.add({
  { src = "https://github.com/rebelot/kanagawa.nvim" },
  { src = "https://github.com/FylerOrg/fyler.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/j-hui/fidget.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/stevearc/dressing.nvim" },
  { src = "https://github.com/alexpasmantier/tv.nvim" },
})

-- fidget
vim.cmd("packadd! fidget.nvim")

require("fidget").setup()

-- kanagawa
vim.cmd("packadd! kanagawa.nvim")

local ok_kanagawa, kanagawa = pcall(require, "kanagawa")

if ok_kanagawa then
  kanagawa.setup({
    compile = true,
    theme = "wave",
  })

  vim.cmd([[colorscheme kanagawa]])
end

-- terminal
vim.keymap.set(
  "t",
  "<Esc>",
  [[<C-\><C-n>]],
  {
    desc = "Exit Terminal Insert Mode",
    silent = true,
  }
)

-- compleation
vim.api.nvim_create_autocmd("InsertEnter", {
  group = vim.api.nvim_create_augroup(
    "NativeCompletionKeys",
    { clear = true }
  ),

  callback = function()
    vim.keymap.set(
      "i",
      "<Tab>",
      function()
        return vim.fn.pumvisible() == 1
          and "<C-n>"
          or "<Tab>"
      end,
      {
        expr = true,
        buffer = true,
      }
    )

    vim.keymap.set(
      "i",
      "<S-Tab>",
      function()
        return vim.fn.pumvisible() == 1
          and "<C-p>"
          or "<S-Tab>"
      end,
      {
        expr = true,
        buffer = true,
      }
    )

    vim.keymap.set(
      "i",
      "<CR>",
      function()
        return vim.fn.pumvisible() == 1
          and vim.fn.complete_info().selected ~= -1
          and "<C-y>"
          or "<CR>"
      end,
      {
        expr = true,
        buffer = true,
      }
    )
  end,
})


-- fyler
vim.cmd("packadd! fyler.nvim")

local ok_fyler, fyler = pcall(require, "fyler")

if ok_fyler then
  fyler.setup({
    ui = {
      hidden_items = {
        switches = {},
        patterns = {},
        always_visible = {},
        always_hidden = {},
      },

      indent_guides = true,
    },
  })
end

vim.keymap.set("n", "<leader>c", function()
  if ok_fyler then
    fyler.open()
  end
end, {
  desc = "Open Fyler",
  silent = true,
})

local fyler_group = vim.api.nvim_create_augroup(
  "FylerFixes",
  { clear = true }
)

vim.api.nvim_create_autocmd("VimEnter", {
  group = fyler_group,

  callback = function()
    if vim.fn.isdirectory(vim.fn.argv(0)) == 1 and ok_fyler then
      fyler.open()
    end
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = fyler_group,

  callback = function(args)
    local bufnr = args.buf
    local buf_name = vim.api.nvim_buf_get_name(bufnr)

    if
      buf_name ~= ""
      and vim.bo[bufnr].filetype == ""
      and vim.bo[bufnr].buftype == ""
    then
      vim.cmd("filetype detect")
    end
  end,
})


-- gitsigns
vim.api.nvim_create_autocmd(
  { "BufReadPost", "BufNewFile" },
  {
    once = true,

    callback = function()
      vim.cmd("packadd! gitsigns.nvim")

      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          vim.keymap.set(
            "n",
            "<leader>hs",
            gs.stage_hunk,
            {
              buffer = bufnr,
              desc = "Stage Hunk",
            }
          )

          vim.keymap.set(
            "n",
            "<leader>hr",
            gs.reset_hunk,
            {
              buffer = bufnr,
              desc = "Reset Hunk",
            }
          )

          vim.keymap.set(
            "n",
            "[c",
            gs.prev_hunk,
            {
              buffer = bufnr,
              desc = "Prev Hunk",
            }
          )

          vim.keymap.set(
            "n",
            "]c",
            gs.next_hunk,
            {
              buffer = bufnr,
              desc = "Next Hunk",
            }
          )
        end,
      })
    end,
  }
)


-- tv
local function select_with_tv()
  if not pcall(require, "tv") then
    vim.cmd("packadd tv.nvim")
  end

  require("tv").setup({
    args = {
      "--hidden",
      "--exclude",
      ".git",
      "--exclude",
      "node_modules",
      "--exclude",
      ".target",
    },

    window = {
      width = 0.8,
      height = 0.6,
      border = "rounded",
    },
  })

  vim.cmd("Tv text")
end


vim.keymap.set(
  "n",
  "<leader>xx",
  select_with_tv,
  {
    desc = "Find files with tv.nvim",
    silent = true,
  }
)

-- treesitter
vim.api.nvim_create_autocmd(
  { "BufReadPost", "BufNewFile" },
  {
    group = vim.api.nvim_create_augroup(
      "LazyLoadDevPlugins",
      { clear = true }
    ),

    once = true,

    callback = function()
      vim.cmd("packadd! nvim-treesitter")
      vim.cmd("packadd! nvim-treesitter-context")
      vim.cmd("packadd! nvim-lspconfig")

      local ok_ts, ts_configs = pcall(
        require,
        "nvim-treesitter.configs"
      )

      -- treesitter
      if ok_ts then
        ts_configs.setup({
          ensure_installed = {
            "lua",
            "vim",
            "vimdoc",
            "markdown",
            "c",
            "cpp",
            "rust"
          },

          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },

          indent = {
            enable = true,
          },
        })
      end

      -- treesitter-context
      require("treesitter-context").setup({
        enable = true,
        max_lines = 3,
      })

      -- LSP

      -- lua_ls
      vim.lsp.config("lua_ls", {
        root_markers = {
          ".luarc.json",
          ".luarc.jsonc",
          ".git",
        },

        settings = {
          Lua = {
            diagnostics = {
              globals = {
                "vim",
              },
            },

            workspace = {
              checkThirdParty = false,
            },
          },
        },
      })

      -- rust-analyzer
      vim.lsp.config("rust_analyzer", {
        root_markers = {
          "Cargo.toml",
          "rust-project.json",
          ".git",
        },
      })

      -- clangd
      vim.lsp.config("clangd", {
        root_markers = {
          ".clangd",
          "compile_commands.json",
          "compile_flags.txt",
          ".git",
        },
      })

      -- LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup(
          "UserLspConfig",
          { clear = true }
        ),

        callback = function(args)
          local bufnr = args.buf

          local client = assert(
            vim.lsp.get_client_by_id(args.data.client_id)
          )

          local opts = {
            buffer = bufnr,
            remap = false,
          }


          -- Navigation
          vim.keymap.set(
            "n",
            "gd",
            vim.lsp.buf.definition,
            opts
          )

          vim.keymap.set(
            "n",
            "K",
            vim.lsp.buf.hover,
            opts
          )

          vim.keymap.set(
            "n",
            "<leader>vd",
            vim.diagnostic.open_float,
            opts
          )


          -- LSP completion
          vim.lsp.completion.enable(
            true,
            client.id,
            bufnr,
            {
              autotrigger = true,
            }
          )


          -- Completion popup
          local completion_opts = {
            buffer = bufnr,
            expr = true,
            silent = true,
          }

          vim.keymap.set(
            "i",
            "<Tab>",
            function()
              return vim.fn.pumvisible() == 1
                and "<C-n>"
                or "<Tab>"
            end,
            completion_opts
          )

          vim.keymap.set(
            "i",
            "<S-Tab>",
            function()
              return vim.fn.pumvisible() == 1
                and "<C-p>"
                or "<S-Tab>"
            end,
            completion_opts
          )

          vim.keymap.set(
            "i",
            "<CR>",
            function()
              if
                vim.fn.pumvisible() == 1
                and vim.fn.complete_info().selected ~= -1
              then
                return "<C-y>"
              end

              return "<CR>"
            end,
            completion_opts
          )


          -- Native omnifunc
          vim.bo[bufnr].omnifunc =
            "v:lua.vim.lsp.omnifunc"

          vim.keymap.set(
            "i",
            "<C-Space>",
            "<C-x><C-o>",
            {
              buffer = bufnr,
              silent = true,
            }
          )
        end,
      })


      -- Dressing
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup(
          "LspDressing",
          { clear = true }
        ),

        once = true,

        callback = function()
          vim.cmd("packadd! dressing.nvim")
          require("dressing").setup({})
        end,
      })


      -- Enable all configured LSP servers
      vim.lsp.enable({
        "lua_ls",
        "rust_analyzer",
        "clangd",
      })
    end,
  }
)

-- Leader Key Popup
-- Neovim native API only
local leader_popup = {
  win = nil,
  buf = nil,
  prefix = "",
  active = false,
}

local leader_key = vim.g.mapleader or " "


local function close_leader_popup()
  if leader_popup.win
    and vim.api.nvim_win_is_valid(leader_popup.win)
  then
    vim.api.nvim_win_close(leader_popup.win, true)
  end

  leader_popup.win = nil
  leader_popup.buf = nil
  leader_popup.prefix = ""
  leader_popup.active = false
end

-- Get normal-mode mappings
local function get_normal_keymaps()
  local maps = {}

  for _, map in ipairs(vim.api.nvim_get_keymap("n")) do
    table.insert(maps, map)
  end

  for _, map in ipairs(vim.api.nvim_buf_get_keymap(0, "n")) do
    table.insert(maps, map)
  end

  return maps
end


-- Normalize <Leader>
local function normalize_lhs(lhs)
  return lhs:gsub(
    "<[Ll][Ee][Aa][Dd][Ee][Rr]>",
    leader_key
  )
end


-- Get mappings after current prefix
local function get_prefix_maps(prefix)
  local result = {}

  for _, map in ipairs(get_normal_keymaps()) do
    local lhs = normalize_lhs(map.lhs)

    if lhs:sub(1, #leader_key) == leader_key then
      if lhs:sub(1, #prefix) == prefix then
        local rest = lhs:sub(#prefix + 1)

        if rest ~= "" then
          local next_key

          if rest:sub(1, 1) == "<" then
            local ending = rest:find(">", 2, true)

            if ending then
              next_key = rest:sub(1, ending)
            else
              next_key = rest:sub(1, 1)
            end
          else
            next_key = rest:sub(1, 1)
          end

          if not result[next_key] then
            result[next_key] = {
              key = next_key,
              desc = map.desc or "",
              lhs = lhs,
            }
          elseif result[next_key].desc == ""
            and map.desc
          then
            result[next_key].desc = map.desc
          end
        end
      end
    end
  end

  local list = {}

  for _, item in pairs(result) do
    table.insert(list, item)
  end

  table.sort(list, function(a, b)
    return a.key < b.key
  end)

  return list
end


-- Create / update popup
local function create_leader_popup(prefix)
  local items = get_prefix_maps(prefix)

  if #items == 0 then
    close_leader_popup()
    return
  end

  local lines = {}

  local display_prefix =
    prefix:sub(#leader_key + 1)

  if display_prefix == "" then
    table.insert(lines, " Leader")
  else
    table.insert(
      lines,
      " Leader > " .. display_prefix
    )
  end

  table.insert(lines, "")

  local max_key_width = 0

  for _, item in ipairs(items) do
    max_key_width = math.max(
      max_key_width,
      vim.fn.strdisplaywidth(item.key)
    )
  end

  for _, item in ipairs(items) do
    local key = item.key

    local padding = string.rep(
      " ",
      max_key_width
        - vim.fn.strdisplaywidth(key)
    )

    local desc = item.desc

    if desc == "" then
      desc = item.lhs
    end

    table.insert(
      lines,
      "  "
        .. key
        .. padding
        .. "   "
        .. desc
    )
  end

  local width = 0

  for _, line in ipairs(lines) do
    width = math.max(
      width,
      vim.fn.strdisplaywidth(line)
    )
  end

  width = math.min(width + 2, 70)

  local height = #lines


  -- Buffer
  if not leader_popup.buf
    or not vim.api.nvim_buf_is_valid(
      leader_popup.buf
    )
  then
    leader_popup.buf =
      vim.api.nvim_create_buf(false, true)

    vim.bo[leader_popup.buf].buftype = "nofile"
    vim.bo[leader_popup.buf].bufhidden = "wipe"
    vim.bo[leader_popup.buf].swapfile = false
  end

  vim.bo[leader_popup.buf].modifiable = true

  vim.api.nvim_buf_set_lines(
    leader_popup.buf,
    0,
    -1,
    false,
    lines
  )

  vim.bo[leader_popup.buf].modifiable = false


  -- Existing window
  if leader_popup.win
    and vim.api.nvim_win_is_valid(
      leader_popup.win
    )
  then
    vim.api.nvim_win_set_config(
      leader_popup.win,
      {
        relative = "cursor",
        row = 1,
        col = 0,
        width = width,
        height = height,
      }
    )

    return
  end


  -- New floating window
  leader_popup.win =
    vim.api.nvim_open_win(
      leader_popup.buf,
      false,
      {
        relative = "cursor",

        row = 1,
        col = 0,

        width = width,
        height = height,

        style = "minimal",
        border = "rounded",

        title = " Leader ",
        title_pos = "left",

        zindex = 100,
      }
    )

  vim.wo[leader_popup.win].winblend = 0
  vim.wo[leader_popup.win].cursorline = false

  leader_popup.active = true
end


-- Key input
vim.on_key(function(key, typed)
  -- Normal mode only
  if vim.fn.mode() ~= "n" then
    if leader_popup.active then
      close_leader_popup()
    end

    return
  end

  if not typed then
    return
  end


  -- Leader
  if not leader_popup.active then
    if key == leader_key then
      vim.schedule(function()
        if vim.fn.mode() == "n" then
          leader_popup.prefix = leader_key

          create_leader_popup(
            leader_popup.prefix
          )
        end
      end)
    end

    return
  end


  -- Escape
  local key_name = vim.fn.keytrans(key)

  if key_name == "<Esc>" then
    vim.schedule(close_leader_popup)
    return
  end


  -- Backspace
  if key_name == "<BS>" then
    vim.schedule(function()
      local prefix = leader_popup.prefix

      if prefix == leader_key then
        close_leader_popup()
        return
      end

      prefix = prefix:sub(1, -2)

      leader_popup.prefix = prefix

      create_leader_popup(prefix)
    end)

    return
  end

  -- Next key
  vim.schedule(function()
    local next_prefix =
      leader_popup.prefix .. key

    local items =
      get_prefix_maps(next_prefix)

    if #items > 0 then
      leader_popup.prefix = next_prefix

      create_leader_popup(
        next_prefix
      )
    else
      close_leader_popup()
    end
  end)
end)
