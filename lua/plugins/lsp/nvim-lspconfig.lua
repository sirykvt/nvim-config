local function on_lsp_attach(args)
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, {
			buffer = args.buf,
			silent = true,
			noremap = true,
			desc = desc,
		})
	end

	vim.diagnostic.config({
		-- Show signs (left gutter icons)
		virtual_text = true, -- <--- THIS IS THE KEY SETTING
		
		-- Optional: customize the appearance of the virtual text
		-- 'details' (shows code and message) or 'error' (shows error/warning message only)
		-- We recommend 'error' to keep it clean.
		-- If you are using a plugin like 'nvim-lint', you might need to adjust this.
		virtual_text = {
		    severity = { min = vim.diagnostic.severity.HINT }, -- Show all severities
		    source = "always",                                 -- Include the source (e.g., clangd)
		    format = function(diagnostic)
		        -- Only display the diagnostic message
		        return diagnostic.message
		    end,
		},

		-- Show line numbers where diagnostics start
		signs = true,
		
		-- Underline diagnostics
		underline = true,
		
		-- Update diagnostics only when the user is idle
		update_in_insert = false,
		
		-- Set the delay for when diagnostics are refreshed
		-- float = { ... } -- Configuration for the hover popup
	})

	-- Misc.
	map("n", "K", vim.lsp.buf.hover, "Hover")
	map("n", "<leader>xr", ":LspRestart<CR>", "LSP Restart")
	map("n", "<leader>xl", ":LspInfo<CR>", "LSP Info")

	-- Diagnostics.
	map("n", "<leader>ds", vim.lsp.buf.hover, "Show diagnostics float")
	map("n", "<leader>dl", function()
		require('telescope.builtin').diagnostics({
				bufnr = 0,
			})
		end, "Search Buffer diagnostics")
	map("n", "<leader>dL", require('telescope.builtin').diagnostics, "Search Workspace diagnostics")

	-- Go to.
	map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
	-- map("n", "gr", vim.lsp.buf.references, "Go to References")

	-- Refactoring.
	map("n", "<leader>rr", vim.lsp.buf.rename, "Rename")
	map("n", "<leader>ra", vim.lsp.buf.code_action, "Code Action")
	map("n", "<leader>rf",
		function()
			vim.lsp.buf.format({ async = true })
		end,
		"Code Format"
	)

	-- Search.
	local ok_telescope, tbuiltin = pcall(require, "telescope.builtin")
	if ok_telescope then
		map("n", "<leader>sd", tbuiltin.lsp_definitions, "Search Definitions")
		map("n", "<leader>sr", tbuiltin.lsp_references, "Search References")
		map("n", "<leader>si", tbuiltin.lsp_implementations, "Search Implementations")
		map("n", "<leader>sS", tbuiltin.lsp_document_symbols, "Search Buffer Symbols")
		map(
			"n",
			"<leader>ss",
			tbuiltin.lsp_dynamic_workspace_symbols,
			"Search Workspace Symbols"
		)
	end
end

local function configure_lua(capabilities)
	vim.lsp.config("lua_ls", {
		capabilities = capabilities,
		cmd = (vim.fn.has("unix") == 1 or vim.fn.has("linux") == 1) and { "lua-language-server" } or nil,
		settings = {
			Lua = {
				telemetry = {
					enable = false,
				},
			},
		},
	})
	vim.lsp.enable("lua_ls")
end

local function configure_cpp(capabilities)
	vim.lsp.config("clangd", {
		capabilities = capabilities,
		cmd = {
			"D:/apps/vs2022/VC/Tools/Llvm/x64/bin/clangd.exe",
			"--background-index",
			"-j=30",
			"--pch-storage=memory",
			"--header-insertion=iwyu",
		}
	})
end

local function configure_csharp(capabilities)
	vim.lsp.config("roslyn", {
		capabilities = capabilities,
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

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok_blink, blink = pcall(require, "blink.cmp")
			if ok_blink and blink.get_lsp_capabilities then
				capabilities = blink.get_lsp_capabilities(capabilities)
			end

			configure_lua(capabilities)
			configure_cpp(capabilities)
			configure_csharp(capabilities)
		end,
	},
}
