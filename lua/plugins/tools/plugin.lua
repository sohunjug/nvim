local tools = {}
local conf = require "plugins.tools.config"

--[[tools["kristijanhusak/vim-dadbod-ui"] = {
   cmd = { "DBUIToggle", "DBUIAddConnection", "DBUI", "DBUIFindBuffer", "DBUIRenameBuffer" },
   config = conf.vim_dadbod_ui,
   requires = { { "tpope/vim-dadbod", opt = true } },
}]]

tools["editorconfig/editorconfig-vim"] = { ft = { "go", "typescript", "javascript", "vim", "rust", "zig", "c", "cpp" } }

tools["glepnir/prodoc.nvim"] = { event = "BufReadPre" }

--[[tools["brooth/far.vim"] = {
   cmd = { "Far", "Farp" },
   config = function()
      vim.g["far#source"] = "rg"
   end,
}]]

--[[tools["iamcco/markdown-preview.nvim"] = {
   ft = "markdown",
   config = function()
      vim.g.mkdp_auto_start = 0
   end,
}]]

tools["ellisonleao/glow.nvim"] = {
   opt = true,
   run = "vim.cmd [[GlowInstall]]",
   ft = "markdown",
   config = function()
      vim.g.glow_binary_path = require("core.global").home .. ".local/bin"
   end,
}

tools["andymass/vim-matchup"] = {
   opt = true,
   after = "nvim-treesitter",
   config = function()
      vim.cmd [[let g:matchup_matchparen_offscreen = {'method': 'popup'}]]
   end,
}
tools["jdhao/better-escape.vim"] = {
   event = "InsertEnter",
   config = require("custom.others").better_escape,
   setup = function()
      vim.g.better_escape_shortcut = "jk"
   end,
}

tools["terrortylor/nvim-comment"] = {
   opt = true,
   cmd = "CommentToggle",
   config = require("custom.others").comment,
}

tools["ygm2/rooter.nvim"] = {
   event = "BufReadPost",
   opt = true,
   config = conf.rooter,
}

tools["Pocco81/TrueZen.nvim"] = {
   cmd = {
      "TZAtaraxis",
      "TZMinimalist",
      "TZFocus",
   },
   config = conf.zenmode,
}

-- tools["dstein64/vim-startuptime"] = { opt = true, cmd = "StartupTime" }

tools["gelguy/wilder.nvim"] = {
   event = "CmdlineEnter",
   run = ":UpdateRemotePlugins",
   config = conf.wilder,
   requires = { { "romgrk/fzy-lua-native", after = "wilder.nvim" } },
}

tools["folke/trouble.nvim"] = {
   opt = true,
   cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
   config = conf.trouble,
}

tools["rcarriga/nvim-notify"] = {
   -- opt = true,
   -- event = "WinEnter",
   config = function()
      require("notify").setup {
         stages = "fade_in_slide_out",
      }
      vim.notify = require "notify"
   end,
}

return tools
