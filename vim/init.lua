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

local providers = vim.fn.stdpath("data") .. "/providers"
if vim.fn.executable(providers .. "/python/bin/python") == 1 then
  vim.g.python3_host_prog = providers .. "/python/bin/python"
end
if vim.fn.filereadable(providers .. "/node/node_modules/neovim/bin/cli.js") == 1 then
  vim.g.node_host_prog = providers .. "/node/node_modules/neovim/bin/cli.js"
end
if vim.fn.executable(providers .. "/ruby/neovim-ruby-host") == 1 then
  vim.g.ruby_host_prog = providers .. "/ruby/neovim-ruby-host"
end

if vim.g.clipboard == nil
  and (vim.env.TMUX or "") == ""
  and (vim.env.DISPLAY or "") == ""
  and (vim.env.WAYLAND_DISPLAY or "") == ""
  and vim.fn.has("mac") == 0
then
  local osc52 = require("vim.ui.clipboard.osc52")
  local function paste()
    return { vim.fn.getreg("", 1, true), vim.fn.getregtype("") }
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("+") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end

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

-- enable mouse
o.mouse = nvi

