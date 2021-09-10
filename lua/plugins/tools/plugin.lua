local tools = {}
local conf = require "plugins.tools.config"

tools["kristijanhusak/vim-dadbod-ui"] = {
    cmd = {"DBUIToggle", "DBUIAddConnection", "DBUI", "DBUIFindBuffer", "DBUIRenameBuffer"},
    config = conf.vim_dadbod_ui,
    requires = {{"tpope/vim-dadbod", opt = true}}
}

tools["editorconfig/editorconfig-vim"] = {ft = {"go", "typescript", "javascript", "vim", "rust", "zig", "c", "cpp"}}

tools["glepnir/prodoc.nvim"] = {event = "BufReadPre"}

tools["brooth/far.vim"] = {
    cmd = {"Far", "Farp"},
    config = function()
        vim.g["far#source"] = "rg"
    end
}

tools["iamcco/markdown-preview.nvim"] = {
    ft = "markdown",
    config = function()
        vim.g.mkdp_auto_start = 0
    end
}
tools["AckslD/nvim-neoclip.lua"] = {
    config = function()
        require("neoclip").setup()
    end

}

tools["andymass/vim-matchup"] = {
    opt = true,
    setup = function()
        require("core.utils").packer_lazy_load "vim-matchup"
    end
}
tools["jdhao/better-escape.vim"] = {
    event = "InsertEnter",
    config = function()
        require("custom.others").better_escape()
    end,
    setup = function()
        vim.g.better_escape_shortcut = "jk"
    end
}

tools["terrortylor/nvim-comment"] = {
    cmd = "CommentToggle",
    config = function()
        require("custom.others").comment()
    end
}
return tools
