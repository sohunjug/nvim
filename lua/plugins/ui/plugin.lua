local ui = {}
local conf = require "plugins.ui.config"

ui["kyazdani42/nvim-web-devicons"] = {
   after = "nvim-base16.lua",
   config = function()
      require "custom.icons"
   end,
}
-- ui["glepnir/zephyr-nvim"] = {config = [[vim.cmd('colorscheme zephyr')]]}

ui["glepnir/dashboard-nvim"] = { config = conf.dashboard }

-- ui["glepnir/galaxyline.nvim"] = {branch = "main", config = conf.galaxyline, requires = "kyazdani42/nvim-web-devicons"}

ui["lukas-reineke/indent-blankline.nvim"] = { opt = true, event = "BufRead", config = conf.indent_blankline }

--[[ui["glepnir/indent-guides.nvim"] = {
   opt = true,
   event = "BufRead",
   config = conf.indent,
}]]

ui["akinsho/nvim-bufferline.lua"] = {
   opt = true,
   event = "BufRead",
   config = conf.nvim_bufferline,
   requires = "kyazdani42/nvim-web-devicons",
}

ui["kyazdani42/nvim-tree.lua"] = {
   opt = true,
   cmd = { "NvimTreeFindFile", "NvimTreeToggle", "NvimTreeOpen" },
   config = conf.nvim_tree,
   requires = "kyazdani42/nvim-web-devicons",
}

ui["yamatsum/nvim-nonicons"] = {
   opt = true,
   event = "BufRead",
   after = "nvim-web-devicons",
   requires = { "kyazdani42/nvim-web-devicons" },
}

ui["lewis6991/gitsigns.nvim"] = {
   opt = true,
   event = { "BufRead", "BufNewFile" },
   config = conf.gitsigns,
   requires = { "nvim-lua/plenary.nvim", opt = true },
}

ui["folke/which-key.nvim"] = {
   opt = true,
   event = "VimEnter",
   config = function()
      require("which-key").setup()
   end,
}

ui["famiu/feline.nvim"] = {
   requires = { "kyazdani42/nvim-web-devicons", "SmiteshP/nvim-gps" },
   after = "nvim-gps",
   config = function()
      require "custom.statusline"
   end,
}

ui["NvChad/nvim-base16.lua"] = {
   config = function()
      require("colors").init()
   end,
}

--[[ui["karb94/neoscroll.nvim"] = {
   opt = true,
   event = "BufReadPre",
   config = conf.neoscroll,
}]]
ui["nacro90/numb.nvim"] = {
   opt = true,
   event = "BufReadPost",
   config = function()
      require("numb").setup { show_numbers = true, show_currorline = true, number_only = false }
   end,
}

return ui
