local function open_handler(prompt_bufnr)
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local picker = action_state.get_current_picker(prompt_bufnr)
	local selections = picker:get_multi_selection()

	if vim.tbl_isempty(selections) then
		-- no multiselect → behave like normal <CR>
		return actions.select_default(prompt_bufnr)
	end

	-- multiselect detected → open all, then close Telescope
	actions.close(prompt_bufnr)

	for _, entry in ipairs(selections) do
		if entry.path ~= nil then
			vim.cmd("edit " .. entry.path)
		end
	end
end

return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
		opts = {
			defaults = {
				mappings = {
					i = {
						["<CR>"] = open_handler,
					},
					n = {
						["<CR>"] = open_handler,
					}
				},
			},
			extensions = {
				["ui-select"] = {},
			},
		},
		config = function(_, opts)
			require("telescope").setup(opts)

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search Help" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search Keymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search Files" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search by Grep" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = 'Search Recent Files' })
			vim.keymap.set("n", "<leader>sb", builtin.builtin, { desc = 'Search Telescope Builtins' })
			vim.keymap.set("n", "<leader>sa", builtin.resume, { desc = "Telescope Resume" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Search existing Buffers" })

			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "Fuzzily search in current Buffer" })

			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "Search Neovim" })
		end,
	},
}
