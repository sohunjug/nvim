local config = {}

local function load_env_file()
   local env_file = os.getenv "HOME" .. "/.env"
   local env_contents = {}
   if vim.fn.filereadable(env_file) ~= 1 then
      print ".env file does not exist"
      return
   end
   local contents = vim.fn.readfile(env_file)
   for _, item in pairs(contents) do
      local line_content = vim.fn.split(item, "=")
      env_contents[line_content[1]] = line_content[2]
   end
   return env_contents
end

local function load_dbs()
   local env_contents = load_env_file()
   local dbs = {}
   for key, value in pairs(env_contents) do
      if vim.fn.stridx(key, "DB_CONNECTION_") >= 0 then
         local db_name = vim.fn.split(key, "_")[3]:lower()
         dbs[db_name] = value
      end
   end
   return dbs
end

function config.rooter()
   vim.g.rooter_pattern = {
      ".git",
      "Makefile",
      "_darcs",
      ".hg",
      "go.mod",
      ".bzr",
      ".svn",
      "pom.xml",
      "node_modules",
      "CMakeLists.txt",
   }
   vim.g.outermost_root = true
end

function config.vim_dadbod_ui()
   if packer_plugins["vim-dadbod"] and not packer_plugins["vim-dadbod"].loaded then
      vim.cmd [[packadd vim-dadbod]]
   end
   vim.g.db_ui_show_help = 0
   vim.g.db_ui_win_position = "left"
   vim.g.db_ui_use_nerd_fonts = 1
   vim.g.db_ui_winwidth = 35
   vim.g.db_ui_save_location = os.getenv "HOME" .. "/.cache/vim/db_ui_queries"
   vim.g.dbs = load_dbs()
end

function config.vim_vista()
   vim.g["vista#renderer#enable_icon"] = 1
   vim.g.vista_disable_statusline = 1
   vim.g.vista_default_executive = "ctags"
   vim.g.vista_echo_cursor_strategy = "floating_win"
   vim.g.vista_vimwiki_executive = "markdown"
   vim.g.vista_executive_for = {
      vimwiki = "markdown",
      pandoc = "markdown",
      markdown = "toc",
      typescript = "nvim_lsp",
      typescriptreact = "nvim_lsp",
   }
end

function config.zenmode()
   require "custom.zenmode"
end

function config.trouble()
   require("trouble").setup {
      position = "bottom", -- position of the list can be: bottom, top, left, right
      height = 10, -- height of the trouble list when position is top or bottom
      width = 50, -- width of the list when position is left or right
      icons = true, -- use devicons for filenames
      mode = "lsp_workspace_diagnostics", -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
      fold_open = "", -- icon used for open folds
      fold_closed = "", -- icon used for closed folds
      action_keys = { -- key mappings for actions in the trouble list
         -- map to {} to remove a mapping, for example:
         -- close = {},
         close = "q", -- close the list
         cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
         refresh = "r", -- manually refresh
         jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
         open_split = { "<c-x>" }, -- open buffer in new split
         open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
         open_tab = { "<c-t>" }, -- open buffer in new tab
         jump_close = { "o" }, -- jump to the diagnostic and close the list
         toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
         toggle_preview = "P", -- toggle auto_preview
         hover = "K", -- opens a small popup with the full multiline message
         preview = "p", -- preview the diagnostic location
         close_folds = { "zM", "zm" }, -- close all folds
         open_folds = { "zR", "zr" }, -- open all folds
         toggle_fold = { "zA", "za" }, -- toggle fold of current file
         previous = "k", -- preview item
         next = "j", -- next item
      },
      indent_lines = true, -- add an indent guide below the fold icons
      auto_open = false, -- automatically open the list when you have diagnostics
      auto_close = false, -- automatically close the list when you have no diagnostics
      auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
      auto_fold = false, -- automatically fold a file trouble list at creation
      signs = {
         -- icons / text used for a diagnostic
         error = "",
         warning = "",
         hint = "",
         information = "",
         other = "﫠",
      },
      use_lsp_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
   }
end

function config.wilder()
   vim.cmd [[
call wilder#setup({'modes': [':', '/', '?']})
call wilder#set_option('use_python_remote_plugin', 0)
call wilder#set_option('pipeline', [wilder#branch(wilder#cmdline_pipeline({'use_python': 0,'fuzzy': 1, 'fuzzy_filter': wilder#lua_fzy_filter()}),wilder#vim_search_pipeline(), [wilder#check({_, x -> empty(x)}), wilder#history(), wilder#result({'draw': [{_, x -> ' ' . x}]})])])
call wilder#set_option('renderer', wilder#renderer_mux({':': wilder#popupmenu_renderer({'highlighter': wilder#lua_fzy_highlighter(), 'left': [wilder#popupmenu_devicons()], 'right': [' ', wilder#popupmenu_scrollbar()]}), '/': wilder#wildmenu_renderer({'highlighter': wilder#lua_fzy_highlighter()})}))
]]
end

return config
