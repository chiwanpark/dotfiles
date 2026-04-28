local M = {}

local parsers = {
  "dockerfile", "bash",
  "go", "gomod",
  "html", "css", "scss", "svelte", "typescript", "tsx", "javascript",
  "lua", "python", "cpp", "c", "dart", "java", "scala",
  "comment", "markdown", "json", "toml", "yaml",
  "sql", "graphql",
}

function M.run_on_update()
  require("nvim-treesitter").install(parsers):wait(300000)
end

function M.setup()
  local ts = require("nvim-treesitter")

  ts.setup()
  ts.install(parsers)

  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local max_filesize = 100 * 1024
      local uv = vim.uv or vim.loop
      local ok, stats = pcall(uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
      if ok and stats and stats.size > max_filesize then
        return
      end

      pcall(vim.treesitter.start, args.buf)
    end,
  })
end

return M
