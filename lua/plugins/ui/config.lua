local config = {}

function config.galaxyline()
    require('plugins.ui.eviline')
end

function config.nvim_bufferline()
    require('bufferline').setup {
        options = {modified_icon = '✥', buffer_close_icon = '', always_show_bufferline = false}
    }
end

function config.dashboard()
    local home = os.getenv('HOME')
    vim.g.dashboard_footer_icon = '🐬 '
    vim.g.dashboard_preview_command = 'cat'
    vim.g.dashboard_preview_pipeline = 'lolcat -F 0.3'
    vim.g.dashboard_preview_file = home .. '/.config/nvim/static/neovim.cat'
    vim.g.dashboard_preview_file_height = 12
    vim.g.dashboard_preview_file_width = 80
    vim.g.dashboard_default_executive = 'telescope'
    vim.g.dashboard_custom_section = {
        last_session = {description = {'  Recently laset session                  SPC s l'}, command = 'SessionLoad'},
        find_history = {
            description = {'  Recently opened files                   SPC f h'},
            command = 'DashboardFindHistory'
        },
        find_file = {
            description = {'  Find  File                              SPC f f'},
            command = 'Telescope find_files find_command=rg,--hidden,--files'
        },
        new_file = {
            description = {'  File Browser                            SPC f b'},
            command = 'Telescope file_browser'
        },
        find_word = {
            description = {'  Find  word                              SPC f w'},
            command = 'DashboardFindWord'
        },
        find_dotfiles = {
            description = {'  Open Personal dotfiles                  SPC f d'},
            command = 'Telescope dotfiles path=' .. home .. '/.dotfiles'
        },
        quit = {description = {'  Quit                                    SPC f d'}, command = 'quit'},
        go_source = {
            description = {'  Find Go Source Code                     SPC f s'},
            command = 'Telescope gosource'
        }
    }
end

function config.nvim_tree()
    -- On Ready Event for Lazy Loading work
    require("nvim-tree.events").on_nvim_tree_ready(function()
        vim.cmd("NvimTreeRefresh")
    end)
    require("custom.nvimtree")
end

function config.gitsigns()
    if not packer_plugins['plenary.nvim'].loaded then vim.cmd [[packadd plenary.nvim]] end
    require('gitsigns').setup {require("custom.gitsigns")}
end

function config.indent_blakline()
    vim.g.indent_blankline_char = "│"
    vim.g.indent_blankline_show_first_indent_level = true
    vim.g.indent_blankline_filetype_exclude = {
        "startify", "dashboard", "dotooagenda", "log", "fugitive", "gitcommit", "packer", "vimwiki", "markdown", "json",
        "txt", "vista", "help", "todoist", "NvimTree", "peekaboo", "git", "TelescopePrompt", "undotree",
        "flutterToolsOutline", "" -- for all buffers without a file type
    }
    vim.g.indent_blankline_buftype_exclude = {"terminal", "nofile"}
    vim.g.indent_blankline_show_trailing_blankline_indent = false
    vim.g.indent_blankline_show_current_context = true
    vim.g.indent_blankline_context_patterns = {
        "class", "function", "method", "block", "list_literal", "selector", "^if", "^table", "if_statement", "while",
        "for"
    }
    -- because lazy load indent-blankline so need readd this autocmd
    vim.cmd('autocmd CursorMoved * IndentBlanklineRefresh')
end

return config
