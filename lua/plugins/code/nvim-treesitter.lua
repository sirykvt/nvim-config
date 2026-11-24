local ensure_installed = {
	"bash",
	"c",
	"diff",
	"html",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"query",
	"vim",
	"vimdoc",
	"cpp",
	"c_sharp",
	"cmake",
}

local function attach(buf, lang)
	if not pcall(vim.treesitter.start, buf, lang) then
		return false
	end
	vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	return true
end

local function on_filetype(args)
	local lang = vim.treesitter.language.get_lang(args.match)
	if not lang or attach(args.buf, lang) then
		return
	end

	-- Replacement for the `auto_install` option of the master branch.
	local ts = require("nvim-treesitter")
	if not vim.list_contains(ts.get_available(), lang) then
		return
	end
	ts.install(lang):await(function(err)
		if err then
			return
		end
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(args.buf) then
				attach(args.buf, lang)
			end
		end)
	end)
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install(ensure_installed)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
				callback = on_filetype,
			})

			-- Built-in incremental selection (v_an / v_in) with the previous key layout.
			vim.keymap.set("n", "<C-Space>", "van", { remap = true, desc = "Start node selection" })
			vim.keymap.set("x", "<C-Space>", "an", { remap = true, desc = "Expand node selection" })
			vim.keymap.set("x", "<BS>", "in", { remap = true, desc = "Shrink node selection" })
		end,
	},
}
