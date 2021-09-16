local M = {}

M.core_modules = {
   "core.options",
   "core.packer",
   "core.events",
   "core.filetype",
   "keymap",
}

M.setup = function()
   SNVIM_Loading "core.global"

   for _, module in ipairs(M.core_modules) do
      SNVIM_Loading(module)
   end

   SNVIM_Loading "core.mapping"
end

return M
