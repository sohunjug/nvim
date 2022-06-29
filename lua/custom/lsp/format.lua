local lsp = vim.lsp
local M = {}

local wait_result_reason = { [-1] = "timeout", [-2] = "interrupted", [-3] = "error" }

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
   if vim.g.autoformat then
      local ext = vim.fn.expand "%:e"
      if ext == "go" then
         -- table.insert(defs, { "BufWritePre", "*.go", "lua require('custom.lsp.format').go_organize_imports_sync(1000)" })
         table.insert(defs, { "BufWritePre", "*.go", "lua require('custom.lsp.format').go_imports_sync(1000)" })
      else
         -- table.insert(defs, { "BufWritePre", "*." .. ext, "lua require('custom.lsp.format').formatting_chain_sync(nil,1000)" })
         if vim.version().minor == 8 then
            table.insert(defs, { "BufWritePre", "*." .. ext, "lua vim.lsp.buf.format { async=true }" })
         else
            table.insert(defs, { "BufWritePre", "*." .. ext, "lua vim.lsp.buf.formatting_sync()" })
         end
      end
      table.insert(defs, { "BufWritePre", "<buffer>", "retab" })
      -- table.insert(defs, { "BufWritePre", "<buffer>", "lua vim.lsp.buf.formatting_sync()" })
   end
   M.nvim_create_augroup("lsp_before_save", defs)
end

function M.go_imports_sync(timeout_ms)
   local context = { source = { organizeImports = true } }
   vim.validate { context = { context, "t", true } }

   local params = vim.lsp.util.make_range_params()
   params.context = context

   local method = "textDocument/codeAction"
   local resp = vim.lsp.buf_request_sync(0, method, params, timeout_ms)

   if not resp then
      return
   end
   -- imports is indexed with clientid so we cannot rely on index always is 1
   local idx = next(resp)
   local result = resp[idx].result
   if not result then
      return
   end
   idx = next(result)
   local edit = result[idx].edit
   vim.lsp.util.apply_workspace_edit(edit, "utf-8")
   -- Always do formating
   if vim.version().minor == 8 then
      vim.lsp.buf.format { async = true }
   else
      vim.lsp.buf.formatting_sync()
   end
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
   if not result or #result == 0 then
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
         vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
      end
      if type(action.command) == "table" then
         vim.lsp.buf.execute_command(action.command)
      end
   else
      vim.lsp.buf.execute_command(action)
   end
end

local function client_request_sync(client, method, params, timeout_ms, bufnr)
   local request_result = nil
   local function _sync_handler(err, _, result)
      request_result = { error = err, result = result }
   end

   local success, request_id = client.request(method, params, _sync_handler, bufnr)
   if not success then
      return nil
   end

   local wait_result, reason = vim.wait(timeout_ms or 100, function()
      return request_result ~= nil
   end, 10)

   if not wait_result then
      client.cancel_request(request_id)
      return nil, wait_result_reason[reason]
   end
   return request_result
end

function M.formatting_chain_sync(options, timeout_ms, order)
   local clients = vim.tbl_values(vim.lsp.buf_get_clients())

   -- sort the clients according to `order`
   for _, client_name in ipairs(order or {}) do
      -- if the client exists, move to the end of the list
      for i, client in ipairs(clients) do
         if client.name == client_name then
            table.insert(clients, table.remove(clients, i))
            break
         end
      end
   end

   local function handle_request_result(result)
      if not result then
         return
      end
      if not result.result then
         return
      end
      vim.lsp.util.apply_text_edits(result.result, 1, "utf-8")
   end

   -- loop through the clients and make synchronous formatting requests
   for _, client in ipairs(clients) do
      if client.resolved_capabilities.document_formatting then
         local result = client_request_sync(
            client,
            "textDocument/formatting",
            vim.lsp.util.make_formatting_params(options),
            timeout_ms
         )
         handle_request_result(result)
      elseif client.resolved_capabilities.document_range_formatting then
         local last_line = vim.fn.line "$"
         local last_col = vim.fn.col { last_line, "$" }
         local params = vim.lsp.util.make_given_range_params({ 1, 0 }, {
            last_line,
            last_col,
         })
         params.options = vim.lsp.util.make_formatting_params(options).options
         local result = client_request_sync(client, "textDocument/rangeFormatting", params, timeout_ms)
         handle_request_result(result)
      end
   end
end

return M
