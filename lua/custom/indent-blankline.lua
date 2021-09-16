local M = { opt = true, event = "BufRead" }

M.config = function()
   -- because lazy load indent-blankline so need readd this autocmd
   vim.opt.listchars = {
      space = "⋅",
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
      buftype_exclude = { "terminal", "nofile" },
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
      space_char_blankline = " ",
      -- space_char = "·",
      space_char = " ",
      show_first_indent_level = false,
      show_current_context = true,
      show_trailing_blankline_indent = false,
   }
   vim.cmd "autocmd CursorMoved * IndentBlanklineRefresh"
end

return M
