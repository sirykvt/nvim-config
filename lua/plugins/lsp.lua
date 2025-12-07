return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      -- 1. Настройка Mason (установка серверов)
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "omnisharp" },
      })

      -- 2. Настройка клавиш при подключении LSP (LspAttach)
      -- В Neovim 0.11 это делается через автокоманду, а не функцию on_attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local opts = { buffer = event.buf, noremap = true, silent = true }

          local builtin = require('telescope.builtin')
          vim.keymap.set('n', 'gr', builtin.lsp_references, opts)
        end,
      })

      -- 3. Получаем capabilities для автодополнения
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- 4. НОВАЯ КОНФИГУРАЦИЯ (вместо lspconfig.setup)
      -- Используем vim.lsp.config для настройки и vim.lsp.enable для активации
      
      -- Настройка для C# (Omnisharp)
      vim.lsp.config('omnisharp', {
        capabilities = capabilities,
        enable_roslyn_analyzers = true,
        organize_imports_on_format = true,
        enable_import_completion = true,
      })
      vim.lsp.enable('omnisharp')

      -- 5. Настройка автодополнения (cmp) - без изменений
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        })
      })
    end
  }
}