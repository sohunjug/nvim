local M = {
   opt = true,
   event = { "BufReadPost" },
}

M.config = function()
   require("lightspeed").setup {
      gnore_case = false,
      exit_after_idle_msecs = { unlabeled = 1000, labeled = nil },
      jump_to_unique_chars = { safety_timeout = 400 },
      match_only_the_start_of_same_char_seqs = true,
      force_beacons_into_match_width = false,
      -- Display characters in a custom way in the highlighted matches.
      substitute_chars = { ["\r"] = "¬" },
      -- Leaving the appropriate list empty effectively disables "smart" mode,
      -- and forces auto-jump to be on or off.
      safe_labels = { nil },
      labels = { nil },
      -- These keys are captured directly by the plugin at runtime.
      special_keys = {
         next_match_group = "<space>",
         prev_match_group = "<tab>",
      },

      --- f/t ---
      limit_ft_matches = 5,
      -- jump_to_first_match = true,
      -- jump_on_partial_input_safety_timeout = 400,
      -- This can get _really_ slow if the window has a lot of content,
      -- turn it on only if your machine can always cope with it.
      -- highlight_unique_chars = true,
      -- grey_out_search_area = true,
      -- highlight_unique_chars = true,
      instant_repeat_fwd_key = nil,
      instant_repeat_bwd_key = nil,
      -- If no values are given, these will be set at runtime,
      -- based on `jump_to_first_match`.
      repeat_ft_with_target_char = false,
   }
   vim.api.nvim_set_keymap("n", "s", "s", { noremap = true })
   vim.api.nvim_set_keymap("n", "S", "S", { noremap = true })
   vim.api.nvim_set_keymap("v", "s", "s", { noremap = true })
   vim.api.nvim_set_keymap("v", "S", "S", { noremap = true })
end

return M
