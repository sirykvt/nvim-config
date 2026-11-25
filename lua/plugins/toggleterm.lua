return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            size = 30,
            close_on_exit = false,
            start_in_insert = true,
            direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
            auto_scroll = true,
            -- Borderless full-screen float that keeps the statusline and command line visible.
            -- Functions are re-evaluated on every open, so the size follows window resizes.
            float_opts = {
                border = "none",
                row = 0,
                col = 0,
                width = function()
                    return vim.o.columns
                end,
                height = function()
                    local statusline = vim.o.laststatus > 0 and 1 or 0
                    return vim.o.lines - vim.o.cmdheight - statusline
                end,
            },
            on_open = function(term)
                -- Terminal, normal and visual mode alike, so the terminal hides from any state.
                vim.keymap.set({ "t", "n", "x" }, "<Esc><Esc>", function()
                    vim.cmd("stopinsert")
                    term:close()
                end, {
                    buffer = term.bufnr,
                    silent = true,
                    desc = "Hide terminal",
                })
            end
        },
        keys = {
            { "<leader>`", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
        }
    }
}
