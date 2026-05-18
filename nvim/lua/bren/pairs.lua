-- Mnemonic pairs + mini.surround/ai input pattern builder

local M = {}

M.mnemonics = {
  p = { '(', ')' }, b = { '[', ']' },
  B = { '{', '}' }, t = { '<', '>' },
  q = { '"', '"' },
  u = { '_', '_' }, e = { '*', '*' }, m = { '$', '$' },
}

-- { outer, inner-extract } for mini.* `input` spec
function M.input(open, close)
  if open ~= close then
    return { '%b' .. open .. close, '^.().*().$' }
  end
  local lit = open:match('%w') and open or '%' .. open
  return { lit .. '().-()' .. lit }
end

return M
