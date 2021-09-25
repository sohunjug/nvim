local M = {
   opt = true,
   event = { "BufRead", "SourceCmd" },
   after = "telescope.nvim",
   run = ":TSUpdate",
   requires = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "p00f/nvim-ts-rainbow" },
      { "JoosepAlviste/nvim-ts-context-commentstring" },
   },
}

M.config = function()
   vim.api.nvim_command "set foldmethod=expr"
   vim.api.nvim_command "set foldexpr=nvim_treesitter#foldexpr()"
   if vim.loop.os_uname().sysname == "Darwin" then
      local compile = "/usr/local/bin/gcc-11"
      if vim.loop.os_uname().machine == "arm64" then
         compile = "/opt/homebrew/bin/gcc-11"
      end
      require("nvim-treesitter.install").compilers = { compile }
   end
   require("nvim-treesitter.configs").setup {
      -- ensure_installed = "maintained",
      indent = {
         enable = true,
      },
      rainbow = {
         enable = true,
         extended_mode = true,
      },
      context_commentstring = {
         enable = true,
      },
      matchup = {
         enable = true,
      },
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
      highlight = { enable = true, additional_vim_regex_highlighting = true },
      textobjects = {
         move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
               ["]m"] = "@function.outer",
               ["]]"] = "@class.outer",
            },
            goto_next_end = {
               ["]M"] = "@function.outer",
               ["]["] = "@class.outer",
            },
            goto_previous_start = {
               ["[m"] = "@function.outer",
               ["[["] = "@class.outer",
            },
            goto_previous_end = {
               ["[M"] = "@function.outer",
               ["[]"] = "@class.outer",
            },
         },
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

   -- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
   -- parser_config.kkf2 = {
   -- filetype = "lua", -- if filetype does not agrees with parser name
   -- used_by = { "bar", "baz" }, -- additional filetypes that use this parser
   -- }
end

return M
