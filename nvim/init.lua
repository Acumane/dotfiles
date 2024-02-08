local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({
  "kylechui/nvim-surround",
  "johmsalas/text-case.nvim",
  -- "justinmk/vim-ipmotion"
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
