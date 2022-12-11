local M = {}

function M.setup()
  vim.opt.termguicolors = true
  require("onedark").load()
end

return M

