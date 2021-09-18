local M = {
   opt = true,
   module = "lspconfig",
   requires = { "ray-x/guihua.lua", run = "cd lua/fzy && make" },
}

M.config = function()
   if not packer_plugins["guihua.lua"] or not packer_plugins["guihua.lua"].loaded then
      vim.cmd [[packadd guihua.lua]]
   end
   require("navigator").setup {
      debug = false, -- log output, set to true and log path: ~/.local/share/nvim/gh.log
      code_action_icon = "",
      width = 0.75, -- max width ratio (number of cols for the floating window) / (window width)
      height = 0.3, -- max list window height, 0.3 by default
      preview_height = 0.35, -- max height of preview windows
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, -- border style, can be one of 'none', 'single', 'double',
      -- 'shadow', or a list of chars which defines the border
      -- function(client, bufnr)
      --   -- the on_attach will be called at end of navigator on_attach
      -- end,
      -- The attach code will apply to all LSP clients

      default_mapping = false, -- set to false if you will remap every key
      keymaps = { {
         key = "gK",
         func = "declaration()",
      } },
      -- this kepmap gK will override "gD" mapping function declaration()  in default kepmap
      -- please check mapping.lua for all keymaps
      treesitter_analysis = true, -- treesitter variable context
      transparency = 50, -- 0 ~ 100 blur the main window, 100: fully transparent, 0: opaque,  set to nil or 100 to disable it
      code_action_prompt = { enable = true, sign = true, sign_priority = 40, virtual_text = true },
      icons = {
         -- Code action
         code_action_icon = "",
         -- Diagnostics
         diagnostic_head = "🐛",
         diagnostic_head_severity_1 = "🈲",
         diagnostic_head_severity_2 = "☣️",
         diagnostic_head_severity_3 = "👎",
         diagnostic_head_description = "📛",
         diagnostic_virtual_text = "🦊",
         diagnostic_file = "🚑",
         -- Values
         value_changed = "📝",
         value_definition = "🦕",
         -- Treesitter
         match_kinds = {
            var = " ", -- "👹", -- Vampaire
            method = "ƒ ", --  "🍔", -- mac
            ["function"] = " ", -- "🤣", -- Fun
            parameter = "  ", -- Pi
            associated = "🤝",
            namespace = "🚀",
            type = " ",
            field = "🏈",
         },
         treesitter_defult = "🌲",
      },
   }
end

return M
