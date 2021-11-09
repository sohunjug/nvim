local M = {
   opt = true,
   event = "BufReadPost",
}

M.config = function()
   require("surround").setup {
      prefix = "-",
      mappings_style = "sandwich",
      map_insert_mode = true,
   }
end

return M
