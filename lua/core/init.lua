local core_modules = {
   "core.events",
   "core.options",
   "core.mapping",
   "keymap",
}

vim.cmd [[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]]
vim.cmd [[ autocmd ColorScheme * highlight NotifyBG guibg=#3d3d3d guifg=#3e4451 ]]
-- vim.cmd [[ highlight Normal guibg=#000000 ctermbg=#000000 ]]
local global = require "core.global"

-- Create cache dir and subs dir
local createdir = function()
   local data_dir = {
      global.cache_dir .. "backup",
      global.cache_dir .. "session",
      global.cache_dir .. "swap",
      global.cache_dir .. "tags",
      global.cache_dir .. "undo",
   }
   -- There only check once that If cache_dir exists
   -- Then I don't want to check subs dir exists
   if vim.fn.isdirectory(global.cache_dir) == 0 then
      os.execute("mkdir -p " .. global.cache_dir)
      for _, v in pairs(data_dir) do
         if vim.fn.isdirectory(v) == 0 then
            os.execute("mkdir -p " .. v)
         end
      end
   end
end

createdir()

local plugin = require "core.plugins"

plugin.ensure_plugins()

for _, module in ipairs(core_modules) do
   local ok, err = pcall(require, module)
   if not ok then
      error("Error loading " .. module .. "\n\n" .. err)
   end
end

-- set all the non plugin mappings
-- require("core.mappings").misc()
plugin.load_compile()

-- vim.cmd [[highlight Normal guibg=NONE ctermbg=None]]
