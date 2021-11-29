local lsp = vim.lsp
local M = {}

function M.nvim_create_augroup(group_name, definitions)
   vim.api.nvim_command("augroup " .. group_name)
   vim.api.nvim_command "autocmd!"
   for _, def in ipairs(definitions) do
      local command = table.concat(vim.tbl_flatten { "autocmd", def }, " ")
      vim.api.nvim_command(command)
   end
   vim.api.nvim_command "augroup END"
end

function M.lsp_before_save()
   local defs = {}
   local ext = vim.fn.expand "%:e"
   if ext == "go" then
      -- table.insert(defs, { "BufWritePre", "*.go", "lua require('custom.lsp.format').go_organize_imports_sync(1000)" })
      table.insert(defs, { "BufWritePre", "*.go", "lua require('custom.lsp.format').go_imports_sync(1000)" })
   else
      table.insert(defs, { "BufWritePre", "*." .. ext, "lua vim.lsp.buf.formatting_sync(nil,1000)" })
   end
   table.insert(defs, { "BufWritePre", "<buffer>", "retab" })
   -- table.insert(defs, { "BufWritePre", "<buffer>", "lua vim.lsp.buf.formatting_sync()" })
   M.nvim_create_augroup("lsp_before_save", defs)
end

function M.go_imports_sync(timeout_ms)
   local context = { source = { organizeImports = true } }
   vim.validate { context = { context, "t", true } }

   local params = vim.lsp.util.make_range_params()
   params.context = context

   local method = "textDocument/codeAction"
   local resp = vim.lsp.buf_request_sync(0, method, params, timeout_ms)

   -- imports is indexed with clientid so we cannot rely on index always is 1
   for _, v in next, resp, nil do
      local result = v.result
      if result and result[1] then
         local edit = result[1].edit
         vim.lsp.util.apply_workspace_edit(edit)
      end
   end
   -- Always do formating
   vim.lsp.buf.formatting()
end
-- Synchronously organise (Go) imports. Taken from
-- https://github.com/neovim/nvim-lsp/issues/115#issuecomment-654427197.
function M.go_organize_imports_sync(timeout_ms)
   local context = { source = { organizeImports = true } }
   vim.validate { context = { context, "t", true } }
   local params = vim.lsp.util.make_range_params()
   params.context = context

   -- See the implementation of the textDocument/codeAction callback
   -- (lua/vim/lsp/handler.lua) for how to do this properly.
   local result = lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
   if not result or next(result) == nil or #result == 0 then
      return
   end
   local actions = result[1].result or nil
   if not actions then
      return
   end
   local action = actions[1]

   -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
   -- is a CodeAction, it can have either an edit, a command or both. Edits
   -- should be executed first.
   if action.edit or type(action.command) == "table" then
      if action.edit then
         vim.lsp.util.apply_workspace_edit(action.edit)
      end
      if type(action.command) == "table" then
         vim.lsp.buf.execute_command(action.command)
      end
   else
      vim.lsp.buf.execute_command(action)
   end
end

return M
