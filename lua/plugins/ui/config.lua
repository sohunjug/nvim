local config = {}

function config.galaxyline()
   require "plugins.ui.eviline"
end

function config.nvim_bufferline()
   require("bufferline").setup {
      options = { modified_icon = "✥", buffer_close_icon = "", always_show_bufferline = false },
   }
end

function config.dashboard()
   require "custom.dashboard"
end

function config.nvim_tree()
   -- On Ready Event for Lazy Loading work
   require("nvim-tree.events").on_nvim_tree_ready(function()
      vim.cmd "NvimTreeRefresh"
   end)
   require "custom.nvimtree"
end

function config.gitsigns()
   if not packer_plugins["plenary.nvim"].loaded then
      vim.cmd [[packadd plenary.nvim]]
   end
   -- require("gitsigns").setup {require "custom.git"}
   require "custom.gitsigns"
end

function config.indent_blakline()
   vim.g.indent_blankline_char = "│"
   vim.g.indent_blankline_show_first_indent_level = true
   vim.g.indent_blankline_filetype_exclude = {
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
   }
   vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
   vim.g.indent_blankline_show_trailing_blankline_indent = false
   vim.g.indent_blankline_show_current_context = true
   vim.g.indent_blankline_context_patterns = {
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
   }
   -- because lazy load indent-blankline so need readd this autocmd
   vim.cmd "autocmd CursorMoved * IndentBlanklineRefresh"
end

return config
