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

return config
