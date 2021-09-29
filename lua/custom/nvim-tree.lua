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

      open_on_setup = false,
      auto_close = false, -- closes tree when it's the last window
      follow = true,
      auto_open = true,
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      open_on_tab = false,
      update_cwd = true,
      ignore_ft_on_setup = { "dashboard" }, -- don't open tree on specific fiypes.
      update_focused_file = {
         -- enables the feature
         enable = true,
         -- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
         -- only relevant when `update_focused_file.enable` is true
         update_cwd = true,
         -- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
         -- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
         ignore_list = {},
      },
      lsp_diagnostics = true,
      view = {
         side = "left",
         width = 30,
         auto_resize = true,
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
               { key = { "-", "BS" }, cb = tree_cb "dir_up" },
               { key = "O", cb = tree_cb "system_open" },
               { key = "q", cb = tree_cb "close" },
               { key = "g?", cb = tree_cb "toggle_help" },
            },
         },
      },
   }
end

M.setup = function()
   local g = vim.g

   g.nvim_tree_special_files = {
      ["README.md"] = 1,
      ["makefile"] = 1,
      ["Makefile"] = 1,
      ["MAKEFILE"] = 1,
      ["go.mod"] = 1,
      ["cargo.toml"] = 1,
   }
   g.nvim_tree_respect_buf_cwd = 1
   g.nvim_tree_indent_markers = 1
   g.nvim_tree_ignore = { ".git", "node_modules", ".cache" }
   g.nvim_tree_quit_on_open = 0 -- closes tree when file's opened
   g.nvim_tree_root_folder_modifier = table.concat { ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" }
   g.nvim_tree_git_hl = 1
   g.nvim_tree_gitignore = 0
   g.nvim_tree_hide_dotfiles = 0
   g.nvim_tree_highlight_opened_files = 1
   g.nvim_tree_allow_resize = 1
   g.nvim_tree_add_trailing = 1 -- append a trailing slash to folder names
   g.nvim_tree_window_picker_exclude = {
      filetype = {
         "notify",
         "Outline",
         "Trouble",
         "packer",
         "qf",
      },
      buftype = {
         "terminal",
         "nofile",
      },
   }

   g.nvim_tree_show_icons = {
      git = 1,
      folders = 1,
      folder_arrows = 1,
      files = 1,
   }

   g.nvim_tree_icons = {
      default = "",
      symlink = "",
      git = {
         deleted = "",
         ignored = "◌",
         renamed = "≫", --➜
         staged = "✓",
         unmerged = "",
         unstaged = "✗",
         untracked = "★",
      },
      folder = {
         -- disable indent_markers option to get arrows working or if you want both arrows and indent then just add the arrow icons in front            ofthe default and opened folders below!
         arrow_open = "",
         arrow_closed = "",
         default = "",
         empty = "", -- 
         empty_open = "",
         open = "",
         symlink = "",
         symlink_open = "",
      },
   }
end
return M
