return {
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				-- Regex support for variable/placeholder transformations in LSP snippets.
				build = "make install_jsregexp",
				opts = {},
			},
			"folke/lazydev.nvim",
		},
		opts = {
			-- super-tab: <Tab> accepts the selected item (or jumps to the next snippet field),
			-- <S-Tab> jumps back, <C-n>/<C-p> select, <C-e> cancels, <C-k> toggles signature help.
			-- See :h blink-cmp-config-keymap.
			keymap = {
				preset = "super-tab",
				-- Same as <C-space>, which macOS takes for switching input sources.
				["<C-l>"] = { "show", "show_documentation", "hide_documentation" },
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				-- Moving through the list only highlights an item; text is inserted on <Tab>.
				list = { selection = { auto_insert = false } },
				-- By default, you may press `<c-space>` to show the documentation.
				-- Optionally, set `auto_show = true` to show the documentation after a delay.
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},

			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},

			snippets = { preset = "luasnip" },

			-- Rust matcher (prebuilt binary is downloaded for the tagged release); falls back to Lua with a warning.
			fuzzy = { implementation = "prefer_rust_with_warning" },

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
	},
}
