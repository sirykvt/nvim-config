return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8', -- Или branch = '0.1.x',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons' -- Опционально, для иконок
    },
    config = function()
      local builtin = require('telescope.builtin')

      -- Базовые шорткаты
      -- <Leader> (обычно пробел) + ...
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope Find Files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope Live Grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope Buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope Help' })
      
      -- Настройка внешнего вида (опционально)
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = { 
            "bin", "obj", ".git", ".vs" -- Игнорировать мусорные папки C#
          }, 
          -- layout_strategy = 'horizontal', -- Можно менять раскладку окна
        }
      })
    end
  }
}