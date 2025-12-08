return {
	{
		"loctvl842/monokai-pro.nvim",
		priority = 1000,
		opts = {
			transparent_background = false,
			terminal_colors = true,
			devicons = true,
			filter = "spectrum",
			styles = {
				comment = { italic = false },
				keyword = { italic = false }, -- any other keyword
				type = { italic = false }, -- (preferred) int, long, char, etc
				storageclass = { italic = false }, -- static, register, volatile, etc
				structure = { italic = false }, -- struct, union, enum, etc
				parameter = { italic = false }, -- parameter pass in function
				annotation = { italic = false },
				tag_attribute = { italic = false }, -- attribute of tag in reactjs
			},
			plugins = {
				indent_blankline = { enabled = true },
				nvim_cmp = { enabled = true },
				notify = { enabled = true },
				telescope = { enabled = true },
				lualine = { enabled = true },
			},
		},
		config = function(_, opts)
			require("monokai-pro").setup(opts)
			vim.cmd([[colorscheme monokai-pro]])
		end,
	},
}

