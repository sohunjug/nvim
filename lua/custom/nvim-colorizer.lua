local M = {
   opt = true,
   ft = {
      "html",
      "css",
      "sass",
      "vim",
      "typescript",
      "typescriptreact",
      "terminal",
      "lua",
      "scss",
      "javascript",
      "javascriptreact",
   },
}

M.config = function()
   require("colorizer").setup {
      css = { rgb_fn = true },
      scss = { rgb_fn = true },
      sass = { rgb_fn = true },
      stylus = { rgb_fn = true },
      vim = { names = true },
      tmux = { names = false },
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      html = { mode = "foreground" },
   }
end

return M
