require("plugins").setup()

local o = vim.opt

-- buffer management
-- use buffer as tab
o.hidden = true
-- (1) read opened files again if there are changes outside nvim
-- (2) write a modified buffer on each :bnext, :bprev, ...
o.autoread = true
o.autowrite = true

-- search & clipboard
o.incsearch = true
o.clipboard = "unnamedplus"

-- indent
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true
o.autoindent = true

-- column (number & sign)
o.number = true
o.signcolumn = "yes"

-- disable mouse
o.mouse = ""

