local M = {
   opt = true,
   cmd = { "NvimTreeFindFile", "NvimTreeToggle", "NvimTreeOpen" },
   requires = { "kyazdani42/nvim-web-devicons" },
}

M.config = function()
   if not packer_plugins["nvim-tree.lua"] or not packer_plugins["nvim-tree.lua"].loaded then
      vim.cmd [[packadd nvim-tree.lua]]
   end

   local present, tree_c = pcall(require, "nvim-tree.config")
   if not present then
      return
   end

   local tree_cb = tree_c.nvim_tree_callback

   require("nvim-tree").setup {
      auto_reload_on_write = true,
      create_in_closed_folder = false,
      disable_netrw = false,
      hijack_cursor = false,
      hijack_netrw = true,
      hijack_unnamed_buffer_when_opening = false,
      ignore_ft_on_setup = { "dashboard" }, -- don't open tree on specific fiypes.
      ignore_buffer_on_setup = false,
      open_on_setup = false,
      open_on_setup_file = false,
      open_on_tab = false,
      sort_by = "name",
      prefer_startup_root = false,
      sync_root_with_cwd = true,
      reload_on_bufenter = false,
      respect_buf_cwd = false,
      renderer = {
         add_trailing = true,
         group_empty = true,
         highlight_git = true,
         full_name = false,
         highlight_opened_files = "all",
         root_folder_modifier = table.concat { ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" },
         --":~",
         indent_markers = {
            enable = true,
            icons = {
               corner = "└",
               edge = "│",
               none = " ",
            },
         },
         icons = {
            webdev_colors = true,
            git_placement = "before",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
               file = true,
               folder = true,
               folder_arrow = true,
               git = true,
            },
            glyphs = {
               default = "",
               symlink = "",
               folder = {
                  arrow_closed = "",
                  arrow_open = "",
                  default = "",
                  open = "",
                  empty = "",
                  empty_open = "",
                  symlink = "",
                  symlink_open = "",
               },
               git = {
                  unstaged = "✗",
                  staged = "✓",
                  unmerged = "",
                  renamed = "➜",
                  untracked = "★",
                  deleted = "",
                  ignored = "◌",
               },
            },
         },
         special_files = {
            "Cargo.toml",
            "cargo.toml",
            "Makefile",
            "README.md",
            "readme.md",
            "makefile",
            "Makefile",
            "MAKEFILE",
            "go.mod",
         },
         symlink_destination = true,
      },
      --[[ update_to_buf_dir = {
         -- enable the feature
         enable = true,
         -- allow to open the tree if it was previously closed
         auto_open = true,
      }, ]]
      hijack_directories = {
         enable = true,
         auto_open = true,
      },
      diagnostics = {
         enable = true,
         show_on_dirs = true,
         icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
         },
      },
      update_focused_file = {
         -- enables the feature
         enable = true,
         -- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
         -- only relevant when `update_focused_file.enable` is true
         update_root = true,
         -- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
         -- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
         ignore_list = { ".git", "node_modules", ".cache" },
      },
      view = {
         side = "left",
         width = 30,
         height = 30,
         hide_root_folder = false,
         adaptive_size = true,
         number = false,
         relativenumber = false,
         preserve_window_proportions = false,
         signcolumn = "yes",
         mappings = {
            custom_only = true,
            list = {
               { key = { "l", "o", "<2-LeftMouse>", "<CR>" }, cb = tree_cb "edit" },
               { key = { "i", "<2-RightMouse>" }, cb = tree_cb "cd" },
               { key = "<C-v>", cb = tree_cb "vsplit" },
               { key = "<C-x>", cb = tree_cb "split" },
               { key = "<C-t>", cb = tree_cb "tabnew" },
               { key = "<", cb = tree_cb "prev_sibling" },
               { key = ">", cb = tree_cb "next_sibling" },
               { key = "P", cb = tree_cb "parent_node" },
               { key = { "h", "<S-CR>" }, cb = tree_cb "close_node" },
               { key = "<Tab>", cb = tree_cb "preview" },
               { key = "K", cb = tree_cb "first_sibling" },
               { key = "J", cb = tree_cb "last_sibling" },
               { key = "I", cb = tree_cb "toggle_ignored" },
               { key = { "H", "." }, cb = tree_cb "toggle_dotfiles" },
               { key = "r", cb = tree_cb "refresh" },
               { key = { "a", "N" }, cb = tree_cb "create" },
               { key = { "D", "dd" }, cb = tree_cb "remove" },
               { key = "R", cb = tree_cb "rename" },
               { key = "<C->", cb = tree_cb "full_rename" },
               { key = "x", cb = tree_cb "cut" },
               { key = "c", cb = tree_cb "copy" },
               { key = "p", cb = tree_cb "paste" },
               { key = "y", cb = tree_cb "copy_name" },
               { key = "Y", cb = tree_cb "copy_path" },
               { key = "gy", cb = tree_cb "copy_absolute_path" },
               { key = "[c", cb = tree_cb "prev_git_item" },
               { key = "}c", cb = tree_cb "next_git_item" },
               { key = { "-", "BS", "u" }, cb = tree_cb "dir_up" },
               { key = "O", cb = tree_cb "system_open" },
               { key = "q", cb = tree_cb "close" },
               { key = "g?", cb = tree_cb "toggle_help" },
            },
         },
      },
      system_open = {
         cmd = "",
         args = {},
      },
      filters = {
         dotfiles = false,
         custom = {},
         exclude = {},
      },
      filesystem_watchers = {
         enable = false,
         interval = 100,
         debounce_delay = 50,
      },
      trash = {
         cmd = "trash",
         require_confirm = true,
      },
      git = {
         enable = true,
         ignore = false,
         show_on_dirs = true,
         timeout = 400,
      },
      actions = {
         use_system_clipboard = true,
         change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
         },
         expand_all = {
            max_folder_discovery = 300,
            exclude = {},
         },
         open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
               enable = true,
               chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
               exclude = {
                  filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame", "Outline", "Trouble" },
                  buftype = { "nofile", "terminal", "help" },
               },
            },
         },
         remove_file = {
            close_window = true,
         },
      },
      live_filter = {
         prefix = "[FILTER]: ",
         always_show_folders = true,
      },
      log = {
         enable = false,
         truncate = false,
         types = {
            all = false,
            config = false,
            copy_paste = false,
            diagnostics = false,
            git = false,
            profile = false,
            watcher = false,
         },
      },
   }
end

--M.setup = function()
--vim.cmd [[highlight NvimTreeFolderIcon guibg=blue]]
--end
return M
