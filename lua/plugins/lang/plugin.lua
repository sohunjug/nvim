local lang = {}
local conf = require "plugins.lang.config"

lang["nvim-treesitter/nvim-treesitter"] = {
   event = "BufRead",
   after = "telescope.nvim",
   config = conf.nvim_treesitter,
}

lang["nvim-treesitter/nvim-treesitter-textobjects"] = {
   after = "nvim-treesitter",
}

lang["JoosepAlviste/nvim-ts-context-commentstring"] = {
   after = "nvim-treesitter",
}

lang["SmiteshP/nvim-gps"] = {
   after = "nvim-treesitter",
   config = conf.nvim_gps,
}

return lang
