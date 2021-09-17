local M = {
   opt = true,
   -- event = "VimEnter",
   after = "nvim-base16.lua",
}

M.config = function()
   require("notify").setup {
      stages = "fade_in_slide_out",
      background_color = "NotifyBG",
   }
   vim.notify = require "notify"
end

return M
