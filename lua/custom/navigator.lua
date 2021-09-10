local global = require "core.global"
require("navigator").setup {
   debug = false, -- log output, set to true and log path: ~/.local/share/nvim/gh.log
   code_action_icon = " ",
   width = 0.75, -- max width ratio (number of cols for the floating window) / (window width)
   height = 0.3, -- max list window height, 0.3 by default
   preview_height = 0.35, -- max height of preview windows
   border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, -- border style, can be one of 'none', 'single', 'double',
   -- 'shadow', or a list of chars which defines the border
   -- put a on_attach of your own here, e.g
   -- function(client, bufnr)
   --   -- the on_attach will be called at end of navigator on_attach
   -- end,
   -- The attach code will apply to all LSP clients

   default_mapping = true, -- set to false if you will remap every key
   keymaps = { { key = "ggK", func = "declaration()" } }, -- a list of key maps
   -- this kepmap gK will override "gD" mapping function declaration()  in default kepmap
   -- please check mapping.lua for all keymaps
   treesitter_analysis = true, -- treesitter variable context
   transparency = 50, -- 0 ~ 100 blur the main window, 100: fully transparent, 0: opaque,  set to nil or 100 to disable it
   code_action_prompt = { enable = true, sign = true, sign_priority = 40, virtual_text = true },
   icons = {
      -- Code action
      code_action_icon = " ",
      -- Diagnostics
      diagnostic_head = "🐛",
      diagnostic_head_severity_1 = "🈲",
      -- refer to lua/navigator.lua for more icons setups
   },
   lspinstall = false, -- set to true if you would like use the lsp installed by lspinstall

   lsp = {
      format_on_save = true, -- set to false to disasble lsp code format on save (if you are using prettier/efm/formater etc)
      diagnostic_scroll_bar_sign = { "▃", "█" }, -- experimental:  diagnostic status in scroll bar area; set to nil to disable the diagnostic sign,
      -- for other style, set to {'╍', 'ﮆ'} or {'-', '='}
      diagnostic_virtual_text = true, -- show virtual for diagnostic message
      diagnostic_update_in_insert = false, -- update diagnostic message in insert mode
      disply_diagnostic_qf = true, -- always show quickfix if there are diagnostic errors, set to false if you  want to
   },
}
