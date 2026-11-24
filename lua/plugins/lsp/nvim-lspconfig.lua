local function on_lsp_attach(args)
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, {
			buffer = args.buf,
			silent = true,
			noremap = true,
			desc = desc,
		})
	end

	-- Misc.
	map("n", "<leader>xr", "<cmd>LspRestart<CR>", "Restart LSP")
	map("n", "<leader>xl", "<cmd>LspInfo<CR>", "LSP info")

	-- Diagnostics.
	map("n", "<leader>ee", vim.diagnostic.open_float, "Line diagnostics")
	map("n", "<leader>xh", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }), { bufnr = args.buf })
	end, "Toggle inlay hints")

	-- Go to.
	map("n", "gd", vim.lsp.buf.definition, "Go to definition")
	map("n", "<CR>", vim.lsp.buf.definition, "Go to definition")
	map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
	map("n", "gK", vim.lsp.buf.signature_help, "Signature help")
	-- map("n", "gr", vim.lsp.buf.references, "Go to References")

	local client = vim.lsp.get_client_by_id(args.data.client_id)
	if client and client.name == "clangd" then
		map("n", "<leader>q", "<cmd>LspClangdSwitchSourceHeader<CR>", "Switch source/header")
	end

	-- Refactoring.
	map("n", "<leader>rr", vim.lsp.buf.rename, "Rename")
	map("n", "<leader>ra", vim.lsp.buf.code_action, "Code action")
	map({ "n", "x" }, "<leader>rf",
		function()
			vim.lsp.buf.format({ async = true })
		end,
		"Format"
	)

	-- Search.
	local ok_telescope, tbuiltin = pcall(require, "telescope.builtin")
	if ok_telescope then
		map("n", "<leader>el", function()
			tbuiltin.diagnostics({ bufnr = 0 })
		end, "Buffer diagnostics")
		map("n", "<leader>eL", tbuiltin.diagnostics, "Workspace diagnostics")
		map("n", "<leader>nd", tbuiltin.lsp_definitions, "Definitions")
		map("n", "<leader>nr", tbuiltin.lsp_references, "References")
		map("n", "<leader>ni", tbuiltin.lsp_implementations, "Implementations")
		map("n", "<leader>nc", tbuiltin.lsp_incoming_calls, "Incoming calls")
		map("n", "<leader>nC", tbuiltin.lsp_outgoing_calls, "Outgoing calls")
		local symbol_pickers = require("lsp_symbol_pickers")
		map("n", "<leader>ss", symbol_pickers.document_symbols, "File symbols")
		map("n", "<leader>sS", function()
			symbol_pickers.project_symbols()
		end, "Project symbols")
		map("n", "<leader>sc", function()
			symbol_pickers.project_symbols({ "Class", "Struct" })
		end, "Project classes and structs")
	end
end

-- Capabilities are injected by blink.cmp via vim.lsp.config("*"); servers listed in mason-lspconfig's
-- ensure_installed are enabled by it automatically.
local function configure_lua()
	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				telemetry = {
					enable = false,
				},
			},
		},
	})
end

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"nvim-telescope/telescope.nvim",
			"j-hui/fidget.nvim",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspKeymaps", {}),
				callback = on_lsp_attach
			})

			vim.diagnostic.config({
				virtual_text = { source = true },
				signs = true,
				underline = true,
				update_in_insert = false,
			})

			configure_lua()
		end,
	},
}
