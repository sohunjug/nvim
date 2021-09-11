-- local sumneko_root = os.getenv "HOME" .. "/Repos/lua-language-server"
local M = {}
local global = require "core.global"
local config = require "plugins.completion.lsp.config"

M.argv = global.vim_path .. "/lsp/lua-language-server/main.lua"

if vim.fn.executable(global.vim_path .. "/lsp/lua-language-server/bin/macOS/lua-language-server") == 1 then
   M.cmd = global.vim_path .. "/lsp/lua-language-server/bin/macOS/lua-language-server"
elseif vim.fn.executable(global.vim_path .. "/lsp/lua-language-server/bin/linux/lua-language-server") == 1 then
   M.cmd = global.vim_path .. "/lsp/lua-language-server/bin/linux/lua-language-server"
end
M.config = {
   cmd = {
      M.cmd,
      "-E",
      M.argv,
   },
   on_attach = config.lsp_on_attach,
   on_init = config.lsp_on_init,
   settings = {
      Lua = {
         completion = {
            enable = true,
            callSnippet = "Replace",
         },
         runtime = {
            version = "LuaJIT",
            path = (function()
               local runtime_path = vim.split(package.path, ";")
               table.insert(runtime_path, "lua/?.lua")
               table.insert(runtime_path, "lua/?/init.lua")
               table.insert(runtime_path, global.data_dir .. "pack/packer/opt/*/?.lua")
               table.insert(runtime_path, global.data_dir .. "pack/packer/start/*/?.lua")
               table.insert(runtime_path, global.vim_path .. "/lua/?.lua")
               -- table.insert(runtime_path, global.data_dir .. "pack/packer/opt/packer.nvim/lua/?.lua")
               -- table.insert(runtime_path, global.data_dir .. "pack/packer/opt/packer.nvim/lua/packer/?.lua")
               if
                  global.is_mac
                  and vim.fn.filereadable "/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/doc/init.lua"
               then
                  table.insert(runtime_path, "/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/?/?.lua")
                  table.insert(runtime_path, "/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/?/?/?.lua")
               end
               return runtime_path
            end)(),
         },
         diagnostics = {
            enable = true,
            globals = {
               "vim",
               "packer_plugins",
               "describe",
               "it",
               "before_each",
               "after_each",
               "awesome",
               "theme",
               "client",
               "P",
               "hs",
            },
         },
         workspace = {
            -- library = vim.list_extend({[vim.fn.expand("$VIMRUNTIME/lua")] = true}, {}),
            library = {
               [vim.fn.expand "$VIMRUNTIME/lua"] = true,
               [global.vim_path .. "/lua"] = true,
               [global.data_dir .. "/pack/packer/opt/packer.nvim/lua"] = true,
               [vim.fn.expand "$VIMRUNTIME/vim/lsp"] = true,
               -- [global.vim_path .. "/lsp/lua-language-server/lua"] = true
               ["/opt/homebrew/share/luajit-2.1.0-beta3/jit"] = true,
            },
            checkThirdParty = true,
            maxPreload = 10000,
            preloadFileSize = 5000,
         },
      },
   },
}

return M
