-- flash.nvim: label-based search + jumping

local flash = require('flash')

flash.setup({
  jump = { autojump = true },        -- jump immediately on unique match
  prompt = { prefix = {} },          -- no prompt prefix

  modes = {
    search = { enabled = true },     -- enhance any /-prompt with labels
    char = {
      enabled = true,
      jump_labels = false,           -- jump to first match
      autohide = true,               -- dismiss highlights immediately on jump
      multi_line = true,
      -- 6 hardcoded slots (f/F/t/T/;/,)
      keys = { f = 'n', F = 'N', ';', ',' },
    },
  },
})

local set = vim.keymap.set
set({ 'n', 'x', 'o' }, 'f', function() flash.jump() end,       { desc = 'Flash jump' })
set({ 'n', 'x', 'o' }, 'S', function() flash.treesitter() end, { desc = 'Flash treesitter select' })

-- Disable FlashBackdrop italics: links to Comment, which kanagawa renders italic
vim.api.nvim_create_autocmd({ 'VimEnter', 'ColorScheme' }, {
  callback = function()
    local c = vim.api.nvim_get_hl(0, { name = 'Comment', link = false })
    if c and c.fg then
      vim.api.nvim_set_hl(0, 'FlashBackdrop', { fg = c.fg, italic = false })
    end
  end,
})
