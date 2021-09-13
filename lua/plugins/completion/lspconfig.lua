local lspconfig = require "lspconfig"
local config = require "plugins.completion.lsp.config"

if not packer_plugins["null-ls.nvim"].loaded then
   vim.cmd [[packadd null-ls.nvim]]
end

local M = {}

M.enabled = false

M.servers = {}
local sumneko = require "plugins.completion.lsp.sumneko"

M.servers.vimls = {}
M.servers.vuels = {}
M.servers.cssls = {}
M.servers.dockerls = {}
M.servers.bashls = {}
M.servers.pyright = {}
M.servers.rnix = {}

function _G.reload_lsp()
   vim.lsp.stop_client(vim.lsp.get_active_clients())
   vim.cmd [[edit]]
end

function _G.open_lsp_log()
   local path = vim.lsp.get_log_path()
   vim.cmd("edit " .. path)
end

-- if vim.fn.executable "lua-format" == 1 and global.efm_enable == true then
--    lspconfig.efm.setup {
--       init_options = { documentFormatting = true },
--       filetypes = { "lua" },
--       settings = {
--          rootMarkers = { ".git/" },
--          languages = {
--             lua = {
--                {
--                   formatCommand = "lua-format -i --no-keep-simple-function-one-line --no-break-after-operator --column-limit=120 --break-after-table-lb",
--                   formatStdin = true,
--                },
--             },
--          },
--       },
--    }
-- end
M.servers.tsserver = { init_options = { documentFormatting = false } }

if sumneko.enable then
   M.servers.sumneko_lua = sumneko.config
end

M.servers.gopls = require("plugins.completion.lsp.golang").config

M.servers.jsonls = require("plugins.completion.lsp.json").config

M.servers.vuels = require("plugins.completion.lsp.vue").config

M.servers.yamlls = require("plugins.completion.lsp.yaml").config

M.servers.graphql = {
   root_dir = require("lspconfig.util").root_pattern(".graphqlrc.yml", ".qraphqlrc"),
}

M.servers["null-ls"] = {}

M.servers.clangd = {
   cmd = { "clangd", "--background-index", "--suggest-missing-includes", "--clang-tidy", "--header-insertion=iwyu" },
}

M.servers.rust_analyzer = { capabilities = config.capabilities }

M.servers.denols = {
   filetypes = { "javascript", "typescript", "typescriptreact" },
   root_dir = vim.loop.cwd,
   settings = {
      documentFormatting = false,
      lint = true,
      unstable = true,
      config = "./tsconfig.json",
   },
}

function M.setup()
   if M.enabled then
      return
   end
   require("plugins.completion.lsp.nullls").setup()

   for server, opts in pairs(M.servers) do
      lspconfig[server].setup(vim.tbl_extend("force", {
         flags = { debounce_text_changes = 150 },
         on_attach = config.lsp_on_attach,
         on_init = config.lsp_on_init,
         capabilities = config.capabilities,
      }, opts))
   end
   M.enabled = true
end

return M
