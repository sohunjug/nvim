local editor = {}
local conf = require "plugins.editor.config"

editor["Raimondi/delimitMate"] = { opt = true, event = "InsertEnter", config = conf.delimimate }

editor["rhysd/accelerated-jk"] = { opt = true }

editor["norcalli/nvim-colorizer.lua"] = {
   opt = true,
   ft = { "html", "css", "sass", "vim", "typescript", "typescriptreact", "terminal" },
   config = conf.nvim_colorizer,
}

--editor["itchyny/vim-cursorword"] = { event = { "BufReadPre", "BufNewFile" }, config = conf.vim_cursorwod }
editor["yamatsum/nvim-cursorline"] = {
   opt = true,
   event = { "BufReadPre", "BufNewFile" },
   setup = conf.nvim_cursorline,
}

editor["hrsh7th/vim-eft"] = {
   opt = true,
   config = function()
      vim.g.eft_ignorecase = true
   end,
}

editor["simrat39/symbols-outline.nvim"] = {
   opt = true,
   cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
   config = conf.symbols,
}

editor["edluffy/specs.nvim"] = {
   opt = true,
   event = "InsertEnter",
   config = conf.specs,
}

--[[editor["kana/vim-operator-replace"] = {
   keys = { { "x", "p" } },
   config = function()
      vim.api.nvim_set_keymap("x", "p", "<Plug>(operator-replace)", { silent = true })
   end,
   requires = "kana/vim-operator-user",
}]]

--editor["rhysd/vim-operator-surround"] = { event = "BufRead", requires = "kana/vim-operator-user" }

editor["kana/vim-niceblock"] = { opt = true }

editor["kevinhwang91/nvim-bqf"] = { opt = true, config = conf.bqf }

editor["windwp/nvim-autopairs"] = {
   opt = true,
   event = "BufReadPost",
   config = conf.autopairs,
   after = "nvim-compe",
}

--[[editor["L3MON4D3/LuaSnip"] = {
   opt = true,
   after = "nvim-cmp",
   config = conf.luasnip,
   requires = "rafamadriz/friendly-snippets",
}]]

return editor
