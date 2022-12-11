local M = {}

function M.setup()
  local u = require("utils")
  u.keymap("", "<Leader>nt", "<ESC>:NERDTreeToggle<CR>", {})
end

return M

