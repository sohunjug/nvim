local ui = {}
local conf = require('plugins.ui.config')

ui["kyazdani42/nvim-web-devicons"] = {
      after = "nvim-base16.lua",
      config = function()
        require "custom.icons"
      end,
   }
ui['glepnir/zephyr-nvim'] = {
  config = [[vim.cmd('colorscheme zephyr')]]
}

ui['glepnir/dashboard-nvim'] = {
  config = conf.dashboard
}

ui['glepnir/galaxyline.nvim'] = {
  branch = 'main',
  config = conf.galaxyline,
  requires = 'kyazdani42/nvim-web-devicons'
}

ui['lukas-reineke/indent-blankline.nvim'] = {
  event = 'BufRead',
  config = conf.indent_blakline
}


ui['akinsho/nvim-bufferline.lua'] = {
  config = conf.nvim_bufferline,
  requires = 'kyazdani42/nvim-web-devicons'
}

ui['kyazdani42/nvim-tree.lua'] = {
  cmd = {'NvimTreeToggle','NvimTreeOpen'},
  config = conf.nvim_tree,
  requires = 'kyazdani42/nvim-web-devicons'
}

ui['lewis6991/gitsigns.nvim'] = {
  event = {'BufRead','BufNewFile'},
  config = conf.gitsigns,
  requires = {'nvim-lua/plenary.nvim',opt=true}
}

ui["folke/which-key.nvim"] = {
      config = function()
        require("which-key").setup()
      end,
   }
   ui["famiu/feline.nvim"] = {
      after = "nvim-web-devicons",
      config = function()
         require "custom.statusline"
      end,
   }
ui["NvChad/nvim-base16.lua"] = {
      config = function()
         require("colors").init()
      end,
   }




return ui
