-- Lazy spec

return {
  -- mini.* configured in bren.{surround,textobjects,comment,move}
  "echasnovski/mini.nvim",

  -- Paragraph motion enhancements
  "justinmk/vim-ipmotion",

  -- Setup in bren.flash
  "folke/flash.nvim",

  -- Pinned to v0.10.0: `main` dropped `configs.setup` API
  {
    "nvim-treesitter/nvim-treesitter",
    tag = "v0.10.0",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'lua', 'vim', 'vimdoc', 'bash', 'python', 'markdown',
          'markdown_inline', 'json', 'yaml', 'toml', 'kdl',
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Non-VSCode UI
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cond = not vim.g.vscode,
    config = function()
      require("lualine").setup({
        options = {
          theme = { normal = { z = { fg = "#54546D", bg = nil } } },
          section_separators = {},
          globalstatus = true,
        },
        sections = {
          lualine_a = {}, lualine_b = {}, lualine_c = {}, lualine_x = {}, lualine_y = {},
          lualine_z = {{
            "location",
            padding = 0.5,
            fmt = function(s) return s:gsub(":", ", ") end,
          }},
        },
      })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    cond = not vim.g.vscode,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        transparent = true,
        dimInactive = true,
        colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
      })
      vim.cmd("colorscheme kanagawa")
    end,
  },

  -- VSCode-only
  {
    "vscode-neovim/vscode-multi-cursor.nvim",
    event = "VeryLazy",
    cond = vim.g.vscode ~= nil,
    config = function()
      require("vscode-multi-cursor").setup({ default_mappings = false })
      local c = require("vscode-multi-cursor")
      local set = vim.keymap.set
      set({ "n", "x" }, "<Leader>m", c.create_cursor, { expr = true })
      set({ "n" },      "dm",        c.cancel)
      set({ "n", "x" }, "<Leader>H", c.start_right)
    end,
  },
}
