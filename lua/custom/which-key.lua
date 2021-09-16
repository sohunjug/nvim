local M = {
   opt = true,
   event = "VimEnter",
   config = function()
      require("which-key").setup()
   end,
}

return M
