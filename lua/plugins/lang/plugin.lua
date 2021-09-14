local lang = {}
local conf = require "plugins.lang.config"

lang["nvim-treesitter/nvim-treesitter"] = {
   opt = true,
   event = { "BufReadPre", "BufWritePost", "SourceCmd" },
   after = "telescope.nvim",
   config = conf.nvim_treesitter,
}

lang["nvim-treesitter/nvim-treesitter-textobjects"] = {
   opt = true,
   after = "nvim-treesitter",
}

lang["JoosepAlviste/nvim-ts-context-commentstring"] = {
   opt = true,
   after = "nvim-treesitter",
}

lang["SmiteshP/nvim-gps"] = {
   opt = true,
   after = "nvim-treesitter",
   config = conf.nvim_gps,
}

return lang
