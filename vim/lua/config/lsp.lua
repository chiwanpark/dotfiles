local M = {}

function M.setup()
  local keymap = vim.keymap.set
  local diag = vim.diagnostic
  local opts = { noremap = true, silent = true }
  keymap("n", "<Leader>e", diag.open_float, opts)
  keymap("n", "[d", diag.goto_prev, opts)
  keymap("n", "]d", diag.goto_next, opts)
  keymap("n", "<Leader>q", diag.setloclist, opts)

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
      -- disable expandtab due to svelte requires tab as indent
      vim.bo.expandtab = false
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
      -- gofmt/goimports on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = {"*.go"},
        callback = function()
          vim.lsp.buf.format({
            timeout_ms = 3000,
          })

          local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
          params.context = {only = {"source.organizeImports"}}

          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
          for _, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
              else
                vim.lsp.buf.execute_command(r.command)
              end
            end
          end
        end
      })
    end,
    capabilities = capabilities,
    settings = {
      gopls = {
        ["local"] = "cheetah"
      },
    },
  }
end

return M
