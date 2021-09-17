local M = {
    opt = true,
    requires = "feline.nvim"
}

M.setup = function ()
    vim.g.indentLine_concealcursor = 'inc'
    vim.g.indentLine_conceallevel = 2
    vim.g.indentLine_char_list = {'|', '¦', '┆', '┊'}
end

return M
