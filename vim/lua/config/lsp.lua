local M = {}

function M.setup()
  local keymap = vim.keymap.set
  local diag = vim.diagnostic
  local opts = { noremap = true, silent = true }
  keymap("n", "<Leader>e", diag.open_float, opts)
  local function jump(count)
    diag.jump({
      count = count,
      on_jump = function(_, bufnr)
        diag.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
      end,
    })
  end
  keymap("n", "[d", function() jump(-1) end, opts)
  keymap("n", "]d", function() jump(1) end, opts)
  keymap("n", "<Leader>q", diag.setloclist, opts)

  local on_attach = function(client, bufnr)
    local keymap = vim.keymap.set
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

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
  
  -- ts_ls
  vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      vim.bo.tabstop = 2
      vim.bo.shiftwidth = 2
    end,
    capabilities = capabilities,
  })
  vim.lsp.enable("ts_ls")

  -- svelte
  vim.lsp.config("svelte", {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      -- disable expandtab due to svelte requires tab as indent
      vim.bo.expandtab = false
      vim.bo.tabstop = 2
      vim.bo.shiftwidth = 2
    end,
    capabilities = capabilities,
  })
  vim.lsp.enable("svelte")

  -- tailwindcss
  vim.lsp.config("tailwindcss", {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  vim.lsp.enable("tailwindcss")

  -- gopls
  vim.lsp.config("gopls", {
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

          local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
          params.context = {only = {"source.organizeImports"}}

          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
          for client_id, res in pairs(result or {}) do
            local c = vim.lsp.get_client_by_id(client_id)
            for _, r in pairs(c and res.result or {}) do
              if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, c.offset_encoding)
              else
                c:exec_cmd(r.command)
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
  })
  vim.lsp.enable("gopls")

  -- pylsp
  vim.lsp.config("pylsp", {
    on_attach = on_attach,
    settings = {
      pylsp = {
        plugins = {
          flake8 = {
            enabled = false,
          },
          mypy = {
            enabled = true,
          },
          pycodestyle = {
            enabled = false,
          },
          pyflakes = {
            enabled = false,
          },
        }
      }
    }
  })
  vim.lsp.enable("pylsp")

  vim.lsp.config("rust_analyzer", {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        check = { command = "clippy" },
      },
    },
  })
  vim.lsp.enable("rust_analyzer")

  -- clangd
  vim.lsp.config("clangd", {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      vim.bo.tabstop = 2
      vim.bo.shiftwidth = 2
    end,
    capabilities = capabilities,
  })
  vim.lsp.enable("clangd")
end

return M