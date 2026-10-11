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
  local maps = {
    bn = "<Cmd>BufferLineCycleNext<CR>",
    bp = "<Cmd>BufferLineCyclePrev<CR>",
  }
  for i = 1, 9 do
    maps["b" .. i] = ("<Cmd>lua require('bufferline').go_to_buffer(%d, true)<CR>"):format(i)
  end

  local active = false

  local function enable()
    if active then
      return
    end
    for lhs, rhs in pairs(maps) do
      vim.keymap.set("c", lhs, rhs, { silent = true })
    end
    active = true
  end

  local function disable()
    if not active then
      return
    end
    for lhs, _ in pairs(maps) do
      pcall(vim.keymap.del, "c", lhs)
    end
    active = false
  end

  local group = vim.api.nvim_create_augroup("BufferlineCmdlineKeymap", { clear = true })
  vim.api.nvim_create_autocmd("CmdlineEnter", { group = group, pattern = ":", callback = enable })
  vim.api.nvim_create_autocmd("CmdlineLeave", { group = group, pattern = "*", callback = disable })
  vim.api.nvim_create_autocmd("CmdlineChanged", {
    group = group,
    pattern = ":",
    callback = function()
      if vim.fn.getcmdline() == "" then
        enable()
      else
        disable()
      end
    end,
  })
end

return M

