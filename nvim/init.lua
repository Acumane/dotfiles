local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({
  -- "andymass/vim-matchup",
  "kylechui/nvim-surround",
  "johmsalas/text-case.nvim",
  "justinmk/vim-ipmotion",
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cond = (function() return not vim.g.vscode end)
  },
  {
    "rebelot/kanagawa.nvim",
    cond = (function() return not vim.g.vscode end)
  }
})

require("textcase").setup({
  default_keymappings_enabled = true,
  prefix = "t",
})

require("nvim-surround").setup({
  move_cursor = false,
  aliases = {
    ["t"] = ">",
    ["p"] = ")",
    ["b"] = "]",
    ["B"] = "}",
    ["u"] = "_",
    ["e"] = "*",
    ["m"] = "$",
    ["q"] = "\"",
    ["s"] = { "}", "]", ")", ">", '"', "'", "`", "_", "*", "$" },
  },
})

local mode_map = {
  -- ['^n']    = 'N',
  ['^no']   = 'OP',
  -- ['^v']    = 'V',
  ['^[VS]']    = 'LINE',
  -- ['^s']    = 'S',
  ['^[%c%d]']   = 'BLOCK',
  -- ['^i']    = 'I',
  -- ['^[rR]'] = 'R',
  -- ['^Rv']   = 'V·R',
  ['^c']    = 'CMD',
  ['^!']    = 'SHELL',
  ['^t']    = 'TERM',
}

require('kanagawa').setup({
  transparent = true, dimInactive = true,
  colors = {theme = {all = {ui = {bg_gutter = "none"}}}}
})

require('lualine').setup {
  options = {
    theme = require('status'),
    section_separators = {},
    globalstatus = true,
  },
  sections = {
    lualine_a = {{ 
      function()
        if vim.api.nvim_get_mode().mode:match('^i') then return ' '
        else return ''; end
      end,
      padding = { left = 0.5, right = 1 }
    }},
    lualine_b = {{
      function()
        for re, name in pairs(mode_map) do
          if vim.api.nvim_get_mode().mode:match(re) then return ' · ' .. name; end
        end; return ' '
      end,
      padding = 0.5
    }},
    lualine_c = {}, lualine_x = {}, lualine_y = {},
    lualine_z = {{
      'location', padding = 0.5,
      fmt = function(str) return string.gsub(str, ":", "  "); end
    }}
  }
}