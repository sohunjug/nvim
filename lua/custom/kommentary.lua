local M = {
   opt = true,
   event = "BufReadPost",
}

M.config = function()
   require("kommentary.config").configure_language("rust", {
      single_line_comment_string = "//",
      multi_line_comment_strings = { "/*", "*/" },
   })
end

return M
