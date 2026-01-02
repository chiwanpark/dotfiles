local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

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

