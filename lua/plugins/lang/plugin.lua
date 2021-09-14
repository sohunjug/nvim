local lang = {}
local conf = require "plugins.lang.config"

lang["nvim-treesitter/nvim-treesitter"] = {
   opt = true,
   event = { "BufRead", "SourceCmd" },
   after = "telescope.nvim",
   run = ":TSUpdate",
   config = conf.nvim_treesitter,
   requires = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "p00f/nvim-ts-rainbow" },
      { "JoosepAlviste/nvim-ts-context-commentstring" },
   },
}

lang["SmiteshP/nvim-gps"] = {
   opt = true,
   after = "nvim-treesitter",
   config = conf.nvim_gps,
}

return lang
