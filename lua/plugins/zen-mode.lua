return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode", -- Плагин загрузится только при первой команде
    opts = {
      window = {
        backdrop = 0.95, -- Затемнение фона за пределами кода (от 0 до 1)
        width = 120,     -- Ширина окна с кодом (можно указать число или 0.60 для %)
        height = 1,      -- Высота окна (1 = во весь экран)
        
        options = {
          signcolumn = "no", -- Отключить колонку со значками (ошибки/git) слева
          number = true,     -- Оставить обычные номера строк
          relativenumber = true, -- Оставить относительные номера строк
          cursorline = true, -- Подсветка текущей строки
          cursorcolumn = false, -- Подсветка текущей колонки
          foldcolumn = "0",  -- Отключить колонку сворачивания кода
          list = false,      -- Скрыть спецсимволы (пробелы/табы)
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,   -- Скрыть линейку снизу
          showcmd = false, -- Скрыть набираемую команду
        },
        twilight = { enabled = true }, -- Интеграция с плагином Twilight (затемняет неактивный код)
        gitsigns = { enabled = false }, -- Скрыть Git полоски
        tmux = { enabled = false },     -- Если используете tmux
      },
    },
    -- Настройка горячей клавиши через Lazy
    keys = {
      { 
        "<leader>z", 
        "<cmd>ZenMode<cr>", 
        desc = "" 
      },
    },
  }
}