local M = {}
local function bind_option(options)
   for k, v in pairs(options) do
      --[[if v == true or v == false then
         vim.cmd("set " .. k)
      else
         vim.cmd("set " .. k .. "=" .. v)
      end]]
      vim.opt[k] = v
   end
end

M.load_options = function()
   local global_local = {
      -- font = "Fira Code Mono:h13",
      -- guifont = "FiraCode Nerd Font:h12",
      -- font = "FiraCode Nerd Font:h12",
      -- macligatures = "",
      termguicolors = true,
      mouse = "nvi",
      cursorline = true,
      errorbells = true,
      visualbell = true,
      hidden = true,
      fileformats = "unix,mac,dos",
      magic = true,
      virtualedit = "block",
      encoding = "utf-8",
      viewoptions = "folds,cursor,curdir,slash,unix",
      sessionoptions = "blank,buffers,curdir,folds,help,options,tabpages,winsize,resize,winpos",
      clipboard = "unnamedplus",
      wildignorecase = true,
      -- wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**",
      wildignore = {
         "*.o",
         "*.a",
         "*.out",
         "*.class",
         "*.mo",
         "*.la",
         "*.so",
         "*.obj",
         "*.swp",
         ".tern-port",
         "*.tmp",
         "*.jpg",
         "*.jpeg",
         "*.png",
         "*.xpm",
         "*.gif",
         "*.bmp",
         "*.ico",
         "*.pyc",
         "*.zip",
         ".git",
         ".hg",
         ".svn",
         "CVS",
         "**/node_modules/**",
         "**/bower_modules/**",
         "**/tmp/**",
         "package-lock.json",
         "yarn.lock",
         "composer.lock",
         "DS_Store",
      },
      backup = false,
      writebackup = false,
      swapfile = false,
      directory = S_NVIM.cache_dir .. "swag/",
      undodir = S_NVIM.cache_dir .. "undo/",
      backupdir = S_NVIM.cache_dir .. "backup/",
      viewdir = S_NVIM.cache_dir .. "view/",
      spellfile = S_NVIM.cache_dir .. "spell/en.uft-8.add",
      history = 2000,
      shada = "!,'300,<50,@100,s10,h",
      backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim",
      smarttab = true,
      shiftround = true,
      timeout = true,
      ttimeout = true,
      timeoutlen = 500,
      ttimeoutlen = 10,
      updatetime = 100,
      redrawtime = 1500,
      ignorecase = true,
      smartcase = true,
      infercase = true,
      incsearch = true,
      wrapscan = true,
      complete = ".,w,b,k",
      inccommand = "nosplit",
      grepformat = "%f:%l:%c:%m",
      grepprg = "rg --hidden --vimgrep --smart-case --",
      breakat = [[\ \	;:,!?]],
      startofline = false,
      whichwrap = "h,l,<,>,[,],~",
      splitbelow = true,
      splitright = true,
      switchbuf = "useopen",
      backspace = "indent,eol,start",
      diffopt = "filler,iwhite,internal,algorithm:patience",
      completeopt = "menu,menuone,noselect",
      jumpoptions = "stack",
      showmode = false,
      shortmess = "aoOTIcF",
      scrolloff = 2,
      sidescrolloff = 5,
      foldlevelstart = 99,
      ruler = false,
      list = true,
      showtabline = 2,
      winwidth = 30,
      winminwidth = 10,
      pumheight = 15,
      helpheight = 12,
      previewheight = 12,
      showcmd = false,
      cmdheight = 2,
      cmdwinheight = 5,
      equalalways = false,
      laststatus = 2,
      display = "lastline",
      showbreak = "↳  ",
      listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←",
      pumblend = 10,
      winblend = 10,
      cul = true,
      fillchars = { eob = " " },
   }

   --[[ vim.opt.formatoptions = vim.opt.formatoptions
      - "a" -- Auto formatting is BAD.
      - "t" -- Don't auto format my code. I got linters for that.
      + "c" -- In general, I like it when comments respect textwidth
      + "q" -- Allow formatting comments w/ gq
      - "o" -- O and o, don't continue comments
      - "r" -- Don't insert comment after <Enter>
      + "n" -- Indent past the formatlistpat, not underneath it.
      + "j" -- Auto-remove comments if possible.
      - "2" -- I'm not in gradeschool anymore ]]

   if vim.fn.has "gui" then
      vim.g.guifont = "FiraCode Nerd Mono:h12"
   end

   local bw_local = {
      undofile = true,
      synmaxcol = 2500,
      formatoptions = "1jcroql",
      textwidth = 80,
      expandtab = true,
      autoindent = true,
      tabstop = 2,
      shiftwidth = 2,
      softtabstop = -1,
      breakindentopt = "shift:2,min:20",
      wrap = false,
      linebreak = true,
      relativenumber = true,
      number = false,
      colorcolumn = "120",
      foldenable = true,
      signcolumn = "yes",
      conceallevel = 2,
      concealcursor = "niv",
   }

   if S_NVIM.is_mac then
      vim.g.clipboard = {
         name = "macOS-clipboard",
         copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
         paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
         cache_enabled = 0,
      }
      local asdf = S_NVIM.home .. ".asdf/shims/python3"
      if vim.fn.executable(asdf) then
         vim.g.python3_host_prog = asdf
      else
         vim.g.python3_host_prog = "/usr/local/bin/python3"
      end
   end
   for name, value in pairs(global_local) do
      vim.opt[name] = value
   end
   bind_option(bw_local)

   vim.g.mapleader = " "
   vim.g.maplocalleader = ","

   vim.g.vsnip_snippet_dir = S_NVIM.home .. ".config/nvim/snippets"

   vim.api.nvim_set_keymap("n", " ", "", { noremap = true })
   vim.api.nvim_set_keymap("x", " ", "", { noremap = true })

   -- vim.cmd [[filetype plugin indent on]]

   -- disable some builtin vim plugins
   local disabled_built_ins = {
      "2html_plugin",
      "getscript",
      "getscriptPlugin",
      "gzip",
      "logiPat",
      "netrw",
      "netrwPlugin",
      "netrwSettings",
      "netrwFileHandlers",
      "matchit",
      "matchparen",
      "tar",
      "tarPlugin",
      "rrhelper",
      "spellfile_plugin",
      "vimball",
      "vimballPlugin",
      "zip",
      "zipPlugin",
   }

   for _, plugin in pairs(disabled_built_ins) do
      vim.g["loaded_" .. plugin] = 1
   end
end

M.setup = function()
   M.load_options()
end

return M
