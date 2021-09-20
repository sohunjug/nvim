local M = {
   opt = true,
   event = { "BufRead", "BufNewFile" },
   requires = { "nvim-lua/plenary.nvim", opt = false },
}

M.config = function()
   local present, gitsigns = pcall(require, "gitsigns")
   if not present then
      return
   end

   gitsigns.setup {
      keymaps = {
         -- Default keymap options
         buffer = true,
         noremap = true,
         ["n ]c"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
         ["n [c"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },
         ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
         ["v <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
         ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
         ["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
         ["v <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
         ["n <leader>hR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
         ["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
         ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
         ["n <leader>hS"] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
         ["n <leader>hU"] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',
         -- Text objects
         ["o ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
         ["x ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
      },
      numhl = true,

      sign_priority = 5,
      signs = {
         add = { hl = "DiffAdd", text = "▋", numhl = "GitSignsAddNr" },
         change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
         -- changedelete = { hl = "DiffChange", text = "~", numhl = "GitSignsChangeNr" },
         changedelete = { hl = "GitGutterChange", text = "▎", numhl = "GitSignsChangeNr" },
         delete = { hl = "DiffDelete", text = "_", numhl = "GitSignsDeleteNr" },
         topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr" },
      },

      current_line_blame = true,
      current_line_blame_opts = {
         delay = 100,
         virt_text_pos = "right_align",
      },

      preview_config = {
         -- Options passed to nvim_open_win
         border = "single",
         style = "minimal",
         relative = "cursor",
         row = 0,
         col = 1,
      },

      status_formatter = nil, -- Use default
      watch_index = { interval = 100 },
   }
end

return M
