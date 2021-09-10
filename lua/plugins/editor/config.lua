local config = {}

function config.delimimate()
   vim.g.delimitMate_expand_cr = 0
   vim.g.delimitMate_expand_space = 1
   vim.g.delimitMate_smart_quotes = 1
   vim.g.delimitMate_expand_inside_quotes = 0
   vim.api.nvim_command 'au FileType markdown let b:delimitMate_nesting_quotes = ["`"]'
end

function config.symbols()
   vim.g.symbols_outline = {
      highlight_hovered_item = true,
      show_guides = false,
      auto_preview = true,
      position = "right",
      width = 25,
      show_numbers = false,
      show_relative_numbers = false,
      show_symbol_details = true,
      keymaps = { -- These keymaps can be a string or a table for multiple keys
         close = { "<Esc>", "q" },
         goto_location = "<Cr>",
         focus_location = "o",
         hover_symbol = "h",
         toggle_preview = "K",
         rename_symbol = "r",
         code_actions = "a",
      },
      lsp_blacklist = {},
      symbol_blacklist = {},
      symbols = {
         File = { icon = "", hl = "TSURI" },
         Module = { icon = "", hl = "TSNamespace" },
         Namespace = { icon = "", hl = "TSNamespace" },
         Package = { icon = "", hl = "TSNamespace" },
         Class = { icon = "𝓒", hl = "TSType" },
         Method = { icon = "ƒ", hl = "TSMethod" },
         Property = { icon = "", hl = "TSMethod" },
         Field = { icon = "", hl = "TSField" },
         Constructor = { icon = "", hl = "TSConstructor" },
         Enum = { icon = "ℰ", hl = "TSType" },
         Interface = { icon = "ﰮ", hl = "TSType" },
         Function = { icon = "", hl = "TSFunction" },
         Variable = { icon = "", hl = "TSConstant" },
         Constant = { icon = "", hl = "TSConstant" },
         String = { icon = "𝓐", hl = "TSString" },
         Number = { icon = "#", hl = "TSNumber" },
         Boolean = { icon = "⊨", hl = "TSBoolean" },
         Array = { icon = "", hl = "TSConstant" },
         Object = { icon = "⦿", hl = "TSType" },
         Key = { icon = "🔐", hl = "TSType" },
         Null = { icon = "NULL", hl = "TSType" },
         EnumMember = { icon = "", hl = "TSField" },
         Struct = { icon = "𝓢", hl = "TSType" },
         Event = { icon = "🗲", hl = "TSType" },
         Operator = { icon = "+", hl = "TSOperator" },
         TypeParameter = { icon = "𝙏", hl = "TSParameter" },
      },
   }
end

function config.nvim_colorizer()
   require("colorizer").setup {
      css = { rgb_fn = true },
      scss = { rgb_fn = true },
      sass = { rgb_fn = true },
      stylus = { rgb_fn = true },
      vim = { names = true },
      tmux = { names = false },
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      html = { mode = "foreground" },
   }
end

function config.vim_cursorwod()
   vim.api.nvim_command "augroup user_plugin_cursorword"
   vim.api.nvim_command "autocmd!"
   vim.api.nvim_command "autocmd FileType NvimTree,lspsagafinder,dashboard,vista let b:cursorword = 0"
   vim.api.nvim_command "autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif"
   vim.api.nvim_command "autocmd InsertEnter * let b:cursorword = 0"
   vim.api.nvim_command "autocmd InsertLeave * let b:cursorword = 1"
   vim.api.nvim_command "augroup END"
end

return config
