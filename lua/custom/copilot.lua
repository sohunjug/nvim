local M = { opt = true, event = "BufRead" }

M.config = function()
   vim.g.copilot_no_tab_map = true
end

return M
