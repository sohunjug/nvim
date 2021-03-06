local M = {
   -- cmd = "Telescope",
   requires = {
      { "nvim-lua/popup.nvim", opt = true },
      { "nvim-lua/plenary.nvim", opt = false },
      -- { "jremmen/vim-ripgrep", opt = true },
      { "nvim-telescope/telescope-fzy-native.nvim", opt = true },
      { "nvim-telescope/telescope-project.nvim", opt = true },
      {
         "nvim-telescope/telescope-frecency.nvim",
         opt = true,
         requires = { "tami5/sqlite.lua", opt = true },
      },
      {
         "nvim-telescope/telescope-cheat.nvim",
         opt = true,
         -- requires = { "tami5/sqlite.nvim", opt = true },
      },
      {
         "gbrlsnchs/telescope-lsp-handlers.nvim",
         otp = true,
      },
   },
}
M.config = function()
   if
      not packer_plugins["plenary.nvim"]
      or not packer_plugins["telescope-cheat"]
      or not packer_plugins["plenary.nvim"].loaded
      or not packer_plugins["telescope-cheat"].loaded
   then
      vim.cmd [[packadd telescope.nvim]]
      vim.cmd [[packadd plenary.nvim]]
      vim.cmd [[packadd popup.nvim]]
      vim.cmd [[packadd telescope-fzy-native.nvim]]
      vim.cmd [[packadd telescope-project.nvim]]
      vim.cmd [[packadd telescope-frecency.nvim]]
      vim.cmd [[packadd telescope-cheat.nvim]]
      vim.cmd [[packadd telescope-lsp-handlers.nvim]]
      vim.cmd [[packadd sqlite.lua]]
   end

   local present, telescope = pcall(require, "telescope")
   if not present then
      return
   end

   telescope.setup {
      defaults = {
         vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
         },
         prompt_prefix = " λ  ",
         selection_caret = " ",
         entry_prefix = "  ",
         initial_mode = "normal",
         selection_strategy = "reset",
         sorting_strategy = "ascending",
         layout_strategy = "horizontal",
         layout_config = {
            horizontal = { prompt_position = "bottom", preview_width = 0.55, results_width = 0.8 },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
         },
         file_sorter = require("telescope.sorters").get_fuzzy_file,
         file_ignore_patterns = {},
         generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
         path_display = { "absolute" },
         winblend = 0,
         border = {},
         borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
         color_devicons = true,
         use_less = true,
         set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
         file_previewer = require("telescope.previewers").vim_buffer_cat.new,
         grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
         qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
         -- Developer configurations: Not meant for general override
         buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
         mappings = {
            i = {
               ["<C-j>"] = require("telescope.actions").move_selection_next,
               ["<C-k>"] = require("telescope.actions").move_selection_previous,
            },
         },
      },
      extensions = {
         fzy_native = { override_generic_sorter = false, override_file_sorter = true },
         project = { hidden_files = false },
         frecency = {
            db_root = S_NVIM.data_dir,
            ignore_patterns = { "*.git/*", "*/tmp/*", "*/bin/*", "*/build/*" },
            workspaces = {
               dotfiles = S_NVIM.home .. "Code/dotfiles",
               nvim = S_NVIM.vim_path,
            },
         },
         lsp_handlers = {
            disable = {},
            location = {
               telescope = {},
               no_results_message = "No references found",
            },
            symbol = {
               telescope = {},
               no_results_message = "No symbols found",
            },
            call_hierarchy = {
               telescope = {},
               no_results_message = "No calls found",
            },
            code_action = {
               telescope = {},
               no_results_message = "No code actions available",
               prefix = "",
            },
         },
         --         fzf = {
         --             fuzzy = true, -- false will only do exact matching
         --             override_generic_sorter = false, -- override the generic sorter
         --             override_file_sorter = true, -- override the file sorter
         --             case_mode = "smart_case" -- or "ignore_case" or "respect_case"
         -- the default case_mode is "smart_case"
         --         }
         --         media_files = {
         --             filetypes = {"png", "webp", "jpg", "jpeg"},
         --             find_cmd = "rg" -- find command (defaults to `fd`)
         --         }
      },
      pickers = {
         keymaps = {
            initial_mode = "insert",
         },
         git_files = {
            initial_mode = "insert",
         },
         git_bcommits = {
            initial_mode = "insert",
         },
         git_commits = {
            initial_mode = "insert",
         },
         find_files = {
            initial_mode = "insert",
         },
      },
   }

   local extensions = { "themes", "terms", "fzy_native", "project", "frecency", "cheat" }
   -- local packer_repos = [["extensions", "telescope-fzf-native.nvim"]]

   -- if vim.fn.executable "ueberzug" == 1 then
   --    table.insert(extensions, "media_files")
   --    packer_repos = packer_repos .. ', "telescope-media-files.nvim"'
   -- end

   pcall(function()
      for _, ext in ipairs(extensions) do
         telescope.load_extension(ext)
      end
   end)
end
return M
