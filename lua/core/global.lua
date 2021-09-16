local M = {}
local home = os.getenv "HOME"
local os_name = vim.loop.os_uname().sysname

function M:load_variables()
   self.is_mac = os_name == "Darwin"
   self.is_linux = os_name == "Linux"
   self.is_windows = os_name == "Windows"
   self.path_sep = self.is_windows and "\\" or "/"
   self.home = home .. self.path_sep
   self.vim_path = vim.fn.stdpath "config" .. self.path_sep
   self.cache_dir = home .. self.path_sep .. ".cache" .. self.path_sep .. "nvim" .. self.path_sep
   self.data_dir = string.format("%s/site/", vim.fn.stdpath "data")
end

-- Create cache dir and subs dir
function M:createdir()
   local data_dir = {
      self.cache_dir .. "backup",
      self.cache_dir .. "session",
      self.cache_dir .. "swap",
	self.cache_dir .. "tags",
      self.cache_dir .. "undo",
   }
   -- There only check once that If cache_dir exists
   -- Then I don't want to check subs dir exists
   if vim.fn.isdirectory(self.cache_dir) == 0 then
      os.execute("mkdir -p " .. self.cache_dir)
      for _, v in pairs(data_dir) do
         if vim.fn.isdirectory(v) == 0 then
            os.execute("mkdir -p " .. v)
         end
      end
   end
end

function M:new()
   local t = {}
   setmetatable(t, { __index = self })
   return t
end

function M.setup()
   _G.S_NVIM = M:new()
   S_NVIM:load_variables()
   S_NVIM:createdir()
end

return M
