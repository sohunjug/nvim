local completion = {}
local conf = require "plugins.completion.config"
completion["kabouzeid/nvim-lspinstall"] = {
   opt = true,
   cmd = "LspInstall",
   setup = function()
      require("core.utils").packer_lazy_load "nvim-lspinstall"
      -- reload the current file so lsp actually starts for it
      vim.defer_fn(function()
         vim.cmd "silent! e %"
      end, 0)
   end,
}
completion["alexaandru/nvim-lspupdate"] = {
   opt = true,
   cmd = "LspUpdate",
   after = "nvim-lspconfig",
}

completion["jose-elias-alvarez/null-ls.nvim"] = {
   config = conf.nullls,
}

completion["neovim/nvim-lspconfig"] = {
   event = "BufReadPre",
   after = "null-ls.nvim",
   config = conf.nvim_lsp,
   requires = {
      {
         "jose-elias-alvarez/nvim-lsp-ts-utils",
         ft = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
         },
      },
   },
}

--[[completion["onsails/vimway-lsp-diag.nvim"] = {
   opt = true,
   event = "BufReadPre",
   after = "nvim-lspconfig",
   config = conf.lsp_diag,
}]]

completion["onsails/lspkind-nvim"] = {
   opt = true,
   event = "BufReadPre",
   after = "nvim-lspconfig",
   config = conf.lspkind,
}

completion["glepnir/lspsaga.nvim"] = {
   opt = true,
   cmd = "Lspsaga",
   event = { "VimEnter", "BufReadPost" },
   after = "nvim-lspconfig",
   config = conf.saga,
}

completion["hrsh7th/nvim-compe"] = { opt = true, event = { "VimEnter", "BufReadPre" }, config = conf.nvim_compe }

completion["hrsh7th/vim-vsnip"] = { opt = true, event = "InsertCharPre", config = conf.vim_vsnip }

completion["ray-x/lsp_signature.nvim"] = { opt = true, after = "nvim-lspconfig" }

--[[completion["hrsh7th/nvim-cmp"] = {
   config = conf.cmp,
   event = "InsertEnter",
   requires = {
      { "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
      { "hrsh7th/cmp-buffer", after = "cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp", after = "cmp-buffer" },
      { "hrsh7th/cmp-nvim-lua", after = "cmp-nvim-lsp" },
      { "andersevenrud/compe-tmux", branch = "cmp", after = "cmp-nvim-lua" },
      { "hrsh7th/cmp-path", after = "compe-tmux" },
      { "f3fora/cmp-spell", after = "cmp-path" },
      -- {
      --     'tzachar/cmp-tabnine',
      --     run = './install.sh',
      --     after = 'cmp-spell',
      --     config = conf.tabnine
      -- }
   },
}]]

completion["nvim-telescope/telescope.nvim"] = {
   opt = true,
   cmd = "Telescope",
   config = conf.telescope,
   requires = {
      { "nvim-lua/popup.nvim", opt = true },
      { "nvim-lua/plenary.nvim", opt = true },
      { "jremmen/vim-ripgrep", opt = true },
      { "nvim-telescope/telescope-fzy-native.nvim", opt = true },
      { "nvim-telescope/telescope-project.nvim", opt = true },
      {
         "nvim-telescope/telescope-frecency.nvim",
         opt = true,
         requires = { { "tami5/sqlite.lua", opt = true } },
      },
   },
}

completion["TimUntersberger/neogit"] = {
   opt = true,
   cmd = "Neogit",
   after = "plenary.nvim",
   config = function()
      if not packer_plugins["plenary.nvim"].loaded then
         vim.cmd [[packadd plenary.nvim]]
      end
      require("neogit").setup { integrations = { diffview = true } }
   end,
}
completion["AckslD/nvim-neoclip.lua"] = {
   config = function()
      require("neoclip").setup()
   end,
}

--[[completion["ray-x/navigator.lua"] = {
   config = conf.navigator,
   requires = { { "ray-x/guihua.lua", run = "cd lua/fzy && make" } },
}]]

-- completion["glepnir/smartinput.nvim"] = { ft = "go", config = conf.smart_input }

completion["mattn/vim-sonictemplate"] = {
   opt = true,
   cmd = "Template",
   ft = { "go", "typescript", "lua", "javascript", "vim", "rust", "markdown" },
   config = conf.vim_sonictemplate,
}

completion["mattn/emmet-vim"] = {
   opt = true,
   event = "InsertEnter",
   ft = { "html", "css", "javascript", "javascriptreact", "vue", "typescript", "typescriptreact" },
   config = conf.emmet,
}

--[[completion["ray-x/go.nvim"] = {
   config = conf.go_nvim,
   requires = {
      { "mfussenegger/nvim-dap", opt = true },
      { "rcarriga/nvim-dap-ui", opt = true },
      { "theHamsta/nvim-dap-virtual-text", opt = true },
   },
}]]

return completion
