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
				{ "<leader>t", group = "Tasks" },
				{ "<leader>y", group = "Copy path" },
				{ "<leader>x", group = "System" },
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

