local M = {}

-- Edit user config file, based on the assumption it exists in the config as
-- theme = "theme name"
-- 1st arg as current theme, 2nd as new theme
M.change_theme = function(current_theme, new_theme)
   if current_theme == nil or new_theme == nil then
      print "Error: Provide current and new theme name"
      return false
   end
   if current_theme == new_theme then
      return
   end

   local file_fn = M.file
   local user_config = vim.g.custom_user_config
   local file = vim.fn.stdpath "config" .. "/lua/config/" .. user_config .. ".lua"
   -- store in data variable
   local data = assert(file_fn("r", file))
   -- escape characters which can be parsed as magic chars
   current_theme = current_theme:gsub("%p", "%%%0")
   new_theme = new_theme:gsub("%p", "%%%0")
   local find = "theme = .?" .. current_theme .. ".?"
   local replace = 'theme = "' .. new_theme .. '"'
   local content = string.gsub(data, find, replace)
   -- see if the find string exists in file
   if content == data then
      print("Error: Cannot change default theme with " .. new_theme .. ", edit " .. file .. " manually")
      return false
   else
      assert(file_fn("w", file, content))
   end
end

-- clear command line from lua
M.clear_cmdline = function()
   vim.defer_fn(function()
      vim.cmd "echo"
   end, 0)
end

-- wrapper to use vim.api.nvim_echo
-- table of {string, highlight}
-- e.g echo({{"Hello", "Title"}, {"World"}})
M.echo = function(opts)
   if opts == nil or type(opts) ~= "table" then
      return
   end
   vim.api.nvim_echo(opts, false, {})
end

-- 1st arg - r or w
-- 2nd arg - file path
-- 3rd arg - content if 1st arg is w
-- return file data on read, nothing on write
M.file = function(mode, filepath, content)
   local data
   local fd = assert(vim.loop.fs_open(filepath, mode, 438))
   local stat = assert(vim.loop.fs_fstat(fd))
   if stat.type ~= "file" then
      data = false
   else
      if mode == "r" then
         data = assert(vim.loop.fs_read(fd, stat.size, 0))
      else
         assert(vim.loop.fs_write(fd, content, 0))
         data = true
      end
   end
   assert(vim.loop.fs_close(fd))
   return data
end

-- return a table of available themes
M.list_themes = function(return_type)
   local themes = {}
   -- folder where theme files are stored
   local folders = {}
   local now = vim.fn.stdpath "config" .. "/lua/colors/themes"
   -- local opt = vim.fn.stdpath "data" .. "/site/pack/packer/opt/nvim-base16.lua/lua/hl_themes"
   -- local start = vim.fn.stdpath "data" .. "/site/pack/packer/start/nvim-base16.lua/lua/hl_themes"
   table.insert(folders, now)
   -- table.insert(folders, opt)
   -- table.insert(folders, start)
   -- list all the contents of the folder and filter out files with .lua extension, then append to themes table
   for _, themes_folder in ipairs(folders) do
      local fd = vim.loop.fs_scandir(themes_folder)
      if fd then
         while true do
            local name, typ = vim.loop.fs_scandir_next(fd)
            if name == nil then
               break
            end
            if typ ~= "directory" and string.find(name, ".lua$") then
               -- return the table values as keys if specified
               if return_type == "keys_as_value" then
                  themes[vim.fn.fnamemodify(name, ":r")] = true
               else
                  table.insert(themes, vim.fn.fnamemodify(name, ":r"))
               end
            end
         end
      end
   end
   return themes
end

-- reload whole config without exiting nvim
M.reload_config = require "modules.reload_config"

-- reload a plugin ( will try to load even if not loaded)
-- can take a string or list ( table )
-- return true or false
M.reload_plugin = function(plugins)
   local status = true
   local function _reload_plugin(plugin)
      local loaded = package.loaded[plugin]
      if loaded then
         package.loaded[plugin] = nil
      end
      local ok, err = pcall(require, plugin)
      if not ok then
         print("Error: Cannot load " .. plugin .. " plugin!\n" .. err .. "\n")
         status = false
      end
   end

   if type(plugins) == "string" then
      _reload_plugin(plugins)
   elseif type(plugins) == "table" then
      for _, plugin in ipairs(plugins) do
         _reload_plugin(plugin)
      end
   end
   return status
end

-- reload themes without restarting vim
-- if no theme name given then reload the current theme
M.reload_theme = function(theme_name)
   local reload_plugin = M.reload_plugin

   -- if theme name is empty or nil, then reload the current theme
   if theme_name == nil or theme_name == "" then
      theme_name = vim.g.custom_theme
   end

   if not pcall(require, "hl_themes." .. theme_name) then
      print("No such theme ( " .. theme_name .. " )")
      return false
   end

   vim.g.custom_theme = theme_name

   -- reload the base16 theme and highlights
   require("colors").init(theme_name)

   require("feline").reset_highlights()

   if
      not reload_plugin {
         -- "custom.bufferline",
         -- "custom.statuslines",
      }
   then
      print "Error: Not able to reload all plugins."
      return false
   end

   return true
end

-- toggle between 2 themes
-- argument should be a table with 2 theme names
M.toggle_theme = function(themes)
   local current_theme = vim.g.current_custom_theme or vim.g.custom_theme
   for _, name in ipairs(themes) do
      if name ~= current_theme then
         if M.reload_theme(name) then
            -- open a buffer and close it to reload the statusline
            vim.cmd "new|bwipeout"
            vim.g.current_custom_theme = name
            if M.change_theme(vim.g.custom_theme, name) then
               vim.g.custom_theme = name
            end
         end
      end
   end
end

return M
