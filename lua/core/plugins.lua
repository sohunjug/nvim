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

--[[ use("famiu/nvim-reload", {
   opt = true,
   cmd = { "Restart", "Reload" },
   config = function()
      local reload = require "nvim-reload"
      reload.post_reload_hook = function()
         require("colors").init(vim.g.custom_theme)
         -- require("feline").reset_highlights()
      end
   end,
}) ]]

use("famiu/bufdelete.nvim", { opt = true, cmd = { "Bdelete", "Bwipeout" } })

use "github/copilot.vim"

use("alexaandru/nvim-lspupdate", {
   opt = true,
   cmd = "LspUpdate",
   after = "nvim-lspconfig",
})

use "neovim/nvim-lspconfig"

use("onsails/lspkind-nvim", {
   opt = true,
   event = "BufReadPost",
   after = "nvim-lspconfig",
})

use("mg979/vim-visual-multi", { opt = true, event = "InsertEnter" })

--[[ use("glepnir/lspsaga.nvim", {
   opt = true,
   cmd = "Lspsaga",
   after = "nvim-lspconfig",
   config = function()
      require("lspsaga").init_lsp_saga {
         -- code_action_icon = "💡",
         code_action_icon = "",
      }
   end,
}) ]]

use("ray-x/lsp_signature.nvim", {
   opt = true,
   event = "BufRead",
   after = "nvim-lspconfig",
   config = function()
      require("lsp_signature").setup {
         bind = true, -- This is mandatory, otherwise border config won't get registered.
         floating_window_above_cur_line = true,
         transparency = 50,
         handler_opts = {
            border = "single",
         },
         toggle_key = "<C-x>",
      }
   end,
})

use "RishabhRD/nvim-lsputils"

-- use "ray-x/navigator.lua"

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

-- use "L3MON4D3/LuaSnip"

use "kyazdani42/nvim-web-devicons"

-- use "glepnir/dashboard-nvim"

use("goolord/alpha-nvim", {
   opt = false,
   config = function()
      require("alpha").setup(require("alpha.themes.startify").config)
   end,
})

use "ur4ltz/surround.nvim"

use "lukas-reineke/indent-blankline.nvim"

-- use "Yggdroot/indentLine"

--[[ use("glepnir/indent-guides.nvim", {
   opt = true,
   event = "BufReadPost",
   exclude_filetypes = { "help", "dashboard", "dashpreview", "NvimTree", "vista", "sagahover" },
}) ]]

use "akinsho/bufferline.nvim"

use "kyazdani42/nvim-tree.lua"

use("yamatsum/nvim-nonicons", {
   opt = true,
   event = "VimEnter",
   module = "nvim-web-devicons",
   requires = { "kyazdani42/nvim-web-devicons" },
})

use "lewis6991/gitsigns.nvim"

use("kdheepak/lazygit.nvim", {
   opt = true,
   cmd = { "LazyGit", "LazyGitConfig" },
   setup = function()
      vim.g.lazygit_floating_window_winblend = 0 --" transparency of floating window
      vim.g.lazygit_floating_window_scaling_factor = 0.9 --" scaling factor for floating window
      vim.g.lazygit_floating_window_corner_chars = { "╭", "╮", "╰", "╯" } --" customize lazygit popup window corner characters
      vim.g.lazygit_floating_window_use_plenary = 0 --" use plenary.nvim to manage floating window if available
      vim.g.lazygit_use_neovim_remote = 0 --" fallback to 0 if neovim-remote is not installed
   end,
})

use "folke/which-key.nvim"

-- use "famiu/feline.nvim"

use "nvim-lualine/lualine.nvim"

--[[ use("NvChad/nvim-base16.lua", {
   event = "VimEnter",
   config = require("colors").init,
}) ]]

use("nacro90/numb.nvim", {
   opt = true,
   event = "CmdlineEnter",
   config = function()
      require("numb").setup { show_numbers = true, show_currorline = true, number_only = false }
   end,
})

--[[ use("ellisonleao/gruvbox.nvim", {
   requires = { "rktjmp/lush.nvim" },
   config = function()
      -- require("gruvbox").setup()
      vim.o.background = "dark" -- or "light" for light mode
      vim.cmd "colorscheme gruvbox"
   end,
}) ]]

--[[ use("rose-pine/neovim", {
   as = "rose-pine",
   config = function()
      -- Options (see available options below)
      vim.g.rose_pine_variant = "base"

      -- Load colorscheme after options
      vim.cmd "colorscheme rose-pine"
   end,
}) ]]

use("sainnhe/sonokai", {
   as = "sonokai",
   config = function()
      vim.g.sonokai_style = "shusia"
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_disable_italic_comment = 1
      vim.g.sonokai_diagnostic_text_highlight = 1
      vim.g.sonokai_diagnostic_line_highlight = 1
      vim.g.sonokai_current_word = "bold"
      vim.cmd "colorscheme sonokai"
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
      vim.g.glow_binary_path = S_NVIM.home .. ".local/bin"
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

use("tversteeg/registers.nvim", {
   opt = true,
   cmd = "Registers",
   event = "InsertEnter",
   setup = function()
      vim.g.registers_window_border = "rounded"
   end,
})

use "ahmedkhalf/project.nvim"

use "Pocco81/TrueZen.nvim"

use "gelguy/wilder.nvim"

use "folke/trouble.nvim"

use "rcarriga/nvim-notify"

use("jdhao/better-escape.vim", { opt = true, event = "InsertEnter" })

use("PHSix/faster.nvim", { event = "VimEnter" })

use "norcalli/nvim-colorizer.lua"

--[[ use("editorconfig/editorconfig-vim", {
   opt = true,
   ft = { "go", "typescript", "javascript", "vim", "rust", "c", "cpp", "lua", "vue", "rust" },
}) ]]

use("yamatsum/nvim-cursorline", {
   opt = true,
   event = { "BufReadPre", "BufNewFile" },
})

use "kevinhwang91/nvim-hlslens"

use "simrat39/symbols-outline.nvim"

use "b3nj5m1n/kommentary"

-- use "edluffy/specs.nvim"

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

use("lukas-reineke/headlines.nvim", {
   opt = true,
   ft = {
      "vimwiki",
      "markdown",
   },
   config = function()
      require("headlines").setup()
   end,
})

return M
