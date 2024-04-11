local M = {}

function M.setup()
  -- bufferline configuration
  require("bufferline").setup({
    options = {
      numbers = "ordinal",
      show_tab_indicators = true,
      show_buffer_close_icons = false,
      show_close_icon = false,
      indicator = { style = "none" },
      diagnostics = "nvim_lsp",
      color_icons = true,
    }
  })

  -- keymap for switch buffers
  local u = require("utils")
  u.keymap("c", "bn", "<Cmd>BufferLineCycleNext<CR>", { noremap = false })
  u.keymap("c", "bp", "<Cmd>BufferLineCyclePrev<CR>", { noremap = false })
  u.keymap("c", "b1", "<Cmd>lua require('bufferline').go_to_buffer(1, true)<CR>", { noremap = false })
  u.keymap("c", "b2", "<Cmd>lua require('bufferline').go_to_buffer(2, true)<CR>", { noremap = false })
  u.keymap("c", "b3", "<Cmd>lua require('bufferline').go_to_buffer(3, true)<CR>", { noremap = false })
  u.keymap("c", "b4", "<Cmd>lua require('bufferline').go_to_buffer(4, true)<CR>", { noremap = false })
  u.keymap("c", "b5", "<Cmd>lua require('bufferline').go_to_buffer(5, true)<CR>", { noremap = false })
  u.keymap("c", "b6", "<Cmd>lua require('bufferline').go_to_buffer(6, true)<CR>", { noremap = false })
  u.keymap("c", "b7", "<Cmd>lua require('bufferline').go_to_buffer(7, true)<CR>", { noremap = false })
  u.keymap("c", "b8", "<Cmd>lua require('bufferline').go_to_buffer(8, true)<CR>", { noremap = false })
  u.keymap("c", "b9", "<Cmd>lua require('bufferline').go_to_buffer(9, true)<CR>", { noremap = false })
end

return M

