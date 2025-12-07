return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Автоматически обновлять парсеры при установке
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        -- Список языков для автоматической установки
        ensure_installed = { 
          "c_sharp", -- Парсер для C#
          "lua",     -- Для конфигов Neovim
          "vim", 
          "vimdoc", 
          "query",   -- Для отладки самого treesitter
          "json",    -- Полезно для .json файлов настроек
          "xml"      -- Полезно для .csproj файлов
        },

        -- Установка синхронно (true) или асинхронно (false)
        sync_install = false,

        -- Автоматически устанавливать отсутствующие парсеры при открытии файла
        auto_install = true,

        -- Включение подсветки
        highlight = {
          enable = true, -- Обязательно включить
          
          -- Отключить стандартную regex-подсветку vim для языков, где есть treesitter
          additional_vim_regex_highlighting = false,
        },

        -- Умные отступы (экспериментально, но для C# работает неплохо)
        indent = { enable = true },
      })
    end
  }
}