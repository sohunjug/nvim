local M = {}
local format = require "plugins.completion.format"
local bind = require "keymap.bind"
-- local telescope = require("telescope.builtin")

if not packer_plugins["telescope.nvim"] or not packer_plugins["telescope.nvim"].loaded then
   vim.cmd [[packadd telescope.nvim]]
end
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.documentationFormat = {
   "markdown",
}
M.capabilities.textDocument.completion.completionItem.preselectSupport = true
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
   update_in_insert = false,
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
   if client.name == "vuels" then
      client.resolved_capabilities.document_formatting = false
   end
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
   M.lsp_mappings(bufnr)
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

M.lsp_mappings = function(bufnr)
   local map_cr = bind.map_cr
   local map_cu = bind.map_cu
   local map_cmd = bind.map_cu
   local mappings = {
      ["n|<Leader>en"] = map_cr("lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()"):with_silent(),
      ["n|<Leader>ep"] = map_cr("lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()"):with_silent(),
      -- ["n|<C-[>"] = map_cr("lua vim.lsp.buf.incoming_calls()"):with_silent(),
      -- ["n|<C-]>"] = map_cr("lua vim.lsp.buf.outgoing_calls()"):with_silent(),
      ["n|ep"] = map_cr("lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()"):with_silent(),
      ["n|en"] = map_cr("lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()"):with_silent(),
      ["n|K"] = map_cr("lua require'lspsaga.hover'.render_hover_doc"):with_silent(),
      ["n|ga"] = map_cr("lua require('lspsaga.codeaction').code_action()"):with_silent(),
      ["v|ga"] = map_cu("lua require('lspsaga.codeaction').range_code_action()"):with_silent(),
      ["n|gd"] = map_cr("lua require'telescope.builtin.lsp'.definitions()"):with_silent(),
      ["n|gr"] = map_cr("lua require'telescope.builtin.lsp'.references()"):with_silent(),
      ["n|gi"] = map_cr("lua vim.lsp.buf.implementation()"):with_silent(),
      ["n|gs"] = map_cr("lua require('lspsaga.signaturehelp').signature_help()"):with_silent(),
      ["n|gR"] = map_cr("lua require('lspsaga.rename').rename()"):with_noremap():with_silent(),
      ["n|gh"] = map_cr("lua require'lspsaga.provider'.lsp_finder()"):with_silent(),
      ["n|gt"] = map_cr("lua vim.lsp.buf.type_definition()"):with_silent(),
      ["n|gS"] = map_cr("lua vim.lsp.buf.workspace_symbol()"):with_silent(),
      ["n|gl"] = map_cr("lua require'lspsaga.diagnostic'.show_line_diagnostics()"):with_silent(),
      ["n|gw"] = map_cr("lua require'lspsaga.diagnostic'.show_cursor_diagnostics()"):with_silent(),
      ["n|g]"] = map_cr(
         "lua vim.lsp.diagnostic.goto_next { popup_opts = { show_header = false, border = require 'plugins.completion.lsp.config' .borders } }"
      )
         :with_noremap()
         :with_silent(),
      ["n|g["] = map_cr(
         "lua vim.lsp.diagnostic.goto_prev { popup_opts = { show_header = false, border = require 'plugins.completion.lsp.config' .borders } }"
      )
         :with_noremap()
         :with_silent(),
      ["n|<Esc>"] = map_cmd "<nop>",
      ["x|<Esc>"] = map_cmd "<nop>",
      ["v|<Esc>"] = map_cmd "<nop>",
      --[[ ["i|<C-s>"] = map_cr("lua vim.lsp.buf.signature_help()"):with_noremap():with_silent(),
      ["n|K"] = map_cr("lua vim.lsp.buf.hover()"):with_noremap():with_silent(),
      ["n|<Leader>en"] = map_cr("lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()")
         :with_noremap()
         :with_silent(),
      ["n|<Leader>ep"] = map_cr("lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()")
         :with_noremap()
         :with_silent(),
      ["n|[e"] = map_cr("lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()"):with_noremap():with_silent(),
      ["n|]e"] = map_cr("lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()"):with_noremap():with_silent(),
      ["n|<Leader>ga"] = map_cr("lua require'telescope'.lsp_code_actions()"):with_noremap():with_silent(),
      ["n|<Leader>gf"] = map_cr("lua vim.lsp.buf.formatting_seq_sync()"):with_noremap():with_silent(),
      ["v|<Leader>gf"] = map_cr("lua vim.lsp.buf.range_formatting()"):with_noremap():with_silent(),
      ["n|<Leader>gd"] = map_cr("lua vim.lsp.buf.definition()"):with_noremap():with_silent(),
      ["n|<Leader>gl"] = map_cr("lua vim.lsp.codelens.run()"):with_noremap():with_silent(),

      ["n|<Leader>gD"] = map_cr(
         "lua vim.lsp.diagnostic.show_line_diagnostics { show_header = false, border = require 'plugins.completion.lsp.config' .borders }"
      )
         :with_noremap()
         :with_silent(),
      ["n|<Leader>gr"] = map_cr("lua require'telescope'.lsp_references()"):with_noremap():with_silent(),
      ["n|<Leader>gR"] = map_cr("lua vim.lsp.buf.rename()"):with_noremap():with_silent(),
      ["n|<Leader>g]"] = map_cr(
         "lua vim.lsp.diagnostic.goto_next { popup_opts = { show_header = false, border = require 'plugins.completion.lsp.config' .borders } }"
      )
         :with_noremap()
         :with_silent(),
      ["n|<Leader>g["] = map_cr(
         "lua vim.lsp.diagnostic.goto_prev { popup_opts = { show_header = false, border = require 'plugins.completion.lsp.config' .borders } }"
      )
         :with_noremap()
         :with_silent(), ]]
   }

   bind.nvim_load_mapping(mappings, true, bufnr)
end

return M
