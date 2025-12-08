return {
	{
		"mason-org/mason.nvim",
		opts = {},
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
				"csharp_ls",
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

					map("n", "K", vim.lsp.buf.hover, "LSP: hover")
					map("n", "gd", vim.lsp.buf.definition, "LSP: [G]o to [d]efinition")
					map("n", "gr", vim.lsp.buf.references, "LSP: [G]o to [r]eferences")
					map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: [R]efactor [n]ame")
					map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: [C]ode [a]ction")
					map("n", "<leader>cf", function()
						vim.lsp.buf.format({ async = true })
					end, "LSP: [C]ode [f]ormat")
					map("n", "<leader>D", vim.diagnostic.open_float, "LSP: Show [D]iagnostic")
					map("n", "<leader>lR", ":LspRestart<CR>", "LSP: [R]estart")

					local ok_telescope, tbuiltin = pcall(require, "telescope.builtin")
					if ok_telescope then
						map("n", "<leader>ld", tbuiltin.lsp_definitions, "LSP: [L]ist [d]efinitions")
						map("n", "<leader>lr", tbuiltin.lsp_references, "LSP: [L]ist [r]eferences")
						map("n", "<leader>li", tbuiltin.lsp_implementations, "LSP: [L]ist [i]mplementations")
						map("n", "<leader>ls", tbuiltin.lsp_document_symbols, "LSP: [L]ist buffer [s]ymbols")
						map("n", "<leader>lS", tbuiltin.lsp_workspace_symbols, "TLSP: [L]ist workspace [S]ymbols")
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

			vim.lsp.config("csharp_ls", {
				capabilities = capabilities,
			})
		end,
	},
}
