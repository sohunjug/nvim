local M = {}

local function use(name, opts)
   local custom = ""
   local opt = opts or {}
   if opts == nil then
      local tmp = vim.split(name, "/", true)
      if tmp[2] ~= nil then
         custom = vim.split(tmp[2], ".", true)[1]
         if custom == nil then
            custom = tmp[2]
         end
         local ok, opttmp = pcall(require, "custom." .. custom)
         -- print(custom, vim.inspect(opttmp))
         if not ok then
            opt = {}
         else
            opt = opttmp
         end
      end
   end
   M[name] = opt
end

use "kabouzeid/nvim-lspinstall"

use("alexaandru/nvim-lspupdate", {
   opt = true,
   cmd = "LspUpdate",
   after = "nvim-lspconfig",
})

use "neovim/nvim-lspconfig"

use("onsails/lspkind-nvim", {
   opt = true,
   after = "nvim-lspconfig",
})

use("mg979/vim-visual-multi", { opt = true, event = "InsertEnter" })

use("glepnir/lspsaga.nvim", {
   opt = true,
   cmd = "Lspsaga",
   after = "nvim-lspconfig",
   config = function()
      require("lspsaga").init_lsp_saga {
         -- code_action_icon = "💡",
      }
   end,
})

use("ray-x/lsp_signature.nvim", {
   opt = true,
   event = "BufRead",
   after = "nvim-lspconfig",
   config = function()
      require("lsp_signature").setup {
         bind = true, -- This is mandatory, otherwise border config won't get registered.
         handler_opts = {
            border = "single",
         },
      }
   end,
})

use "hrsh7th/nvim-cmp"

use "nvim-telescope/telescope.nvim"

use("AckslD/nvim-neoclip.lua", {
   opt = true,
   config = function()
      require("neoclip").setup()
   end,
})

use("mattn/vim-sonictemplate", {
   opt = true,
   cmd = "Template",
   ft = { "go", "typescript", "lua", "javascript", "vim", "rust", "markdown" },
})

use "L3MON4D3/LuaSnip"

use "kyazdani42/nvim-web-devicons"

use "glepnir/dashboard-nvim"

use "lukas-reineke/indent-blankline.nvim"

use "akinsho/nvim-bufferline.lua"

use "kyazdani42/nvim-tree.lua"

use("yamatsum/nvim-nonicons", {
   opt = true,
   event = "BufRead",
   after = "nvim-web-devicons",
   requires = { "kyazdani42/nvim-web-devicons" },
})

use "lewis6991/gitsigns.nvim"

use "folke/which-key.nvim"

use "famiu/feline.nvim"

use("NvChad/nvim-base16.lua", {
   config = function()
      require("colors").init()
   end,
})

use("nacro90/numb.nvim", {
   opt = true,
   event = "CmdlineEnter",
   config = function()
      require("numb").setup { show_numbers = true, show_currorline = true, number_only = false }
   end,
})

use "nvim-treesitter/nvim-treesitter"

use "SmiteshP/nvim-gps"

use("glepnir/prodoc.nvim", { opt = true, event = "BufReadPre" })

use("ellisonleao/glow.nvim", {
   opt = true,
   run = ":GlowInstall",
   ft = "markdown",
   cmd = "Glow",
   config = function()
      vim.g.glow_binary_path = require("core.global").home .. ".local/bin"
   end,
})

use("andymass/vim-matchup", {
   opt = true,
   after = "nvim-treesitter",
   setup = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
   end,
})

use("sindrets/diffview.nvim", {
   opt = true,
   cmd = { "DiffviewOpen", "DiffviewToggleFiles", "DiffviewRefresh" },
   module = "neogit",
   after = "neogit",
   config = function()
      require("diffview").setup()
   end,
})

use "TimUntersberger/neogit"

use "ahmedkhalf/project.nvim"

use "Pocco81/TrueZen.nvim"

use "gelguy/wilder.nvim"

use "folke/trouble.nvim"

use "rcarriga/nvim-notify"

use("jdhao/better-escape.vim", { opt = true, event = "InsertEnter" })

use "norcalli/nvim-colorizer.lua"

use("editorconfig/editorconfig-vim", {
   opt = true,
   ft = { "go", "typescript", "javascript", "vim", "rust", "c", "cpp", "lua", "vue", "rust" },
})

use("yamatsum/nvim-cursorline", {
   opt = true,
   event = { "BufReadPre", "BufNewFile" },
})

use "kevinhwang91/nvim-hlslens"

use "simrat39/symbols-outline.nvim"

use "b3nj5m1n/kommentary"

use "edluffy/specs.nvim"

use "ggandor/lightspeed.nvim"

use("kana/vim-niceblock", { opt = true, event = "VimEnter" })

use "windwp/nvim-autopairs"

use("brooth/far.vim", {
   opt = true,
   cmd = { "F", "Far", "Farr" },
   setup = function()
      vim.g["far#enable_undo"] = 1
      vim.g["far#source"] = "rg"
   end,
})

return M
