local M = {
   opt = true,
   event = "BufReadPost",
   after = "nvim-cmp",
}

M.config = function()
   require("nvim-autopairs").setup { fast_wrap = {}, disable_filetype = { "TelescopePrompt" } }
   if not packer_plugins["nvim-cmp"].loaded then
      vim.cmd [[packadd nvim-cmp]]
   end
   require("nvim-autopairs.completion.cmp").setup {
      map_cr = true,
      map_complete = true,
      auto_select = true,
   }
end

return M

