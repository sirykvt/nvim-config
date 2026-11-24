return {
	"rmagatti/auto-session",
	lazy = false,
	keys = {
		{ "<leader>Sl", "<cmd>AutoSession search<CR>", desc = "Search sessions" },
		{ "<leader>Ss", "<cmd>AutoSession save<CR>",   desc = "Save session" },
		{ "<leader>St", "<cmd>AutoSession toggle<CR>", desc = "Toggle session autosave" },
	},
	opts = {
		session_lens = {
			mappings = {
				delete_session = { "i", "<C-d>" },
				alternate_session = { "i", "<C-s>" },
				copy_session = { "i", "<C-y>" },
			},
			picker_opts = {
				-- For Telescope, you can set theme options here, see:
				-- https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt#L112
				-- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/themes.lua
				--
				-- border = true,
				-- layout_config = {
				--   width = 0.8, -- Can set width and height as percent of window
				--   height = 0.5,
				-- },
			},
			load_on_setup = true,
		},
	},
}
