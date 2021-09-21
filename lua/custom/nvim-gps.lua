local M = {
   opt = true,
   after = "nvim-treesitter",
}

M.config = function()
   if not packer_plugins["nvim-web-devicons"] or not packer_plugins["nvim-web-devicons"].loaded then
      vim.cmd [[packadd nvim-web-devicons]]
   end
   require("nvim-gps").setup {
      icons = {
         ["class-name"] = " ", -- Classes and class-like objects
         ["function-name"] = " ", -- Functions
         ["method-name"] = " ", -- Methods (functions inside class-like objects)
         ["container-name"] = " ",
      },
      languages = { -- You can disable any language individually here
         ["c"] = true,
         ["cpp"] = true,
         ["go"] = true,
         ["java"] = true,
         ["javascript"] = true,
         ["typescript"] = true,
         ["lua"] = true,
         ["python"] = true,
         ["rust"] = true,
      },
      separator = " > ",
   }
end

return M
