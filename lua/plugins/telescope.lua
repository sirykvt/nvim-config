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
			vim.cmd.edit(vim.fn.fnameescape(entry.path))
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
		opts = function()
			local themes = require("telescope.themes")

			-- Location lists (references, diagnostics, symbols) have long lines: give results the full width.
			local full_width = { layout_strategy = "vertical" }
			-- Plain lists without anything useful to preview.
			local list = { previewer = false, layout_config = { width = 0.6, height = 0.6 } }

			return {
				defaults = {
					prompt_prefix = "❯ ",
					selection_caret = "▍ ",
					entry_prefix = "  ",
					sorting_strategy = "ascending",
					layout_strategy = "flex",
					layout_config = {
						prompt_position = "top",
						width = 0.9,
						height = 0.85,
						flex = { flip_columns = 140 },
						horizontal = { preview_width = 0.55 },
						vertical = { mirror = true, preview_height = 0.45, preview_cutoff = 20 },
					},
					path_display = { "filename_first" },
					dynamic_preview_title = true,
					results_title = false,
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					mappings = {
						i = {
							["<CR>"] = open_handler,
						},
						n = {
							["<CR>"] = open_handler,
						},
					},
				},
				pickers = {
					-- Current buffer stays listed (no "No buffers found" with a single file), but the
					-- previous buffer is preselected, so <leader><leader><CR> switches back to it.
					buffers = { sort_mru = true, sort_lastused = true },
					current_buffer_fuzzy_find = { skip_empty_lines = true },
					keymaps = list,
					builtin = vim.tbl_extend("force", list, { include_extensions = true }),
					diagnostics = vim.tbl_extend("force", full_width, { line_width = "full" }),
					lsp_references = full_width,
					lsp_definitions = full_width,
					lsp_implementations = full_width,
					lsp_incoming_calls = full_width,
					lsp_outgoing_calls = full_width,
				},
				extensions = {
					["ui-select"] = themes.get_dropdown(),
				},
			}
		end,
		config = function(_, opts)
			require("telescope").setup(opts)

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help tags" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Keymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Files" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Grep" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "Recent files" })
			vim.keymap.set("n", "<leader>sb", builtin.builtin, { desc = "Telescope pickers" })
			vim.keymap.set("n", "<leader>sa", function()
				builtin.find_files({ hidden = true, no_ignore = true })
			end, { desc = "All files (incl. hidden and ignored)" })
			vim.keymap.set("n", "<leader>sR", builtin.resume, { desc = "Resume last search" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Buffers" })

			vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Search in buffer" })

			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "Neovim config files" })
		end,
	},
}
