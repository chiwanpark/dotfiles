local M = {}

function M.run_on_update()
  require("nvim-treesitter.install").update({ with_sync = true })()
end

function M.setup()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "dockerfile", "bash",
      "go", "gomod",
      "html", "css", "scss", "svelte", "typescript", "tsx", "javascript",
      "lua", "python", "cpp", "c", "dart", "java", "scala", 
      "comment", "markdown", "json", "toml", "yaml",
      "sql", "graphql",
    },
    sync_install = true,
    auto_install = true,
    highlight = {
      enable = true,
      disable = function(lang, buf)
        local max_filesize = 100 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      additional_vim_regex_highlighting = { "python" },
    }
  })
end

return M

