local M = {}

M.close_buffer = function(bufexpr, force)
    -- This is a modification of a NeoVim plugin from
    -- Author: ojroques - Olivier Roques
    -- Src: https://github.com/ojroques/nvim-bufdel
    -- (Author has okayed copy-paste)

    -- Options
    local opts = {
        next = "cycle", -- how to retrieve the next buffer
        quit = false -- exit when last buffer is deleted
        -- TODO make this a chadrc flag/option
    }

    -- ----------------
    -- Helper functions
    -- ----------------

    -- Switch to buffer 'buf' on each window from list 'windows'
    local function switch_buffer(windows, buf)
        local cur_win = vim.fn.winnr()
        for _, winid in ipairs(windows) do
            vim.cmd(string.format("%d wincmd w", vim.fn.win_id2win(winid)))
            vim.cmd(string.format("buffer %d", buf))
        end
        vim.cmd(string.format("%d wincmd w", cur_win)) -- return to original window
    end

    -- Select the first buffer with a number greater than given buffer
    local function get_next_buf(buf)
        local next = vim.fn.bufnr "#"
        if opts.next == "alternate" and vim.fn.buflisted(next) == 1 then return next end
        for i = 0, vim.fn.bufnr "$" - 1 do
            next = (buf + i) % vim.fn.bufnr "$" + 1 -- will loop back to 1
            if vim.fn.buflisted(next) == 1 then return next end
        end
    end

    -- ----------------
    -- End helper functions
    -- ----------------

    local buf = vim.fn.bufnr()
    if vim.fn.buflisted(buf) == 0 then -- exit if buffer number is invalid
        vim.cmd "close"
        return
    end

    if #vim.fn.getbufinfo {buflisted = 1} < 2 then
        if opts.quit then
            -- exit when there is only one buffer left
            if force then
                vim.cmd "qall!"
            else
                vim.cmd "confirm qall"
            end
            return
        end

        local chad_term, type = pcall(function()
            return vim.api.nvim_buf_get_var(buf, "term_type")
        end)

        if chad_term then
            -- Must be a window type
            vim.cmd(string.format("setlocal nobl", buf))
            vim.cmd "enew"
            return
        end
        -- don't exit and create a new empty buffer
        vim.cmd "enew"
        vim.cmd "bp"
    end

    local next_buf = get_next_buf(buf)
    local windows = vim.fn.getbufinfo(buf)[1].windows

    -- force deletion of terminal buffers to avoid the prompt
    if force or vim.fn.getbufvar(buf, "&buftype") == "terminal" then
        local chad_term, type = pcall(function()
            return vim.api.nvim_buf_get_var(buf, "term_type")
        end)

        -- TODO this scope is error prone, make resilient
        if chad_term then
            if type == "wind" then
                -- hide from bufferline
                vim.cmd(string.format("%d bufdo setlocal nobl", buf))
                -- swtich to another buff
                -- TODO switch to next bufffer, this works too
                vim.cmd "BufferLineCycleNext"
            else
                local cur_win = vim.fn.winnr()
                -- we can close this window
                vim.cmd(string.format("%d wincmd c", cur_win))
                return
            end
        else
            switch_buffer(windows, next_buf)
            vim.cmd(string.format("bd! %d", buf))
        end
    else
        switch_buffer(windows, next_buf)
        vim.cmd(string.format("silent! confirm bd %d", buf))
    end
    -- revert buffer switches if user has canceled deletion
    if vim.fn.buflisted(buf) == 1 then switch_buffer(windows, buf) end
end

-- hide statusline
-- tables fetched from load_config function
M.hide_statusline = function()
    local hidden = require("core.utils").load_config().ui.plugin.statusline.hidden
    local shown = require("core.utils").load_config().ui.plugin.statusline.shown
    local api = vim.api
    local buftype = api.nvim_buf_get_option("%", "ft")

    -- shown table from config has the highest priority
    if vim.tbl_contains(shown, buftype) then
        api.nvim_set_option("laststatus", 2)
        return
    end

    if vim.tbl_contains(hidden, buftype) then
        api.nvim_set_option("laststatus", 0)
        return
    else
        api.nvim_set_option("laststatus", 2)
    end
end

-- Base code: https://gist.github.com/revolucas/184aec7998a6be5d2f61b984fac1d7f7
-- Changes over it: preserving table 1 contents and also update with table b, without duplicating
-- 1st arg - base table
-- 2nd arg - table to merge
-- 3rg arg - list of nodes as a table, if the node is found replace the from table2 to result, rather than adding the value
-- e.g: merge_table(t1, t2, { ['plugin']['truezen']['mappings'] })
M.merge_table = function(into, from, nodes_to_replace)
    -- make sure both are table
    if type(into) ~= "table" or type(from) ~= "table" then return into end

    local stack, seen = {}, {}
    local table1, table2 = into, from

    if type(nodes_to_replace) == "table" then
        -- function that will be executed with loadstring
        local base_fn = [[
return function(table1, table2)
   local t1, t2 = table1_node or false , table2_node or false
   if t1 and t2 then
      table1_node = table2_node
   end
   return table1
end]]
        for _, node in ipairs(nodes_to_replace) do
            -- replace the _node in base_fn to actual given node value
            local fn = base_fn:gsub("_node", node)
            -- if the node if found, it is replaced, otherwise table 1 is returned
            table1 = loadstring(fn)()(table1, table2)
        end
    end

    while true do
        for k, v in pairs(table2) do
            if type(v) == "table" and type(table1[k]) == "table" then
                table.insert(stack, {table1[k], table2[k]})
            else
                local present = seen[v] or false
                if not present then
                    if type(k) == "number" then
                        -- add the value to seen table until value is found
                        -- only do when key is number we just want to append to subtables
                        -- todo: maybe improve this

                        for _, value in pairs(table1) do
                            if value == v then
                                present = true
                                break
                            end
                        end
                        seen[v] = true
                        if not present then table1[#table1 + 1] = v end
                    else
                        table1[k] = v
                    end
                end
            end
        end
        if #stack > 0 then
            local t = stack[#stack]
            table1, table2 = t[1], t[2]
            stack[#stack] = nil
        else
            break
        end
    end
    return into
end

-- load plugin after entering vim ui
M.packer_lazy_load = function(plugin, timer)
    if plugin then
        timer = timer or 0
        vim.defer_fn(function()
            require("packer").loader(plugin)
        end, timer)
    end
end

return M
