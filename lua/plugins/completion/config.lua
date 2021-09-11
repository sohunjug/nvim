local config = {}

function config.nvim_lsp()
   require "plugins.completion.lspconfig"
end

function config.nvim_compe()
   require("compe").setup {
      enabled = true,
      debug = false,
      min_length = 1,
      preselect = "always",
      allow_prefix_unmatch = false,
      source = {
         path = true,
         buffer = true,
         calc = true,
         vsnip = true,
         nvim_lsp = true,
         nvim_lua = true,
         spell = true,
         tags = true,
         snippets_nvim = false,
      },
   }
end

function config.nullls()
   vim.env.PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath "config" .. "/.prettierrc"
end

function config.vim_vsnip()
   vim.g.vsnip_snippet_dir = os.getenv "HOME" .. "/.config/nvim/snippets"
end

function config.telescope()
   require "custom.telescope"
end

function config.vim_sonictemplate()
   vim.g.sonictemplate_postfix_key = "<C-,>"
   vim.g.sonictemplate_vim_template_dir = os.getenv "HOME" .. "/.config/nvim/template"
end

function config.smart_input()
   require("smartinput").setup { ["go"] = { ";", ":=", ";" } }
end

function config.emmet()
   vim.g.user_emmet_complete_tag = 0
   vim.g.user_emmet_install_global = 0
   vim.g.user_emmet_install_command = 0
   vim.g.user_emmet_mode = "i"
end

function config.go_nvim()
   require("go").setup {
      goimport = "gopls", -- if set to 'gopls' will use golsp format
      gofmt = "gopls", -- if set to gopls will use golsp format
      max_line_len = 120,
      tag_transform = false,
      test_dir = "",
      comment_placeholder = "   ",
      lsp_cfg = false, -- false: use your own lspconfig
      lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
      lsp_on_attach = true, -- use on_attach from go.nvim
      dap_debug = true,
   }
end

function config.navigator()
   require "custom.navigator"
end

function config.saga()
   vim.api.nvim_command "autocmd CursorHold * Lspsaga show_line_diagnostics"
end

function config.cmp()
   local t = function(str)
      return vim.api.nvim_replace_termcodes(str, true, true, true)
   end

   local cmp = require "cmp"
   cmp.setup {
      formatting = {
         format = function(entry, vim_item)
            local lspkind_icons = {
               Text = "",
               Method = "",
               Function = "",
               Constructor = "",
               Field = "ﰠ",
               Variable = "",
               Class = "ﴯ",
               Interface = "",
               Module = "",
               Property = "ﰠ",
               Unit = "塞",
               Value = "",
               Enum = "",
               Keyword = "",
               Snippet = "",
               Color = "",
               File = "",
               Reference = "",
               Folder = "",
               EnumMember = "",
               Constant = "",
               Struct = "פּ",
               Event = "",
               Operator = "",
               TypeParameter = "",
            }
            -- load lspkind icons
            vim_item.kind = string.format("%s %s", lspkind_icons[vim_item.kind], vim_item.kind)

            vim_item.menu = ({
               -- cmp_tabnine = "[TN]",
               orgmode = "[ORG]",
               nvim_lsp = "[LSP]",
               nvim_lua = "[Lua]",
               buffer = "[BUF]",
               path = "[PATH]",
               tmux = "[TMUX]",
               luasnip = "[SNIP]",
               spell = "[SPELL]",
            })[entry.source.name]

            return vim_item
         end,
      },
      -- You can set mappings if you want
      mapping = {
         ["<C-p>"] = cmp.mapping.select_prev_item(),
         ["<C-n>"] = cmp.mapping.select_next_item(),
         ["<C-d>"] = cmp.mapping.scroll_docs(-4),
         ["<C-f>"] = cmp.mapping.scroll_docs(4),
         ["<C-e>"] = cmp.mapping.close(),
         ["<Tab>"] = function(fallback)
            if vim.fn.pumvisible() == 1 then
               vim.fn.feedkeys(t "<C-n>", "n")
            else
               fallback()
            end
         end,
         ["<S-Tab>"] = function(fallback)
            if vim.fn.pumvisible() == 1 then
               vim.fn.feedkeys(t "<C-p>", "n")
            else
               fallback()
            end
         end,
         ["<C-h>"] = function(fallback)
            if require("luasnip").jumpable(-1) then
               vim.fn.feedkeys(t "<Plug>luasnip-jump-prev", "")
            else
               fallback()
            end
         end,
         ["<C-l>"] = function(fallback)
            if require("luasnip").expand_or_jumpable() then
               vim.fn.feedkeys(t "<Plug>luasnip-expand-or-jump", "")
            else
               fallback()
            end
         end,
      },

      snippet = {
         expand = function(args)
            require("luasnip").lsp_expand(args.body)
         end,
      },

      -- You should specify your *installed* sources.
      sources = {
         { name = "nvim_lsp" },
         { name = "nvim_lua" },
         { name = "luasnip" },
         { name = "buffer" },
         { name = "path" },
         { name = "spell" },
         { name = "tmux" },
         { name = "orgmode" },
         -- {name = 'cmp_tabnine'},
      },
   }
end

function config.luasnip()
   require("luasnip").config.set_config {
      history = true,
      updateevents = "TextChanged,TextChangedI",
   }
   require("luasnip/loaders/from_vscode").load()
end

return config
