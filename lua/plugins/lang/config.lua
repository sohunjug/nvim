local config = {}

function config.nvim_treesitter()
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
      },
      context_commentstring = {
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
      highlight = { enable = true, additional_vim_regex_highlighting = false },
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

function config.nvim_gps()
   require("nvim-gps").setup {
      icons = {
         ["class-name"] = " ", -- Classes and class-like objects
         ["function-name"] = " ", -- Functions
         ["method-name"] = " ", -- Methods (functions inside class-like objects)
      },
      languages = { -- You can disable any language individually here
         ["c"] = true,
         ["cpp"] = true,
         ["go"] = true,
         ["java"] = true,
         ["javascript"] = true,
         ["typescript"] = true,
         ["lua"] = true,
         ["python"] = true,
         ["rust"] = true,
      },
      separator = " > ",
   }
end
return config
