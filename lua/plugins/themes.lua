return {
    -- {
    --     "navarasu/onedark.nvim",
    --     priority = 1000, -- make sure to load this before all the other start plugins
    --     config = function()
    --         require('onedark').setup {
    --             style = 'warmer'
    --         }
    --         require('onedark').load()
    --     end
    -- }

    -- {
    --     "ellisonleao/gruvbox.nvim",
    --     priority = 1000, -- Загрузить эту тему первой, до остальных плагинов
    --     config = function()
    --         require("gruvbox").setup({
    --             terminal_colors = true,
    --             undercurl = true,
    --             underline = true,
    --             bold = true,
    --             italic = {
    --             strings = true,
    --             comments = true,
    --             operators = false,
    --             folds = true,
    --             },
    --             strikethrough = true,
    --             invert_selection = false,
    --             invert_signs = false,
    --             invert_tabline = false,
    --             invert_intend_guides = false,
    --             inverse = true, -- Инвертировать цвета для поиска, выделения и т.д.
    --             contrast = "hard", -- Варианты: "soft", "medium", "hard" (самый темный фон)
    --             palette_overrides = {},
    --             overrides = {},
    --             dim_inactive = false,
    --             transparent_mode = false, -- Поставьте true, если хотите прозрачный фон
    --         })

    --         -- Команда, которая собственно включает тему
    --         vim.cmd("colorscheme gruvbox")
    --     end,
    -- }

    {
        "loctvl842/monokai-pro.nvim",
        priority = 1000, -- Загружать тему первой
        config = function()
        require("monokai-pro").setup({
            transparent_background = false, -- true, если нужен прозрачный фон
            terminal_colors = true,
            devicons = true, -- Подсветка иконок файлов
            
            -- Самая интересная настройка - фильтры. 
            -- Варианты: "classic", "octagon", "pro", "machine", "ristretto", "spectrum"
            filter = "spectrum", 
            
            styles = {
                comment = { italic = false },
                keyword = { italic = false }, -- Ключевые слова (public, class) курсивом
                type = { bold = false },      -- Типы данных жирным
            },
            
            -- Настройка цветов для плагинов
            plugins = {
                indent_blankline = { enabled = true },
                nvim_cmp = { enabled = true },
                notify = { enabled = true },
                telescope = { enabled = true },
                lualine = { enabled = true },
            },
        })

        -- Активация темы
        vim.cmd("colorscheme monokai-pro")
        end,
    }
}