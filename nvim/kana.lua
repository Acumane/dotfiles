local col = {
  FG = '#979589',
  V  = '#ADA0D3',
  R  = '#E67B7F',
  N  = '#B4BE82',
}
local default = { fg = col.FG, bg = nil, gui = 'bold' }

return {
  visual = {
    a = { fg = col.V,  bg = nil }, z = default,
  },
  replace = {
    a = { fg = col.R,  bg = nil }, z = default,
  },
  normal = {
    a = { fg = col.N,  bg = nil }, b = default, z = default,
  },
  insert = {
    a = { fg = nil,    bg = nil }, z = default,
  },
}