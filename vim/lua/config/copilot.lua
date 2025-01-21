local M = {}

function M.setup()
    vim.keymap.set('i', '<C-j>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
    })
    vim.g.copilot_no_tab_map = true
end

return M
