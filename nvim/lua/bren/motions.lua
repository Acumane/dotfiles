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
  o = '%',   O = '%',
}
for lhs, rhs in pairs(motions) do
  set({'n','v','o'}, lhs, rhs)
end

set('v', 'L', 'g_')  -- last non-blank (don't grab newline)

-- <#>G -> <#>g
set('n', 'g', function() return vim.v.count > 0 and 'G' or 'g' end,
  { expr = true, nowait = true, desc = 'g / <count>G' })
