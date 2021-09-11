local M = {}
local format = require "plugins.completion.format"
local bind = require "keymap.bind"
-- local telescope = require("telescope.builtin")

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.documentationFormat = {
   "markdown",
}
M.capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
M.capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
M.capabilities.textDocument.completion.completionItem.deprecatedSupport = true
M.capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
M.capabilities.textDocument.completion.completionItem.tagSupport = {
   valueSet = { 1 },
}
M.capabilities.textDocument.completion.completionItem.resolveSupport = {
   properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
   },
}

function _G.reload_lsp()
   vim.lsp.stop_client(vim.lsp.get_active_clients())
   vim.cmd [[edit]]
end

function _G.open_lsp_log()
   local path = vim.lsp.get_log_path()
   vim.cmd("edit " .. path)
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
   border = M.borders,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
   border = M.borders,
})

vim.cmd "command! -nargs=0 LspLog call v:lua.open_lsp_log()"
vim.cmd "command! -nargs=0 LspRestart call v:lua.reload_lsp()"

M.on_publish_diagnostics = function(_, result, ctx, config)
   local uri = result.uri
   local bufnr = vim.uri_to_bufnr(uri)

   if not bufnr then
      return
   end

   local diagnostics = result.diagnostics

   vim.lsp.diagnostic.save(diagnostics, bufnr, ctx.client_id)

   if not vim.api.nvim_buf_is_loaded(bufnr) then
      return
   end

   -- don't mutate the original diagnostic because it would interfere with
   -- code action (and probably other stuff, too)
   local prefixed_diagnostics = vim.deepcopy(diagnostics)
   for i, v in pairs(diagnostics) do
      prefixed_diagnostics[i].message = string.format("%s: %s", v.source, v.message)
   end
   vim.lsp.diagnostic.display(prefixed_diagnostics, bufnr, ctx.client_id, config)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(M.on_publish_diagnostics, {
   -- Enable underline, use default values
   underline = true,
   -- Enable virtual text, override spacing to 4
   virtual_text = true,
   signs = { enable = true, priority = 20 },
   -- Disable a feature
   update_in_insert = true,
})
vim.fn.sign_define("LspDiagnosticsSignError", { text = "", texthl = "LspDiagnosticsDefaultError" })
vim.fn.sign_define("LspDiagnosticsSignWarning", { text = "", texthl = "LspDiagnosticsDefaultWarning" })
vim.fn.sign_define("LspDiagnosticsSignInformation", { text = "", texthl = "LspDiagnosticsDefaultInformation" })
vim.fn.sign_define("LspDiagnosticsSignHint", { text = "", texthl = "LspDiagnosticsDefaultHint" })

M.lsp_on_init = function(client)
   vim.notify("Language Server Client successfully started!", "info", {
      title = client.name,
   })
end

M.lsp_on_attach = function(client, bufnr)
   if client.name == "svelte" then
      client.resolved_capabilities.document_formatting = false
   end
   if client.name == "tsserver" then
      client.resolved_capabilities.document_formatting = false
      local ts_utils = require "nvim-lsp-ts-utils"
      ts_utils.setup {
         enable_import_on_completion = true,
      }
      ts_utils.setup_client(client)
   end
   if client.resolved_capabilities.document_formatting then
      format.lsp_before_save()
   end
   vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
   if client.resolved_capabilities.code_lens then
      vim.cmd [[
    augroup CodeLens
      au!
      au InsertEnter,InsertLeave * lua vim.lsp.codelens.refresh()
    augroup END
    ]]
   end
   M.lsp_mappings()
end

M.borders = {
   -- fancy border
   { "🭽", "FloatBorder" },
   { "▔", "FloatBorder" },
   { "🭾", "FloatBorder" },
   { "▕", "FloatBorder" },
   { "🭿", "FloatBorder" },
   { "▁", "FloatBorder" },
   { "🭼", "FloatBorder" },
   { "▏", "FloatBorder" },
}

M.lsp_mappings = function()
   local map_cmd = bind.map_cmd
   local mappings = {
      ["i|<C-s>"] = map_cmd("<cmd>lua vim.lsp.buf.signature_help()<CR>"):with_noremap():with_silent(),
      ["n|K"] = map_cmd("<cmd>lua vim.lsp.buf.hover()<CR>"):with_noremap():with_silent(),
      ["n|<Leader>ga"] = map_cmd("<cmd>lua telescope.lsp_code_actions()<CR>"):with_noremap():with_silent(),
      ["n|<Leader>gf"] = map_cmd("<cmd>lua vim.lsp.buf.formatting_seq_sync()<CR>"):with_noremap():with_silent(),
      ["v|<Leader>gf"] = map_cmd("<cmd>lua vim.lsp.buf.range_formatting()<CR>"):with_noremap():with_silent(),
      ["n|<Leader>gd"] = map_cmd("<cmd>lua vim.lsp.buf.definition()<CR>"):with_noremap():with_silent(),
      ["n|<Leader>gl"] = map_cmd("<cmd>lua vim.lsp.codelens.run()<CR>"):with_noremap():with_silent(),

      ["n|<Leader>gD"] = map_cmd(
         "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics { show_header = false, border = require 'plugins.completion.lsp.config' .borders }<CR>"
      )
         :with_noremap()
         :with_silent(),
      ["n|<Leader>gr"] = map_cmd("<cmd>lua telescope.lsp_references()<CR>"):with_noremap():with_silent(),
      ["n|<Leader>gR"] = map_cmd("<cmd>lua vim.lsp.buf.rename()<CR>"):with_noremap():with_silent(),
      ["n|<Leader>g]"] = map_cmd(
         "<cmd>lua vim.lsp.diagnostic.goto_next { popup_opts = { show_header = false, border = require 'plugins.completion.lsp.config' .borders } }<CR>"
      )
         :with_noremap()
         :with_silent(),
      ["n|<Leader>g["] = map_cmd(
         "<cmd>lua vim.lsp.diagnostic.goto_prev { popup_opts = { show_header = false, border = require 'plugins.completion.lsp.config' .borders } }<CR>"
      )
         :with_noremap()
         :with_silent(),
   }

   bind.nvim_load_mapping(mappings)
end

return M
