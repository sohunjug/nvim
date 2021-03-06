local vim = vim
local M = {}

function M.nvim_create_augroups(definitions)
   for group_name, definition in pairs(definitions) do
      vim.api.nvim_command("augroup " .. group_name)
      vim.api.nvim_command "autocmd!"
      for _, def in ipairs(definition) do
         local command = table.concat(vim.tbl_flatten { "autocmd", def }, " ")
         vim.api.nvim_command(command)
      end
      vim.api.nvim_command "augroup END"
   end
end

function M.load_autocmds()
   local definitions = {

      syntaxset = {
         { "FileType", "*", "exe", '"set syntax="', ".", "expand('<amatch>')" },
      },

      color = { { "ColorScheme", "*", "highlight NotifyBG guibg=#3d3d3d guifg=#3e4451" } },

      packer = { { "BufWritePost", "plugin.lua", "lua require('core.plugins').auto_compile()" } },

      bufs = {
         { "DirChanged", "*", "let &titlestring=v:event['cwd']" },
         -- Reload vim config automatically
         { "BufWritePost", [[$VIM_PATH/{*.vim,*.yaml,vimrc,*.lua} nested source $MYVIMRC | redraw]] },
         -- Reload Vim script atomatically if setlocal autoread
         {
            "BufWritePost,FileWritePost",
            "*.vim",
            [[nested if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif]],
         },
         { "BufWritePre", "/tmp/*", "setlocal noundofile" },
         { "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
         { "BufWritePre", "MERGE_MSG", "setlocal noundofile" },
         { "BufWritePre", "*.tmp", "setlocal noundofile" },
         { "BufWritePre", "*.bak", "setlocal noundofile" },
         -- { "BufWritePre", "*.tsx", "lua vim.api.nvim_command('Format')" },
         -- { "BufWritePre", "*.go", "lua require('go.format').goimport()" },
         { "BufReadPost", "*.go", [[set list lcs=tab:\|\ ]] },
         { "BufReadPost", "*.kkf2", [[ set filetype=lua ]] },
         -- { "InsertLeave", "*", 'require"gitsigns".start_signcolumn_updates()' },
         -- { "InsertEnter", "*", 'require"gitsigns".pause_signcolumn_updates()' },
      },
      remember = {
         { "BufReadPost", "*", [[ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]] },
      },
      term = { { "TermOpen", "term://*", "setlocal nonumber norelativenumber | setfiletype terminal" } },
      number = {
         -- {"InsertEnter","*", "set nornu | set nu"},
         -- {"InsertLeave", "*","set rnu | set nonu"},
         { "InsertLeave", "*", "set rnu! | set nu!" },
         { "InsertEnter", "*", "set rnu! | set nu!" },
      },

      wins = {
         -- Highlight current line only on focused window
         {
            "WinEnter,BufEnter,InsertLeave",
            "*",
            [[if ! &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal cursorline | endif]],
         },
         {
            "WinLeave,BufLeave,InsertEnter",
            "*",
            [[if &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal nocursorline | endif]],
         }, -- Equalize window dimensions when resizing vim window
         { "VimResized", "*", [[tabdo wincmd =]] }, -- Force write shada on leaving nvim
         { "VimLeave", "*", [[if has('nvim') | wshada! | else | wviminfo! | endif]] },
         -- Check if file changed when its window is focus, more eager than 'autoread'
         { "FocusGained", "* checktime" },
      },

      ft = {
         { "FileType", "dashboard", "set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2" },
         { "BufNewFile,BufRead", "*.toml", " setf toml" },
      },

      -- yank = { { "TextYankPost", [[* silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=400})]] } },
   }

   M.nvim_create_augroups(definitions)
end

M.setup = function()
   M.load_autocmds()
end

return M
