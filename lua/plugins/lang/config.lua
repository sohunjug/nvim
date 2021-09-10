local config = {}
local global = require "core.global"

config.compiler = "gcc"

if global.is_mac then
   config.compiler = "/opt/homebrew/bin/gcc-11"
end

function config.nvim_treesitter()
   vim.api.nvim_command "set foldmethod=expr"
   vim.api.nvim_command "set foldexpr=nvim_treesitter#foldexpr()"
   require("nvim-treesitter.install").compilers = { config.compilers }
   require("nvim-treesitter.configs").setup {
      -- ensure_installed = "maintained",
      ensure_installed = {
         "go",
         "c",
         "cpp",
         "javascript",
         "typescript",
         "bash",
         "rust",
         "python",
         "lua",
         "vue",
         "toml",
         "vim",
         "nix",
         "html",
         "json",
         "json5",
         "dockerfile",
         "cmake",
         "gomod",
         "graphql",
         "dot",
      },
      highlight = { enable = true },
      textobjects = {
         select = {
            enable = true,
            keymaps = {
               ["af"] = "@function.outer",
               ["if"] = "@function.inner",
               ["ac"] = "@class.outer",
               ["ic"] = "@class.inner",
            },
         },
      },
   }
end

return config
