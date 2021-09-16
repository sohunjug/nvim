local M = {}

local event = require "core.events"

M.filetype = {
   lua = {
      setlocal = true,
      expandtab = true,
      shiftwidth = 3,
      tabstop = 3,
   },
}

M.apply = function(filetype, opts)
   local command = ""
   for key, value in pairs(opts) do
      if value ~= false then
         if value == true then
            command = command .. " " .. key
         else
            command = command .. " " .. key .. "=" .. value
         end
      end
   end
   return {
      "FileType",
      filetype,
      command,
   }
end

M.setup = function()
   local command = {}
   for key, value in pairs(M.filetype) do
      table.insert(command, M.apply(key, value))
   end
   -- print(vim.inspect(command))
   event.nvim_create_augroups { custom_filetype = command }
   -- vim.cmd "autocmd FileType lua setlocal shiftwidth=3 tabstop=3 expandtab"
end

return M
