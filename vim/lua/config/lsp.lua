local M = {}

function M.setup()
  local keymap = vim.keymap.set
  local diag = vim.diagnostic
  local opts = { noremap = true, silent = true }
  keymap("n", "<Leader>e", diag.open_float, opts)
  keymap("n", "[d", diag.goto_prev, opts)
  keymap("n", "]d", diag.goto_next, opts)
  keymap("n", "<Laeder>q", diag.setloclist, opts)

  local on_attach = function(client, bufnr)
    local keymap = vim.keymap.set
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    local lsp = vim.lsp.buf
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    keymap("n", "<Leader>gd", lsp.definition, bufopts)
    keymap("n", "<Leader>gi", lsp.implementation, bufopts)
    keymap("n", "<Leader>K", lsp.hover, bufopts)
    keymap("n", "<Leader>rn", lsp.rename, bufopts)
    keymap("n", "<Leader>ca", lsp.code_action, bufopts)
    keymap("n", "<Leader>f", function()
      vim.lsp.buf.format { async = true }
    end, bufopts)
  end

  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  local lspconfig = require("lspconfig")
  lspconfig["tsserver"].setup {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      vim.bo.tabstop = 2
      vim.bo.shiftwidth = 2
    end,
    capabilities = capabilities,
  }
  lspconfig["svelte"].setup {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      vim.bo.tabstop = 2
      vim.bo.shiftwidth = 2
    end,
    capabilities = capabilities,
  }
  lspconfig["tailwindcss"].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
  lspconfig["gopls"].setup {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      -- disable exapndtab due to golang requires tab as indent
      vim.bo.expandtab = false
    end,
    capabilities = capabilities,
  }
  lspconfig["pylsp"].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            enabled = false,
          },
          pyflakes = {
            enabled = false,
          },
          flake8 = {
            enabled = true,
            ignore = {"E402"},
            exclude = {".git", "__pycache__", "build", "dist"},
            maxLineLength = 120,
            maxComplexity = 10,
          },
        },
      },
    },
  }
end

return M

