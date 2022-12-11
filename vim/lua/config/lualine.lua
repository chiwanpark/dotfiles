local M = {}

function M.setup()
  require("lualine").setup({
    extensions = {"nerdtree"}
  })
end

return M

