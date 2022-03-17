local M = {
   opt = true,
   -- config = conf.cmp,
   event = "InsertEnter",
   requires = {
      -- { "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
      {
         "hrsh7th/cmp-buffer",
         -- after = "cmp_luasnip"
      },
      { "hrsh7th/cmp-nvim-lsp", after = "cmp-buffer" },
      { "hrsh7th/cmp-nvim-lua", after = "cmp-nvim-lsp" },
      -- { "andersevenrud/compe-tmux", branch = "cmp", after = "cmp-nvim-lua" },
      {
         "hrsh7th/cmp-path",
         --after = "compe-tmux"
      },
      { "f3fora/cmp-spell", after = "cmp-path" },
      { "hrsh7th/cmp-vsnip", after = "cmp-spell" },
      { "hrsh7th/vim-vsnip", after = "cmp-vsnip" },
      {
         "tzachar/cmp-tabnine",
         run = "./install.sh",
         after = "vim-vsnip",
         config = function()
            local tabnine = require "cmp_tabnine.config"
            tabnine:setup {
               max_lines = 1000,
               max_num_results = 20,
               sort = true,
               run_on_every_keystroke = true,
               snippet_placeholder = "..",
            }
         end,
      },
      { "petertriho/cmp-git", after = "cmp-tabnine" },
      { "saadparwaiz1/cmp_luasnip", after = "cmp-git" },
   },
}

M.config = function()
   --[[ local t = function(str)
      return vim.api.nvim_replace_termcodes(str, true, true, true)
   end ]]

   if not packer_plugins["nvim-autopairs"].loaded then
      vim.cmd [[packadd nvim-autopairs]]
   end
   local cmp_autopairs = require "nvim-autopairs.completion.cmp"
   local cmp = require "cmp"
   cmp.setup {
      formatting = {
         -- format = function(entry, vim_item)
         --[[ local lspkind_icons = {
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
              vim_item.kind = string.format("%s %s", lspkind_icons[vim_item.kind], vim_item.kind) ]]
         --[[ vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. "" .. vim_item.kind

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
         end, ]]
         format = require("lspkind").cmp_format {
            with_text = true,
            menu = {
               buffer = "[Buffer]",
               cmp_tabnine = "[TN]",
               nvim_lsp = "[LSP]",
               luasnip = "[LuaSnip]",
               vsnip = "[Snip]",
               nvim_lua = "[Lua]",
               path = "[PATH]",
               spell = "[SPELL]",
               latex_symbols = "[Latex]",
            },
         },
      },
      -- You can set mappings if you want
      mapping = {
         ["<C-k>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
         ["<C-j>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
         ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
         ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
         ["<C-d>"] = cmp.mapping.scroll_docs(-4),
         ["<C-f>"] = cmp.mapping.scroll_docs(4),
         ["<C-e>"] = cmp.mapping.close(),
         --[[ ["<Tab>"] = function(fallback)
            if vim.fn.pumvisible() == 1 then
               vim.fn.feedkeys(t "<C-n>", "n")
            elseif require("luasnip").expand_or_jumpable() then
               vim.fn.feedkeys(t "<Plug>luasnip-expand-or-jump", "")
            else
               fallback()
            end
         end,
         ["<S-Tab>"] = function(fallback)
            if vim.fn.pumvisible() == 1 then
               vim.fn.feedkeys(t "<C-p>", "n")
            elseif require("luasnip").jumpable(-1) then
               vim.fn.feedkeys(t "<Plug>luasnip-jump-prev", "")
            else
               fallback()
            end
         end, ]]
         ["<Tab>"] = function(fallback)
            if cmp.visible() then
               cmp.select_next_item()
            else
               fallback()
            end
         end,
         ["<S-Tab>"] = function(fallback)
            if cmp.visible() then
               cmp.select_prev_item()
            else
               fallback()
            end
         end,
         ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
         },
         --[[ ["<C-h>"] = function(fallback)
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
         end, ]]
         ["<C-space>"] = cmp.mapping.complete(),
         -- ["<ESC>"] = cmp.mapping.close(),
         -- ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
         -- ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
      },

      completion = {
         -- with this false completion is triggered only manually
         -- autocomplete = true,
      },

      documentation = {
         border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      },

      snippet = {
         expand = function(args)
            -- require("luasnip").lsp_expand(args.body)
            vim.fn["vsnip#anonymous"](args.body)
         end,
      },

      sorting = {
         comparators = {
            cmp.config.compare.kind,
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
         },
      },

      -- You should specify your *installed* sources.
      sources = {
         { name = "nvim_lsp", priority = 8 },
         -- { name = "treesitter", priority = 8 },
         { name = "cmp_tabnine", priority = 7 },
         { name = "vsnip", priority = 6 },
         -- { name = "luasnip", priority = 7 },
         { name = "nvim_lua", priority = 5 },
         { name = "buffer", priority = 4 },
         { name = "path", priority = 3 },
         { name = "spell", priority = 2 },
         { name = "tmux", priority = 1 },
         -- { name = "orgmode", priority = 1 },
      },
   }

   -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
   cmp.setup.cmdline("/", {
      sources = {
         { name = "buffer" },
      },
   })

   -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
   cmp.setup.cmdline(":", {
      sources = cmp.config.sources({
         { name = "path" },
      }, {
         { name = "cmdline" },
      }),
   })
   cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
   vim.cmd [[autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }]]
end

return M
