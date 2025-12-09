return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            open_mapping = [[<leader>`]],
            size = 30,
            close_on_exit = false,
            start_in_insert = true,
            insert_mappings = true,
            terminal_mappings = true,
            direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
            auto_scroll = true,
            float_opts = {
                border = 'single',
                -- width = 100,
                -- height = <value>,
                -- row = <value>,
                -- col = <value>,
                -- winblend = 3,
                -- zindex = <value>,
                title_pos = 'center'
            },
            on_open = function(term)
                vim.keymap.set("t", "<Esc><Esc>", "<cmd>ToggleTerm<CR>", {
                    buffer = term.bufnr,
                    noremap = true,
                    silent = true
                })
            end
        },
        keys = {
            { "<leader>`",  "<cmd>ToggleTerm<CR>",              desc = "Toggle Terminal" },
            { "<leader>tt", "<cmd>1ToggleTerm name=Common<CR>", desc = "Toggle Terminal [Common]" },
            { "<leader>tb", "<cmd>10ToggleTerm name=Build<CR>", desc = "Toggle Terminal [Build]" },
            { "<leader>tr", "<cmd>11ToggleTerm name=Run<CR>",   desc = "Toggle Terminal [Run]" }
        }
    }
}
