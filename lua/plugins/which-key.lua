return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			icons = {
				mappings = false,
			},
			spec = {
				{ "<leader>s", group = "Search" },
				{ "<leader>r", group = "Code" },
				{ "<leader>e", group = "Diagnostics" },
				{ "<leader>n", group = "LSP navigation" },
				{ "<leader>p", group = "Tasks" },
				{ "<leader>t", group = "Terminal" },
				{ "<leader>y", group = "Copy path" },
				{ "<leader>x", group = "Toggles and tools" },
				{ "<leader>S", group = "Sessions" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer-local keymaps",
			},
		},
	},
}

