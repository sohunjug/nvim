local api = vim.api
local lspconfig = require "lspconfig"
local global = require "core.global"
local format = require "plugins.completion.format"

if not packer_plugins["lspsaga.nvim"].loaded then vim.cmd [[packadd lspsaga.nvim]] end

local saga = require "lspsaga"
saga.init_lsp_saga {code_action_icon = "💡"}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

function _G.reload_lsp()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    vim.cmd [[edit]]
end

function _G.open_lsp_log()
    local path = vim.lsp.get_log_path()
    vim.cmd("edit " .. path)
end

vim.cmd "command! -nargs=0 LspLog call v:lua.open_lsp_log()"
vim.cmd "command! -nargs=0 LspRestart call v:lua.reload_lsp()"

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Enable underline, use default values
    underline = true,
    -- Enable virtual text, override spacing to 4
    virtual_text = true,
    signs = {enable = true, priority = 20},
    -- Disable a feature
    update_in_insert = true
})

local enhance_attach = function(client, bufnr)
    if client.resolved_capabilities.document_formatting then format.lsp_before_save() end
    api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

lspconfig.gopls.setup {
    cmd = {"gopls", "--remote=auto"},
    on_attach = enhance_attach,
    capabilities = capabilities,
    init_options = {usePlaceholders = true, completeUnimported = true}
}

if vim.fn.executable(global.vim_path .. "/lsp/lua-language-server/bin/macOS/lua-language-server") == 1 then
    lspconfig.sumneko_lua.setup {
        cmd = {
            global.vim_path .. "/lsp/lua-language-server/bin/macOS/lua-language-server", "-E",
            global.vim_path .. "/lsp/lua-language-server/main.lua"
        },
        settings = {
            Lua = {
                diagnostics = {enable = true, globals = {"vim", "packer_plugins"}},
                runtime = {version = "LuaJIT"},
                workspace = {
                    -- library = vim.list_extend({[vim.fn.expand("$VIMRUNTIME/lua")] = true}, {}),
                    library = {
                        [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                        -- [global.vim_path .. "/lsp/lua-language-server/lua"] = true
                        ["/opt/homebrew/share/luajit-2.1.0-beta3/jit"] = true
                    },
                    checkThirdParty = false,
                    maxPreload = 10000,
                    preloadFileSize = 5000
                }
            }
        }
    }
elseif vim.fn.executable(global.vim_path .. "/lsp/lua-language-server/bin/linux/lua-language-server") == 1 then
    lspconfig.sumneko_lua.setup {
        cmd = {
            global.vim_path .. "/lsp/lua-language-server/bin/linux/lua-language-server", "-E",
            global.vim_path .. "/lsp/lua-language-server/main.lua"
        },
        settings = {
            Lua = {
                diagnostics = {enable = true, globals = {"vim", "packer_plugins"}},
                runtime = {version = "LuaJIT"},
                workspace = {
                    -- library = vim.list_extend({[vim.fn.expand("$VIMRUNTIME/lua")] = true}, {}),
                    library = {
                        [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                        -- [global.vim_path .. "/lsp/lua-language-server/lua"] = true
                        ["/opt/homebrew/share/luajit-2.1.0-beta3/jit"] = true
                    },
                    checkThirdParty = false,
                    maxPreload = 10000,
                    preloadFileSize = 5000
                }
            }
        }
    }
end

if vim.fn.executable "lua-format" == 1 and global.efm_enable == true then
    lspconfig.efm.setup {
        init_options = {documentFormatting = true},
        filetypes = {"lua"},
        settings = {
            rootMarkers = {".git/"},
            languages = {
                lua = {
                    {
                        formatCommand = "lua-format -i --no-keep-simple-function-one-line --no-break-after-operator --column-limit=120 --break-after-table-lb",
                        formatStdin = true
                    }
                }
            }
        }
    }
end
lspconfig.tsserver.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        enhance_attach(client)
    end
}

lspconfig.clangd.setup {
    cmd = {"clangd", "--background-index", "--suggest-missing-includes", "--clang-tidy", "--header-insertion=iwyu"}
}

lspconfig.rust_analyzer.setup {capabilities = capabilities}

local servers = {"dockerls", "bashls", "pyright"}

for _, server in ipairs(servers) do lspconfig[server].setup {on_attach = enhance_attach} end
