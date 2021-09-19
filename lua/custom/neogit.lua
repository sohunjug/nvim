local M = {
   opt = true,
   cmd = "Neogit",
   after = { "plenary.nvim", opt = true },
}

M.config = function()
   if not packer_plugins["plenary.nvim"].loaded then
      vim.cmd [[packadd plenary.nvim]]
   end
   require("neogit").setup { integrations = { diffview = true, auto_refresh = true } }
end

return M
