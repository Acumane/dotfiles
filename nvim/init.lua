local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({
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

require('kanagawa').setup({
  transparent = true, dimInactive = true,
  colors = {theme = {all = {ui = {bg_gutter = "none"}}}}
})

require('lualine').setup {
  options = {
    theme = { normal = { z = { fg = "#54546D", bg = nil } } },
    section_separators = {},
    globalstatus = true,
  },
  sections = {
    lualine_a = {}, lualine_b = {}, lualine_c = {}, lualine_x = {}, lualine_y = {},
    lualine_z = {{
      'location', padding = 0.5,
      fmt = function(str) return string.gsub(str, ":", ", "); end,
    }}
  }
}
