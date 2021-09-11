-- IMPORTANT NOTE : This is default config, so dont change anything here. (check chadrc.lua instead)

local M = {}
M.ui, M.options, M.plugin_status, M.mappings, M.custom = {}, {}, {}, {}, {}

-- non plugin ui configs, available without any plugins
M.ui = {
   italic_comments = false,

   -- theme to be used, to see all available themes, open the theme switcher by <leader> + th
   theme = "onedark",

   -- theme toggler, toggle between two themes, see theme_toggleer mappings
   theme_toggler = {
      enabled = false,
      fav_themes = {
         "onedark",
         "gruvchad",
      },
   },

   -- Enable this only if your terminal has the colorscheme set which nvchad uses
   -- For Ex : if you have onedark set in nvchad , set onedark's bg color on your terminal
   transparency = false,
}

-- plugin related ui options
M.ui.plugin = {}

-- non plugin normal, available without any plugins
M.options = {}

-- these are plugin related options
M.options.plugin = {}

-- enable and disable plugins (false for disable)
M.plugin_status = {}

-- mappings -- don't use a single keymap twice --
-- non plugin mappings
M.mappings = {}

-- all plugins related mappings
-- to get short info about a plugin, see the respective string in plugin_status, if not present, then info here
M.mappings.plugin = {}

-- user custom mappings
-- e.g: name = { "mode" , "keys" , "cmd" , "options"}
-- name: can be empty or something unique with repect to other custom mappings
--    { mode, key, cmd } or name = { mode, key, cmd }
-- mode: usage: mode or { mode1, mode2 }, multiple modes allowed, available modes => :h map-modes,
-- keys: multiple keys allowed, same synxtax as modes
-- cmd:  for vim commands, must use ':' at start and add <CR> at the end if want to execute
-- options: see :h nvim_set_keymap() opts section
M.custom.mappings = {
   -- clear_all = {
   --    "n",
   --    "<leader>cc",
   --    "gg0vG$d",
   -- },
}

return M
