vim.g.custom_user_config = os.getenv "NVIM_USER" or "sohunjug"

_G.SNVIM_Loading = function(module)
   local ok, m = pcall(require, module)
   if not ok then
      error("Error loading " .. module .. "\n\n" .. m)
   end
   local ok, err = pcall(m.setup)
   if not ok then
      error("Error setup " .. module .. "\n\n" .. err)
   end
end

SNVIM_Loading("core")