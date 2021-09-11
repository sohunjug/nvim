local lspconfig = require "lspconfig"
local config = require "plugins.completion.lsp.config"

if not packer_plugins["lspsaga.nvim"].loaded then
   vim.cmd [[packadd lspsaga.nvim]]
end

local servers = {}
servers.cssls = {}
servers.dockerls = {}
servers.bashls = {}
servers.pyright = {}
servers.rnix = {}

local saga = require "lspsaga"
saga.init_lsp_saga { code_action_icon = "💡" }

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
servers.tsserver = { init_options = { documentFormatting = false } }

servers.sumneko_lua = require("plugins.completion.lsp.sumneko").config

servers.gopls = require("plugins.completion.lsp.golang").config

servers.jsonls = require("plugins.completion.lsp.json").config

servers.vuels = require("plugins.completion.lsp.vue").config

servers.yamlls = require("plugins.completion.lsp.yaml").config

servers.graphql = {
   root_dir = require"lspconfig.util".root_pattern(".graphqlrc.yml", ".qraphqlrc"),
}

servers["null-ls"] = {}

servers.clangd = {
   cmd = { "clangd", "--background-index", "--suggest-missing-includes", "--clang-tidy", "--header-insertion=iwyu" },
}

servers.rust_analyzer = { capabilities = config.capabilities }

servers.denols = {
   filetypes = { "javascript", "typescript", "typescriptreact" },
   root_dir = vim.loop.cwd,
   settings = {
      documentFormatting = false,
      lint = true,
      unstable = true,
      config = "./tsconfig.json",
   },
}

require("plugins.completion.lsp.nullls").setup()

for server, opts in pairs(servers) do
   lspconfig[server].setup(vim.tbl_extend("force", {
      flags = { debounce_text_changes = 150 },
      on_attach = config.lsp_on_attach,
      on_init = config.lsp_on_init,
      capabilities = config.capabilities,
   }, opts))
end
