-- Leader ------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({'n','v'}, '<Space>', '<Nop>', { silent = true })

-- Editor options ----------------------------------------------------

local opt = vim.opt
opt.shortmess      = "IA"           -- skip intro, abbreviate messages 
opt.number         = true
opt.relativenumber = true
opt.clipboard      = "unnamedplus"  -- use system clipboard
opt.fillchars      = { eob = " " }  -- blank `~` lines past EOB
opt.smartindent    = true
opt.autoindent     = true
opt.shiftwidth     = 4
opt.expandtab      = true
opt.smartcase      = true
opt.laststatus     = 0
opt.matchpairs:append("<:>")        -- <> as a balanced pair for %

if not vim.g.vscode then
  -- Hide cmdline when idle; any startup msg would trigger a hit-enter prompt
  opt.cmdheight = 0
  opt.guicursor:append("i-c:ver1")
  opt.guicursor:append("n-i-c:blinkon500")
else
  opt.cmdheight = 1
end

-- Autocommands ------------------------------------------------------

local function group(name) return vim.api.nvim_create_augroup(name, { clear = true }) end

-- Terminal buffers: no gutter, modifiable, drop into insert
vim.api.nvim_create_autocmd("TermOpen", {
  group = group("bren.term"),
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.modifiable = true
    vim.cmd("startinsert")
  end,
})

-- Return to last pos on leave
vim.api.nvim_create_autocmd("InsertLeave", {
  group = group("bren.insert"),
  pattern = "*",
  command = [[exec "normal! `^"]],
})

-- clear search pattern register (@/)
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group("bren.search"),
  pattern = "*",
  callback = function() vim.fn.setreg("/", "") end,
})

-- Plugin bootstrap (lazy.nvim) --------------------------------------

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazy_path) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazy_path,
  })
end
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup(require("bren.plugins"))

-- Keymap modules ----------------------------------------------------

-- Order matters where modules share a LHS; later wins
require("bren.motions")
require("bren.verbs")
require("bren.surround")
require("bren.textobjects")
require("bren.move")
require("bren.comment")
require("bren.flash")
require("bren.misc")
require("bren.search")  -- last: owns <Esc> in normal
