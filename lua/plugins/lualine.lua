return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Иконки файлов
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'auto', -- Или укажите конкретную: 'dracula', 'gruvbox', 'tokyonight'
          -- Разделители секций (стрелочки). Если квадратики вместо них - поставьте Nerd Font
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false, -- true = одна линия на все окна (рекомендуется)
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {'mode'}, -- Режим (NORMAL, INSERT)
          lualine_b = {'branch', 'diff', 'diagnostics'}, -- Git ветка, изменения, ошибки LSP
          lualine_c = {'filename'}, -- Имя файла
          lualine_x = {'encoding', 'fileformat', 'filetype'}, -- utf-8, unix, csharp
          lualine_y = {'progress'}, -- Процент прокрутки
          lualine_z = {'location'}  -- Номер строки:колонки
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        extensions = {'neo-tree', 'lazy'} -- Поддержка плагинов
      })
    end
  }
}