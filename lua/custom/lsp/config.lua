local M = {}
local format = require "custom.lsp.format"
local bind = require "keymap.bind"
-- local telescope = require("telescope.builtin")

if not packer_plugins["telescope.nvim"] or not packer_plugins["telescope.nvim"].loaded then
   vim.cmd [[packadd telescope.nvim]]
end
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.documentationFormat = {
   "markdown",
   "plaintext",
}
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
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

vim.cmd "command! -nargs=0 LspRestart call v:lua.reload_lsp()"

M.on_publish_diagnostics = function(_, result, ctx, config)
   local uri = result.uri
   local bufnr = vim.uri_to_bufnr(uri)
   if not bufnr then
      return
   end

   local diagnostics = result.diagnostics
   vim.lsp.diagnostic.set(diagnostics, bufnr, ctx.client_id)
   if not vim.api.nvim_buf_is_loaded(bufnr) then
      return
   end
   vim.lsp.diagnostic.show(diagnostics, bufnr, ctx.client_id, config)
end

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(M.on_publish_diagnostics, {
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
   -- Enable underline, use default values
   underline = true,
   -- Enable virtual text, override spacing to 4
   --[[ virtual_text = {
      prefix = "> ",
      spacing = 0,
   }, ]]
   virtual_text = false,
   signs = true,
   -- Disable a feature
   update_in_insert = false,
})

function M.show_line_diagnostics()
   local diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
   local diags = vim.deepcopy(diagnostics)
   local height = #diagnostics
   local width = 0
   local opts = {}
   local close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre" }
   local diagnostic_severities = {
      "Error",
      "Warning",
      "Information",
      "Hint",
   }
   if height == 0 then
      return
   end
   local bufnr = vim.api.nvim_create_buf(false, true)

   for i, diagnostic in ipairs(diagnostics) do
      local source = diagnostic.source
      if source then
         if string.find(source, "/") then
            source = string.sub(diagnostic.source, string.find(diagnostic.source, "([%w-_]+)$"))
         end
         diags[i].message = string.format("%s: %s", source, diagnostic.message)
      else
         diags[i].message = string.format("%s", diagnostic.message)
      end

      if diagnostic.code then
         diags[i].message = string.format("%s [%s]", diags[i].message, diagnostic.code)
      end
      if diags[i].message:len() > width then
         width = string.len(diags[i].message)
      end
   end

   opts = vim.lsp.util.make_floating_popup_options(width, height, opts)
   opts["style"] = "minimal"
   opts["border"] = "rounded"

   vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
   local winnr = vim.api.nvim_open_win(bufnr, false, opts)
   vim.api.nvim_win_set_option(winnr, "winblend", 0)
   vim.api.nvim_buf_set_var(bufnr, "lsp_floating_window", winnr)
   for i, diag in ipairs(diags) do
      local message = diag.message:gsub("[\n\r]", " ")
      vim.api.nvim_buf_set_lines(bufnr, i - 1, i - 1, 0, { message })
      vim.api.nvim_buf_add_highlight(
         bufnr,
         -1,
         "LspDiagnosticsFloating" .. diagnostic_severities[diag.severity],
         i - 1,
         0,
         diag.message:len()
      )
   end
   vim.api.nvim_command(
      "autocmd QuitPre <buffer> ++nested ++once lua pcall(vim.api.nvim_win_close, " .. winnr .. ", true)"
   )
   vim.lsp.util.close_preview_autocmd(close_events, winnr)
end

vim.fn.sign_define("LspDiagnosticsSignError", { text = "", texthl = "LspDiagnosticsDefaultError" })
vim.fn.sign_define("LspDiagnosticsSignWarning", { text = "", texthl = "LspDiagnosticsDefaultWarning" })
vim.fn.sign_define("LspDiagnosticsSignInformation", { text = "", texthl = "LspDiagnosticsDefaultInformation" })
vim.fn.sign_define("LspDiagnosticsSignHint", { text = "", texthl = "LspDiagnosticsDefaultHint" })
vim.fn.sign_define("DiagnosticSignError", { text = "✖", texthl = "LspDiagnosticsDefaultError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "⚠", texthl = "LspDiagnosticsDefaultWarning" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "ℹ", texthl = "LspDiagnosticsDefaultInformation" })
vim.fn.sign_define("DiagnosticSignHint", { text = "➤", texthl = "LspDiagnosticsDefaultHint" })

M.lsp_on_init = function(client)
   vim.notify("Language Server Client successfully started!", "info", {
      title = client.name,
   })
end

M.lsp_on_attach = function(client, bufnr)
   -- if not packer_plugins["lsp_signature"] or not packer_plugins["lsp_signature"].loaded then
   -- vim.cmd [[packadd lsp_signature]]
   -- end
   if not packer_plugins["lsputil"] or not packer_plugins["lsputil"].loaded then
      vim.cmd [[packadd lsputil]]
   end
   if client.name == "vuels" then
      client.server_capabilities.document_formatting = false
   elseif client.name == "vuels" then
      client.server_capabilities.document_formatting = false
   elseif client.name == "nullls" then
      client.server_capabilities.document_formatting = true
   elseif client.name == "sumneko_lua" then
      client.server_capabilities.document_formatting = false
   elseif client.name == "svelte" then
      client.server_capabilities.document_formatting = false
   elseif client.name == "tsserver" then
      client.server_capabilities.document_formatting = false
      local ts_utils = require "nvim-lsp-ts-utils"
      ts_utils.setup {
         enable_import_on_completion = true,
      }
      ts_utils.setup_client(client)
   end
   if client.name == "vuels" then
      client.resolved_capabilities.document_formatting = false
   elseif client.name == "vuels" then
      client.resolved_capabilities.document_formatting = false
   elseif client.name == "nullls" then
      client.resolved_capabilities.document_formatting = true
   elseif client.name == "sumneko_lua" then
      client.resolved_capabilities.document_formatting = false
   elseif client.name == "svelte" then
      client.resolved_capabilities.document_formatting = false
   elseif client.name == "tsserver" then
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
   -- if client.name == "go" then
   -- vim.cmd [[au BufRead *.go set list lcs=tab:\|\  ]]
   -- end
   -- print(client.name)
   -- print(vim.inspect(client.resolved_capabilities))
   vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
   local ext = vim.fn.expand "%:e"
   if ext == "go" then
      vim.api.nvim_buf_set_option(bufnr, "expandtab", false)
   else
      vim.api.nvim_buf_set_option(bufnr, "expandtab", true)
   end
   if client.resolved_capabilities.code_lens then
      vim.cmd [[
    augroup CodeLens
      au!
      au InsertEnter,InsertLeave * lua vim.lsp.codelens.refresh()
    augroup END
    ]]
   end
   M.add_mappings(bufnr)
   --[[if client.name ~= "rnix" then
      vim.lsp.handlers["textDocument/codeAction"] = require("lsputil.codeAction").code_action_handler
   end]]
   vim.lsp.handlers["textDocument/references"] = require("telescope.builtin").lsp_references -- require("lsputil.locations").references_handler
   vim.lsp.handlers["textDocument/definition"] = require("lsputil.locations").definition_handler
   vim.lsp.handlers["textDocument/declaration"] = require("lsputil.locations").declaration_handler
   vim.lsp.handlers["textDocument/typeDefinition"] = require("lsputil.locations").typeDefinition_handler
   vim.lsp.handlers["textDocument/implementation"] = require("lsputil.locations").implementation_handler
   vim.lsp.handlers["textDocument/documentSymbol"] = require("lsputil.symbols").document_handler
   vim.lsp.handlers["workspace/symbol"] = require("lsputil.symbols").workspace_handler
   --[[ local status_ok, lsign = pcall(require, "lsp_signature")
   if not status_ok then
      return
   end
   lsign.on_attach({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      floating_window_above_cur_line = true,
      transpancy = 10,
      shadow_blend = 36,
      handler_opts = {
         border = "shadow",
      },
   }, bufnr) ]]
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

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
   border = M.borders,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
   border = M.borders,
})

vim.cmd "command! -nargs=0 LspLog call v:lua.open_lsp_log()"

M.add_mappings = function(bufnr)
   local status_ok, wk = pcall(require, "which-key")
   if not status_ok then
      return
   end

   local keys = {
      ["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show hover" },
      ["ga"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
      ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
      ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto Declaration" },
      ["gF"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "Goto References Utils" },
      -- ["gr"] = { "<cmd>lua require'telescope.builtin.lsp'.references()<CR>", "Goto References" },
      ["gr"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "Goto References" },
      ["gI"] = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
      ["gR"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename Symbol" },
      ["gs"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Show Signature Help" },
      ["gt"] = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
      ["gp"] = { "<cmd>lua require'custom.lsp.peek'.Peek('definition')<CR>", "Peek definition" },
      ["gl"] = { "<cmd>lua require'custom.lsp.config'.show_line_diagnostics()<CR>", "Show Line Diagnostics" },
      ["ep"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Diagnostic Prev" },
      ["en"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Diagnostic Next" },
      ["et"] = { "<cmd>lua vim.diagnostic.open_float()<CR>", "AutoFormat" },
      ["ef"] = {
         "<cmd>lua vim.g.autoformat = not vim.g.autoformat<CR><cmd>lua require'custom.lsp.format'.lsp_before_save()<CR>",
         "AutoFormat",
      },
      ["<Leader>ep"] = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", "Diagnostic Prev" },
      ["<Leader>en"] = { "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", "Diagnostic Next" },
      ["<Leader>et"] = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Diagnostic Float" },
      ["<Leader>ef"] = {
         "<cmd>lua vim.g.autoformat = not vim.g.autoformat<CR><cmd>lua require'custom.lsp.format'.lsp_before_save()<CR>",
         "AutoFormat",
      },
   }
   wk.register(keys, { mode = "n", buffer = bufnr })
end

M.lsp_mappings = function(bufnr)
   local map_cr = bind.map_cr
   local map_cu = bind.map_cu
   local mappings = {
      ["n|<Leader>en"] = map_cr("lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()")
         :with_noremap()
         :with_silent(),
      ["n|<Leader>ep"] = map_cr("lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()")
         :with_noremap()
         :with_silent(),
      ["n|ep"] = map_cr("lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()"):with_noremap():with_silent(),
      ["n|en"] = map_cr("lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()"):with_noremap():with_silent(),
      ["n|K"] = map_cr("lua vim.lsp.buf.hover()"):with_noremap():with_silent(),
      ["n|ga"] = map_cr("lua require('lspsaga.codeaction').code_action()"):with_noremap():with_silent(),
      ["v|ga"] = map_cu("lua require('lspsaga.codeaction').range_code_action()"):with_noremap():with_silent(),
      ["n|gd"] = map_cr("lua require'telescope.builtin.lsp'.definitions()"):with_noremap():with_silent(),
      ["n|gr"] = map_cr("lua require'telescope.builtin.lsp'.references()"):with_noremap():with_silent(),
      ["n|gi"] = map_cr("lua vim.lsp.buf.implementation()"):with_noremap():with_silent(),
      ["n|gs"] = map_cr("lua require('lspsaga.signaturehelp').signature_help()"):with_noremap():with_silent(),
      ["n|gR"] = map_cr("lua require('lspsaga.rename').rename()"):with_noremap():with_silent(),
      ["n|gh"] = map_cr("lua require'lspsaga.provider'.lsp_finder()"):with_noremap():with_silent(),
      ["n|gt"] = map_cr("lua vim.lsp.buf.type_definition()"):with_noremap():with_silent(),
      ["n|gS"] = map_cr("lua vim.lsp.buf.workspace_symbol()"):with_noremap():with_silent(),
      ["n|gl"] = map_cr("lua require'lspsaga.diagnostic'.show_line_diagnostics()"):with_noremap():with_silent(),
      ["n|gw"] = map_cr("lua require'lspsaga.diagnostic'.show_cursor_diagnostics()"):with_noremap():with_silent(),
      ["n|g]"] = map_cr(
            "lua vim.lsp.diagnostic.goto_next { popup_opts = { show_header = false, border = require 'custom.lsp.config' .borders } }"
         )
         :with_noremap()
         :with_silent(),
      ["n|g["] = map_cr(
            "lua vim.lsp.diagnostic.goto_prev { popup_opts = { show_header = false, border = require 'custom.lsp.config' .borders } }"
         )
         :with_noremap()
         :with_silent(),
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
         "lua vim.lsp.diagnostic.show_line_diagnostics { show_header = false, border = require 'custom.lsp.config' .borders }"
      )
         :with_noremap()
         :with_silent(),
      ["n|<Leader>gr"] = map_cr("lua require'telescope'.lsp_references()"):with_noremap():with_silent(),
      ["n|<Leader>gR"] = map_cr("lua vim.lsp.buf.rename()"):with_noremap():with_silent(),
      ["n|<Leader>g]"] = map_cr(
         "lua vim.lsp.diagnostic.goto_next { popup_opts = { show_header = false, border = require 'custom.lsp.config' .borders } }"
      )
         :with_noremap()
         :with_silent(),
      ["n|<Leader>g["] = map_cr(
         "lua vim.lsp.diagnostic.goto_prev { popup_opts = { show_header = false, border = require 'custom.lsp.config' .borders } }"
      )
         :with_noremap()
         :with_silent(), ]]
   }

   bind.nvim_load_mapping(mappings, true, bufnr)
end

return M
