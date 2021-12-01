local M = {
   opt = true,
   event = "VimEnter",
}

M.config = function()
   require("notify").setup {
      stages = "fade_in_slide_out",
      background_color = "NotifyBG",
   }
   vim.notify = require "notify"
end

return M
