local M = {
   opt = true,
   event = "BufReadPost",
   after = "nvim-cmp",
   requires = "rafamadriz/friendly-snippets",
}

M.config = function()
   require("luasnip").config.set_config {
      history = false,
      updateevents = "TextChanged,TextChangedI",
   }
   -- require("luasnip.loaders.from_vscode").load()
end

return M
