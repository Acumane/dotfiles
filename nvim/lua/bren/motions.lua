local set = vim.keymap.set

-- IJKL as cursor motion
set({'n','v'}, 'i', 'gk', { desc = 'Up' })
set({'n','v','o'}, 'j', '<Left>', { desc = 'Left' })
set({'n','v','o'}, 'k', 'gj', { desc = 'Down' })

-- (h)ere = insert
set('n', 'h', 'i', { desc = 'Insert here' })

-- remove annoying dir motion in op-pending
set('o', '<Down>', '<Nop>')

-- Capital = "stronger" lowercase motion
local motions = {
  L = '$',   J = 'g0',
  K = '}',   I = '{',
  T = 'gg',  B = 'G',
  W = 'b',   E = 'ge',
}
for lhs, rhs in pairs(motions) do
  -- nowait: vscode-neovim has J<x>/K<x> etc.
  set({'n','v','o'}, lhs, rhs, { nowait = true })
end

-- (o)ther in pair (NOT in visual)
set({'n','o'}, 'o', '%', { nowait = true })

set('v', 'L', 'g_')  -- last non-blank (don't grab newline)

-- <#>G -> <#>g
set('n', 'g', function() return vim.v.count > 0 and 'G' or 'g' end,
  { expr = true, nowait = true, desc = 'g / <count>G' })
