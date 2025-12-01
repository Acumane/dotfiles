local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazy_path) then
  local lazy_repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazy_repo, lazy_path })
end
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({
  "kylechui/nvim-surround",
  "luochen1990/select-and-search",
  "johmsalas/text-case.nvim",
  "justinmk/vim-ipmotion",
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cond = not vim.g.vscode
  },
  {
    "rebelot/kanagawa.nvim",
    cond = not vim.g.vscode
  },
  {
    "vscode-neovim/vscode-multi-cursor.nvim",
    event = "VeryLazy",
    cond = not not vim.g.vscode,
    opts = {},
    config = function()
      require("vscode-multi-cursor").setup({ default_mappings = false })
      local cursors = require("vscode-multi-cursor")

      local k = vim.keymap.set
      k({ 'n', 'x' }, '<Leader>m', cursors.create_cursor, { expr = true })
      k({ 'n' }, 'dm', cursors.cancel)
      k({ 'n', 'x' }, '<Leader>H', cursors.start_right)
    end
  }
})

vim.opt.compatible = false
vim.opt.shortmess = "IA"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.fillchars = { eob = " " }
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartcase = true
vim.opt.laststatus = 0
vim.opt.matchpairs:append("<:>")

-- Terminal settings
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.modifiable = true
    vim.cmd("startinsert")
  end
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
  },
})

if not vim.g.vscode then
  require('kanagawa').setup({
    transparent = true,
    dimInactive = true,
    colors = { theme = { all = { ui = { bg_gutter = "none" } } } }
  })

  require('lualine').setup({
    options = {
      theme = { normal = { z = { fg = "#54546D", bg = nil } } },
      section_separators = {},
      globalstatus = true,
    },
    sections = {
      lualine_a = {}, lualine_b = {}, lualine_c = {}, lualine_x = {}, lualine_y = {},
      lualine_z = {{
        'location',
        padding = 0.5,
        fmt = function(str) return string.gsub(str, ":", ", ") end,
      }}
    }
  })
end

local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function nmap(lhs, rhs, opts) map('n', lhs, rhs, opts) end
local function vmap(lhs, rhs, opts) map('v', lhs, rhs, opts) end
local function xmap(lhs, rhs, opts) map('x', lhs, rhs, opts) end
local function omap(lhs, rhs, opts) map('o', lhs, rhs, opts) end
local function imap(lhs, rhs, opts) map('i', lhs, rhs, opts) end
local function tmap(lhs, rhs, opts) map('t', lhs, rhs, opts) end
local function cmap(lhs, rhs, opts) map('c', lhs, rhs, opts) end

nmap('i', 'gk')
vmap('i', 'gk')
map('', 'j', '<Left>')
map('', 'k', 'gj')

-- (h)ere = insert
map('', 'h', 'i')
nmap('H', 'a')
omap('<Down>', '<Nop>')

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  command = "norm! zz"  -- center screen
})

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "exec \"normal! `^\""  -- last pos
})

vmap('H', 'A')
vmap('hh', '<Esc>i')
vmap('hi', '<Esc>i')

-- surround shortcuts
local surround_chars = { '`', '"', ')', ']', '{', '}', '>', '*', '_', '$' }

for _, ch in ipairs(surround_chars) do
  nmap(ch, '<Cmd>norm vhwS' .. ch .. 'el<CR>', { nowait = true })
  vmap(ch, ':<C-u>exec "norm gvS' .. ch .. 'l"<CR>', { nowait = true })
  nmap('d' .. ch, 'ds' .. ch)
end

nmap("'", "<Cmd>norm vhwS'el<CR>")
vmap("'", ":<C-u>exec \"norm gvS'l\"<CR>")
nmap("d'", "ds'")

-- cycle case/CASE
vmap('~', '~gv')
nmap('~', '~h')

-- (t)o (c)ase
map('', 'tk', 'tn')
map('', 'tt', ':lua require("textcase").current_word("to_phrase_case")<CR>')

-- sane <inc|dec>rement
nmap('=', '<C-a>')
nmap('+', '<C-a>')
nmap('-', '<C-x>')

-- (Back)space in normal mode
nmap('<space>', 'i<space><esc>')
nmap('<backspace>', 'h<Del><esc>')

-- (o)ther in pair
nmap('o', '%')
nmap('O', '%')

-- (r)eplace
map('', 'r', '"_c')
nmap('R', '"_cc')
nmap('rr', '"_cc')

-- (s)ubstitute
map('', 's', 'r')

-- (c)opy
map('', 'c', 'y')
nmap('C', 'yy')
nmap('cc', 'yy')

-- x (cut)
map('', 'x', 'd')
nmap('X', 'dd')
nmap('xx', 'dd')

-- Restore transpose
nmap('xp', 'xp')
vmap('p', '"_dP')

-- true (d)elete
map('', 'd', '"_d')
nmap('D', '"_dd')
nmap('dd', '"_dd')

-- Disable 'down' in motions (useless)
local ops = {'d', 'c', 'r', 'x'}
local useless = {'k'}
for _, op in ipairs(ops) do
  for _, dir in ipairs(useless) do
    nmap(op .. dir, '<Nop>')
  end
end

-- vscode-neovim settings
if not vim.g.vscode then
  -- <[S|C]-Del> (kitty)
  nmap('<S-Del>', 'dvb')
  imap('<S-Del>', '<C-w>')
  cmap('<S-Del>', '<C-w>')
  nmap('q', ':q<CR>')
  vim.opt.guicursor:append('i-c:ver1')
  vim.opt.guicursor:append('n-i-c:blinkon500')
  vim.opt.cmdheight = 0
  vim.cmd('colorscheme kanagawa')
else
  vim.opt.cmdheight = 1
end

-- canonical functions
nmap('<C-a>', 'gg^vG$h')
vmap('<C-a>', 'gg^oG$h')
imap('<C-a>', '<Esc>gg^vG$h')
tmap('<Esc>', '<C-\\><C-n>')

vmap('<C-c>', 'y')
vmap('<C-x>', 'x')
map('', '<C-p>', 'p')

map('', '<C-u>', 'u')
imap('<C-u>', '<C-o>u')
map('', 'u', '<Nop>')

-- new text objects
local new_obj = { '*', '_', '$' }

for _, ch in ipairs(new_obj) do
  omap('i' .. ch, ':<C-u>norm! T' .. ch .. 'vt' .. ch .. '<CR>')
  vmap('h' .. ch, 'T' .. ch .. 'ot' .. ch)
  omap('a' .. ch, ':<C-u>norm! F' .. ch .. 'vf' .. ch .. '<CR>')
  vmap('a' .. ch, 'F' .. ch .. 'of' .. ch)
end

-- Mnemonic text objects
local mnemonic_pairs = {
  p = ')', b = ']', B = '}', q = '"', t = '>', u = '_', e = '*', m = '$'
}

for l, r in pairs(mnemonic_pairs) do
  for _, mode in ipairs({'o', 'v'}) do
    vim.keymap.set(mode, 'h' .. l, 'i' .. r)
    vim.keymap.set(mode, 'a' .. l, 'a' .. r)
  end
  omap('i' .. l, 'i' .. r)
  
  -- Surround commands 
  vim.cmd('nmap rs' .. l .. ' css' .. r)
  vim.cmd('nmap d' .. l .. ' ds' .. r)
end

-- (P)aragraph text objects
for _, mode in ipairs({'o', 'v'}) do
  vim.keymap.set(mode, 'hP', 'ip')
  vim.keymap.set(mode, 'aP', 'ap')
end
omap('iP', 'ip')

-- pair replace
local obj = {
  't', 'p', 'b', 'B', 'u', 'e', 'm', 'q', 's',
  '>', ')', ']', '}', '_', '*', '$', '"', "'", '`'
}

for _, a in ipairs(obj) do
  for _, b in ipairs(obj) do
    vim.cmd('nmap r' .. a .. b .. ' cs' .. a .. b)
  end
end

map('', 'W', 'b')
map('', 'E', 'ge')

map('', 'T', 'gg')
map('', 'B', 'GL')

map('', 'I', '{')
map('', 'K', '}')
map('', 'J', 'g0')
map('', 'L', '$')
vmap('L', 'g_')

-- (n)ext occurence
map('', 'n', 'f')
map('', 'N', 'F')
map('', ',', ';')
map('', '<', ',')

-- (S-)enter: newline OR search
nmap('<enter>', function()
  return vim.fn.getreg('/') == '' and 'o' or 'n'
end, { expr = true })

nmap('<S-enter>', function()
  return vim.fn.getreg('/') == '' and 'O' or 'N'
end, { expr = true })

-- (f)ind
nmap('f', function()
  vim.fn.setreg('/', vim.fn.expand('<cword>'))
  vim.opt.hlsearch = true
  vim.fn.feedkeys('/' .. vim.fn.getreg('/'))
end, { silent = true })

vmap('f', 'y:let @/=@" <bar>:set hls<CR>gn', { silent = true })

-- clear search pattern register (@/):
nmap('<Esc>', '<Cmd>nohl<CR><Cmd>let @/ = ""<CR>')

vim.api.nvim_create_augroup('ClearSearch', { clear = true })
vim.api.nvim_create_autocmd('BufReadPost', {
  group = 'ClearSearch',
  pattern = '*',
  callback = function()
    vim.fn.setreg('/', '')
  end
})

-- <#>G -> <#>g
nmap('g', function()
  return vim.v.count > 0 and 'G' or 'g'
end, { expr = true, nowait = true })

-- use Tab
nmap('<Tab>', '>>')
nmap('<S-Tab>', '<<')
vmap('<Tab>', '>><Esc>gv')
vmap('<S-Tab>', '<<<Esc>gv')

-- block mode (C-v is copy)
vmap('b', '<C-v>')
