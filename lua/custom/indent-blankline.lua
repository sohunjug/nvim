local M = {
   opt = true,
   after = "feline.nvim",
   ft = {
      "markdown",
      "javascript",
      "go",
      "c",
      "cpp",
      "shell",
      "vim",
      "dockerfile",
      "dot",
      "vue",
      "css",
      "nix",
      "python",
      "json",
      "yaml",
      "graphql",
      "rust",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "lua",
   },
}

M.config = function()
   -- because lazy load indent-blankline so need readd this autocmd
   vim.opt.listchars = {
      -- space = "⋅",
      eol = "↴",
   }
   require("indent_blankline").setup {
      filetype_exclude = {
         "startify",
         "dashboard",
         "dotooagenda",
         "log",
         "fugitive",
         "gitcommit",
         "packer",
         "vimwiki",
         "markdown",
         "json",
         "txt",
         "vista",
         "help",
         "todoist",
         "NvimTree",
         "peekaboo",
         "git",
         "TelescopePrompt",
         "undotree",
         "flutterToolsOutline",
         "", -- for all buffers without a file type
      },
      -- sdf
      buftype_exclude = { "terminal", "nofile", "" },
      context_patterns = {
         "class",
         "function",
         "method",
         "block",
         "list_literal",
         "selector",
         "^if",
         "^table",
         "if_statement",
         "while",
         "for",
      },
      char = "┊",
      char_highlight = "LineNr",
      space_char_blankline = " ",
      use_treesitter = true,
      -- space_char = "·",
      space_char = " ",
      strict_tabs = true,
      debug = true,
      show_first_indent_level = true,
      show_current_context = true,
      show_trailing_blankline_indent = true,
   }
   vim.cmd "autocmd CursorMoved * IndentBlanklineRefresh"
end

return M
