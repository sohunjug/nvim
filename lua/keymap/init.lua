local bind = require "keymap.bind"
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args
-- local global = require "core.global"
require "keymap.config"

local plug_map = {
   ["i|<TAB>"] = map_cmd("v:lua.tab_complete()"):with_expr():with_silent(),
   ["i|<S-TAB>"] = map_cmd("v:lua.s_tab_complete()"):with_silent():with_expr(),
   ["i|<CR>"] = map_cmd([[compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'mode': '' })]])
      :with_noremap()
      :with_expr()
      :with_nowait(),
   -- person keymap
   -- ["n|mf"] = map_cr("<cmd>lua require('internal.fsevent').file_event()<CR>"):with_silent():with_nowait():with_noremap(),
   -- ["n|gb"] = map_cr("BufferLinePick"):with_noremap():with_silent(),
   -- Packer
   ["n|<leader>pu"] = map_cr("PackerSync"):with_silent():with_noremap():with_nowait(),
   ["n|<leader>pi"] = map_cr("PackerInstall"):with_silent():with_noremap():with_nowait(),
   ["n|<leader>pc"] = map_cr("PackerCompile"):with_silent():with_noremap():with_nowait(),
   -- Lsp mapp work when insertenter and lsp start
   ["n|<leader>li"] = map_cr("LspInfo"):with_noremap():with_silent():with_nowait(),
   ["n|<leader>ll"] = map_cr("LspLog"):with_noremap():with_silent():with_nowait(),
   ["n|<leader>lr"] = map_cr("LspRestart"):with_noremap():with_silent():with_nowait(),
   ["n|<leader>lu"] = map_cr("LspUpdate"):with_noremap():with_silent():with_nowait(),
   ["n|<C-f>"] = map_cmd("<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>")
      :with_silent()
      :with_noremap()
      :with_nowait(),
   ["n|<C-b>"] = map_cmd("<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>")
      :with_silent()
      :with_noremap()
      :with_nowait(),
   ["n|<Leader>en"] = map_cr("Lspsaga diagnostic_jump_next"):with_noremap():with_silent(),
   ["n|<Leader>ep"] = map_cr("Lspsaga diagnostic_jump_prev"):with_noremap():with_silent(),
   ["n|[e"] = map_cr("Lspsaga diagnostic_jump_next"):with_noremap():with_silent(),
   ["n|]e"] = map_cr("Lspsaga diagnostic_jump_prev"):with_noremap():with_silent(),
   ["n|<Leader>K"] = map_cr("Lspsaga hover_doc"):with_noremap():with_silent(),
   ["n|<Leader>lga"] = map_cr("Lspsaga code_action"):with_noremap():with_silent(),
   ["v|<Leader>lga"] = map_cu("Lspsaga range_code_action"):with_noremap():with_silent(),
   ["n|<Leader>lgd"] = map_cr("Lspsaga preview_definition"):with_noremap():with_silent(),
   ["n|<Leader>lgD"] = map_cmd("<cmd>lua vim.lsp.buf.implementation()<CR>"):with_noremap():with_silent(),
   ["n|<Leader>lgs"] = map_cr("Lspsaga signature_help"):with_noremap():with_silent(),
   ["n|<Leader>lgr"] = map_cr("Lspsaga rename"):with_noremap():with_silent(),
   ["n|<Leader>lgh"] = map_cr("Lspsaga lsp_finder"):with_noremap():with_silent(),
   ["n|<Leader>lgt"] = map_cmd("<cmd>lua vim.lsp.buf.type_definition()<CR>"):with_noremap():with_silent(),
   ["n|<Leader>cw"] = map_cmd("<cmd>lua vim.lsp.buf.workspace_symbol()<CR>"):with_noremap():with_silent(),
   ["n|<Leader>ce"] = map_cr("Lspsaga show_line_diagnostics"):with_noremap():with_silent(),
   ["n|<Leader>ct"] = map_args "Template",
   ["n|<Leader>N"] = map_cu("DashboardNewFile"):with_noremap():with_silent(),
   -- Plugin nvim-tree
   ["n|<Leader>ft"] = map_cr("NvimTreeToggle"):with_noremap():with_silent(),
   ["n|<Leader>fo"] = map_cr("NvimTreeFindFile"):with_noremap():with_silent(),
   -- Plugin MarkdownPreview
   ["n|<Leader>om"] = map_cu("MarkdownPreview"):with_noremap():with_silent(),
   -- Plugin DadbodUI
   ["n|<Leader>od"] = map_cr("DBUIToggle"):with_noremap():with_silent(),
   -- Plugin Floaterm
   ["n|<Leader>lt"] = map_cu("Lspsaga open_floaterm"):with_noremap():with_silent(),
   ["t|<Leader>lc"] = map_cu([[<C-\><C-n>:Lspsaga close_floaterm<CR>]]):with_noremap():with_silent(),
   ["n|<Leader>gt"] = map_cu("Lspsaga open_floaterm lazygit"):with_noremap():with_silent(),
   ["n|<Leader>gn"] = map_cu("Neogit"):with_noremap():with_silent(),
   -- Far.vim
   ["n|<Leader>fz"] = map_cr("Farf"):with_noremap():with_silent(),
   ["v|<Leader>fz"] = map_cr("Farf"):with_noremap():with_silent(),
   -- Plugin Telescope
   ["n|<Leader>bb"] = map_cu("Telescope buffers"):with_noremap():with_silent(),
   ["n|<Leader>bo"] = map_cmd("<cmd>lua require('custom.bufonly').buf_only()<CR>"):with_noremap():with_silent(),
   ["n|<Localleader>n"] = map_cmd("<cmd>set number! relativenumber!<CR>"):with_noremap():with_silent(),
   ["n|<Leader>bc"] = map_cu("Telescope neoclip neoclip"):with_noremap():with_silent(),
   -- ["n|<Leader>bd"] = map_cr("bdelete"):with_noremap():with_silent(),
   ["n|<Leader>bd"] = map_cmd("lua require('core.utils').close_buffer()"):with_noremap():with_silent(),
   ["n|<Leader>bn"] = map_cr("BufferLineCycleNext"):with_noremap():with_silent(),
   ["n|<Leader>bp"] = map_cr("BufferLineCyclePrev"):with_noremap():with_silent(),
   ["n|<Leader>bf"] = map_cr("lua vim.lsp.buf.formatting()"):with_noremap():with_silent(),
   ["n|<Leader>fa"] = map_cu("DashboardFindWord"):with_noremap():with_silent(),
   ["n|<Leader>fb"] = map_cu("Telescope git_bcommits"):with_noremap():with_silent(),
   ["n|<Leader>fc"] = map_cu("Telescope git_commits"):with_noremap():with_silent(),
   ["n|<Leader>fd"] = map_cu("Telescope commands"):with_noremap():with_silent(),
   ["n|<Leader>fe"] = map_cu("Telescope file_browser"):with_noremap():with_silent(),
   ["n|<Leader>ff"] = map_cu("DashboardFindFile"):with_noremap():with_silent(),
   ["n|<Leader>fh"] = map_cu("Telescope help_tags"):with_noremap():with_silent(),
   ["n|<Leader>fgi"] = map_cu("Telescope git_files"):with_noremap():with_silent(),
   ["n|<Leader>fgo"] = map_cu("Telescope gosource"):with_noremap():with_silent(),
   ["n|<Leader>fl"] = map_cu("Telescope loclist"):with_noremap():with_silent(),
   ["n|<Leader>fk"] = map_cu("Telescope keymaps"):with_noremap():with_silent(),
   ["n|<Leader>fp"] = map_cu("Telescope project project"):with_noremap():with_silent(),
   ["n|<Leader>fq"] = map_cu("Telescope quickfix"):with_noremap():with_silent(),
   ["n|<Leader>fr"] = map_cu("Telescope oldfiles"):with_noremap():with_silent(),
   ["n|<Leader>fw"] = map_cu("Telescope grep_string"):with_noremap():with_silent(),
   ["n|<Leader><Leader>"] = map_cu("Telescope frecency frecency"):with_noremap():with_silent(),
   -- Plugin trouble
   ["n|<Leader>tf"] = map_cr("TroubleToggle"):with_noremap():with_silent(),
   ["n|<Leader>tR"] = map_cr("TroubleToggle lsp_references"):with_noremap():with_silent(),
   ["n|<leader>td"] = map_cr("TroubleToggle lsp_document_diagnostics"):with_noremap():with_silent(),
   ["n|<leader>tw"] = map_cr("TroubleToggle lsp_workspace_diagnostics"):with_noremap():with_silent(),
   ["n|<leader>tq"] = map_cr("TroubleToggle quickfix"):with_noremap():with_silent(),
   ["n|<leader>tl"] = map_cr("TroubleToggle loclist"):with_noremap():with_silent(),
   -- prodoc
   ["n|gcc"] = map_cu("ProComment"):with_noremap():with_silent(),
   ["x|gcc"] = map_cr "ProComment",
   ["n|<leader>cl"] = map_cu("CommentToggle"):with_noremap():with_silent(),
   ["x|<leader>cl"] = map_cr "CommentToggle",
   ["n|gcj"] = map_cu("ProDoc"):with_silent():with_silent(),
   ["n|<Leader>cj"] = map_cu("ProDoc"):with_silent():with_silent(),
   -- Plugin acceleratedjk
   ["n|j"] = map_cmd('v:lua.enhance_jk_move("j")'):with_silent():with_expr(),
   ["n|k"] = map_cmd('v:lua.enhance_jk_move("k")'):with_silent():with_expr(),
   -- Plugin QuickRun
   ["n|<Leader>r"] = map_cr("<cmd> lua require'internal.quickrun'.run_command()"):with_noremap():with_silent(),
   -- Plugin Vista
   -- ["n|<Leader>v"] = map_cu("SymbolsOutline"):with_noremap():with_silent(),
   ["n|<Leader>ta"] = map_cu("SymbolsOutline"):with_noremap():with_silent(),
   -- Plugin vim-operator-surround
   ["n|<leader>sa"] = map_cmd("<Plug>(operator-surround-append)"):with_silent(),
   ["n|<leader>sd"] = map_cmd("<Plug>(operator-surround-delete)"):with_silent(),
   ["n|<leader>sr"] = map_cmd("<Plug>(operator-surround-replace)"):with_silent(),

   ["n|<leader>tc"] = map_cmd(
      "<cmd>lua require('modules.themes').toggle_theme(require('core.utils').load_config().ui.theme_toggler.fav_themes) <CR>"
   ):with_silent(),
   ["n|<leader>tt"] = map_cu("Telescope themes"):with_silent(),
   ["n|<leader>zz"] = map_cu("TZAtaraxis"):with_silent(),
   ["n|<leader>zf"] = map_cu("TZFocus"):with_silent(),
   ["n|<leader>zm"] = map_cu("TZMinimalist"):with_silent(),
   -- Plugin hrsh7th/vim-eft
   ["n|f"] = map_cmd("v:lua.enhance_ft_move('f')"):with_expr(),
   ["x|f"] = map_cmd("v:lua.enhance_ft_move('f')"):with_expr(),
   ["o|f"] = map_cmd("v:lua.enhance_ft_move('f')"):with_expr(),
   ["n|F"] = map_cmd("v:lua.enhance_ft_move('F')"):with_expr(),
   ["x|F"] = map_cmd("v:lua.enhance_ft_move('F')"):with_expr(),
   ["o|F"] = map_cmd("v:lua.enhance_ft_move('F')"):with_expr(),
   -- Plugin vim_niceblock
   ["x|I"] = map_cmd("v:lua.enhance_nice_block('I')"):with_expr(),
   ["x|gI"] = map_cmd("v:lua.enhance_nice_block('gI')"):with_expr(),
   ["x|A"] = map_cmd("v:lua.enhance_nice_block('A')"):with_expr(),
   ["v|<M-A>c"] = map_cr('"+y'):with_noremap():with_silent(),
   ["n|<Leader>tg"] = map_cr("highlight Normal guibg=NONE ctermbg=None"):with_noremap():with_silent(),
   ["n|Q"] = map_cr "@@",
   ["n|q"] = map_cr "quit",
   ["v|<M-[>2;5+"] = map_cmd "y",
   ["n|<C-S-Insert>"] = map_cmd "<ESC>ggVG",
   ["i|<C-Insert>"] = map_cmd "<C-r>*",
   ["c|<C-Insert>"] = map_cmd "<C-r>*",
   ["n|<C-Insert>"] = map_cmd "P",
   ["v|<C-Insert>"] = map_cmd '"_dP',
}

bind.nvim_load_mapping(plug_map)
