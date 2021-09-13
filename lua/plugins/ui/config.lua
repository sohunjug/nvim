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

function config.neoscroll()
   require("neoscroll").setup {
      -- All these keys will be mapped to their corresponding default scrolling animation
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
      hide_cursor = true, -- Hide cursor while scrolling
      stop_eof = true, -- Stop at <EOF> when scrolling downwards
      use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
      respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
      easing_function = nil, -- Default easing function
      pre_hook = function(info)
         if info == "cursorline" then
            vim.wo.cursorline = false
         end
      end,
      post_hook = function(info)
         if info == "cursorline" then
            vim.wo.cursorline = true
         end
      end,
      -- pre_hook = nil, -- Function to run before the scrolling animation starts
      -- post_hook = nil, -- Function to run after the scrolling animation ends
   }

   local t = {}
   t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "100", "sine", [['cursorline']] } }
   t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "100", "sine", [['cursorline']] } }
   -- Use the "circular" easing function
   t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "120", [['circular']] } }
   t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "120", [['circular']] } }
   -- Pass "nil" to disable the easing animation (constant scrolling speed)
   t["<C-y>"] = { "scroll", { "-0.10", "true", "100", [['cursorlar']] } }
   t["<C-e>"] = { "scroll", { "0.10", "false", "100", [['cursorlar']] } }
   -- When no easing function is provided the default easing function (in this case "quadratic") will be used
   t["zt"] = { "zt", { "140" } }
   t["zz"] = { "zz", { "140" } }
   t["zb"] = { "zb", { "140" } }
   require("neoscroll.config").set_mappings(t)
end

function config.indent()
   require("indent_guides").setup {
      exclude_filetyps = {
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
      },
   }
end

function config.indent_blankline()
   --  vim.g.indent_blankline_char = "│"
   --  vim.g.indent_blankline_show_first_indent_level = false
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
   --  vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
   vim.g.indent_blankline_show_trailing_blankline_indent = false
   vim.g.indent_blankline_show_current_context = true
   --[[vim.g.indent_blankline_context_patterns = {
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
   }]]
   -- because lazy load indent-blankline so need readd this autocmd
   --  vim.cmd "autocmd CursorMoved * IndentBlanklineRefresh"
   vim.opt.listchars = {
      eol = "↴",
   }
   --  require("indent_blankline").setup {
   --  space_char_blankline = " ",
   --  show_current_context = true,
   --  show_trailing_blankline_indent = false,
   --  }
end

return config
