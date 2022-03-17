local M = {
   opt = true,
   event = "BufReadPost",
}

M.config = function()
   require("kommentary.config").configure_language("rust", {
      single_line_comment_string = "//",
      multi_line_comment_strings = { "/*", "*/" },
   })
   require("kommentary.config").configure_language("shell", {
      prefer_single_line_comments = true,
      single_line_comment_string = "#",
   })
   require("kommentary.config").configure_language("sh", {
      prefer_single_line_comments = true,
      single_line_comment_string = "#",
   })
   require("kommentary.config").configure_language("zsh", {
      prefer_single_line_comments = true,
      single_line_comment_string = "#",
   })
   require("kommentary.config").configure_language("python", {
      single_line_comment_string = "#",
      multi_line_comment_strings = { "'''", "'''" },
   })
end

return M
