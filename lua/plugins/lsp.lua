return {
	{
		"mason-org/mason.nvim",
		opts = {
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"clangd",
				"roslyn",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"nvim-telescope/telescope.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok_blink, blink = pcall(require, "blink.cmp")
			if ok_blink and blink.get_lsp_capabilities then
				capabilities = blink.get_lsp_capabilities(capabilities)
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspKeymaps", {}),
				callback = function(args)
					local bufnr = args.buf

					local function map(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, {
							buffer = bufnr,
							silent = true,
							noremap = true,
							desc = desc,
						})
					end

					-- MISC
					map("n", "K", vim.lsp.buf.hover, "LSP: hover")
					map("n", "<leader>R", ":LspRestart<CR>", "LSP: [R]estart")
					map("n", "<leader>ra", vim.lsp.buf.code_action, "LSP: Code [A]ction")
					map("n", "<leader>rf", function()
						vim.lsp.buf.format({ async = true })
					end, "LSP: Code [F]ormat")

					-- GO TO
					-- map("n", "gd", vim.lsp.buf.definition, "LSP: [G]o to [d]efinition")
					-- map("n", "gr", vim.lsp.buf.references, "LSP: [G]o to [r]eferences")

					-- REFACTORING
					map("n", "<leader>rr", vim.lsp.buf.rename, "LSP: [R]ename")

					local ok_telescope, tbuiltin = pcall(require, "telescope.builtin")
					if ok_telescope then
						map("n", "<leader>sd", tbuiltin.lsp_definitions, "LSP: [S]earch [D]efinitions")
						map("n", "<leader>sr", tbuiltin.lsp_references, "LSP: [S]earch [R]eferences")
						map("n", "<leader>si", tbuiltin.lsp_implementations, "LSP: [S]earch [I]mplementations")
						map("n", "<leader>sS", tbuiltin.lsp_document_symbols, "LSP: [S]earch buffer [S]ymbols")
						map(
							"n",
							"<leader>ss",
							tbuiltin.lsp_dynamic_workspace_symbols,
							"LSP: [S]earch workspace [S]ymbols"
						)
					end
				end,
			})

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				cmd = (vim.fn.has("unix") == 1 or vim.fn.has("linux") == 1) and { "lua-language-server" } or nil,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
			vim.lsp.enable("lua_ls")

			vim.lsp.config("clangd", {
				capabilities = capabilities,
			})

			vim.lsp.config("roslyn", {
				capabilities = capabilities,
			})
		end,
	},
}
