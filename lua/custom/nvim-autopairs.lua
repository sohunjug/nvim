local M = {
   opt = true,
   event = "BufReadPost",
   after = "nvim-cmp",
}

M.config = function()
   require("nvim-autopairs").setup { fast_wrap = {}, disable_filetype = { "TelescopePrompt", "vim" } }
   -- if not packer_plugins["nvim-cmp"].loaded then
   -- vim.cmd [[packadd nvim-cmp]]
   -- end
end

return M
