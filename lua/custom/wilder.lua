local M = {
   event = "CmdlineEnter",
   run = ":UpdateRemotePlugins",
   requires = { { "romgrk/fzy-lua-native", after = "wilder.nvim" } },
}

M.config = function()
   vim.cmd [[call wilder#setup({'modes': [':', '/', '?']})]]
   vim.cmd [[call wilder#set_option('use_python_remote_plugin', 0)]]
   vim.cmd [[call wilder#set_option('pipeline', [wilder#branch(wilder#cmdline_pipeline({'use_python': 0,'fuzzy': 1, 'fuzzy_filter': wilder#lua_fzy_filter()}),wilder#vim_search_pipeline(), [wilder#check({_, x -> empty(x)}), wilder#history(), wilder#result({'draw': [{_, x -> ' ' . x}]})])])]]
   vim.cmd [[call wilder#set_option('renderer', wilder#renderer_mux({':': wilder#popupmenu_renderer(wilder#popupmenu_border_theme({'highlighter': wilder#lua_fzy_highlighter(), 'left': [' ', wilder#popupmenu_devicons()], 'right': [' ', wilder#popupmenu_scrollbar()], 'highlights': {'accent': wilder#make_hl('WiderAccent', 'Pmenu', [{}, {}, {'foreground': '#f4468f'}])}, 'border': 'rounded', 'max_height': '20%', 'reverse': 0})), '/': wilder#wildmenu_renderer({'highlighter': wilder#lua_fzy_highlighter()})}))]]
end

return M
