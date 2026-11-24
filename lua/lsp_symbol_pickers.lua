-- Telescope pickers for LSP symbols that keep the fields the builtin pickers drop:
-- the container (shown as a qualified name) and the documentSymbol `detail` (the C++ type or signature).
local M = {}

local symbol_kinds = vim.lsp.protocol.SymbolKind

local kind_highlights = {
	Class = "TelescopeResultsClass",
	Constant = "TelescopeResultsConstant",
	Field = "TelescopeResultsField",
	Function = "TelescopeResultsFunction",
	Method = "TelescopeResultsMethod",
	Property = "TelescopeResultsOperator",
	Struct = "TelescopeResultsStruct",
	Variable = "TelescopeResultsVariable",
}

local function kind_cell(kind)
	return { kind:lower(), kind_highlights[kind] }
end

local function normalize_path(path)
	path = vim.fs.normalize(path)
	-- Drive letters and separators may differ in case between LSP URIs and root_dir on Windows.
	return vim.fn.has("win32") == 1 and path:lower() or path
end

local function project_prefix(bufnr)
	local client = vim.lsp.get_clients({ bufnr = bufnr, method = "workspace/symbol" })[1]
	local root = normalize_path(client and client.root_dir or vim.fn.getcwd())
	return root:sub(-1) == "/" and root or root .. "/"
end

--- Workspace symbols limited to the LSP root, hiding SDK and other external headers.
--- @param kinds string[]? LSP symbol kind names to keep, e.g. { "Class", "Struct" }
function M.project_symbols(kinds)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local entry_display = require("telescope.pickers.entry_display")
	local utils = require("telescope.utils")
	local channel = require("plenary.async.control").channel

	local bufnr = vim.api.nvim_get_current_buf()
	local prefix = project_prefix(bufnr)
	local allowed_kinds
	if kinds then
		allowed_kinds = {}
		for _, kind in ipairs(kinds) do
			allowed_kinds[kind] = true
		end
	end
	local opts = { layout_strategy = "vertical", bufnr = bufnr }

	local displayer = entry_display.create({
		separator = " ",
		items = { { width = 50 }, { width = 12 }, { remaining = true } },
	})

	local function make_display(entry)
		local path, path_style = utils.transform_path(opts, entry.filename)
		return displayer({
			entry.qualified_name,
			kind_cell(entry.kind),
			{ path, function() return path_style end },
		})
	end

	local function entry_maker(symbol)
		local kind = symbol_kinds[symbol.kind] or "Unknown"
		if allowed_kinds and not allowed_kinds[kind] then
			return nil
		end
		local filename = vim.uri_to_fname(symbol.location.uri)
		if normalize_path(filename):sub(1, #prefix) ~= prefix then
			return nil
		end

		local container = symbol.containerName or ""
		local qualified_name = container == "" and symbol.name or container .. "::" .. symbol.name
		local start = symbol.location.range.start
		return {
			value = symbol,
			ordinal = qualified_name,
			display = make_display,
			qualified_name = qualified_name,
			kind = kind,
			filename = filename,
			lnum = start.line + 1,
			col = start.character + 1,
		}
	end

	local cancel = function() end
	local function request(prompt)
		local tx, rx = channel.oneshot()
		cancel()
		cancel = vim.lsp.buf_request_all(bufnr, "workspace/symbol", { query = prompt }, tx)

		local symbols = {}
		for _, response in pairs(rx()) do
			vim.list_extend(symbols, response.result or {})
		end
		return symbols
	end

	pickers
		.new(opts, {
			prompt_title = kinds and "Project Classes" or "Project Symbols",
			finder = finders.new_dynamic({ fn = request, entry_maker = entry_maker }),
			previewer = conf.qflist_previewer(opts),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(_, map)
				map("i", "<C-Space>", actions.to_fuzzy_refine)
				return true
			end,
		})
		:find()
end

local function show_document_symbols(items, filename, bufnr)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local entry_display = require("telescope.pickers.entry_display")

	local opts = { layout_strategy = "vertical", bufnr = bufnr }
	local displayer = entry_display.create({
		separator = " ",
		items = { { width = 40 }, { width = 12 }, { remaining = true } },
	})

	pickers
		.new(opts, {
			prompt_title = "Document Symbols",
			finder = finders.new_table({
				results = items,
				entry_maker = function(item)
					return {
						value = item,
						ordinal = item.name,
						display = function()
							return displayer({
								string.rep("  ", item.depth) .. item.name,
								kind_cell(item.kind),
								{ item.detail, "Type" },
							})
						end,
						filename = filename,
						bufnr = bufnr,
						lnum = item.lnum,
						col = item.col,
					}
				end,
			}),
			previewer = conf.qflist_previewer(opts),
			sorter = conf.generic_sorter(opts),
		})
		:find()
end

--- Document symbols as a tree with their type or signature.
function M.document_symbols()
	local bufnr = vim.api.nvim_get_current_buf()
	local filename = vim.api.nvim_buf_get_name(bufnr)
	local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }

	vim.lsp.buf_request_all(bufnr, "textDocument/documentSymbol", params, function(responses)
		local items = {}
		local function collect(symbols, depth)
			for _, symbol in ipairs(symbols) do
				local kind = symbol_kinds[symbol.kind] or "Unknown"
				-- Servers return either hierarchical DocumentSymbol or flat SymbolInformation.
				local range = symbol.selectionRange or symbol.location.range
				local detail = symbol.detail or ""
				-- clangd repeats the kind as detail for types ("struct", "enum"): not useful as a type.
				if detail:lower() == kind:lower() then
					detail = ""
				end
				table.insert(items, {
					name = symbol.name,
					detail = detail,
					kind = kind,
					depth = depth,
					lnum = range.start.line + 1,
					col = range.start.character + 1,
				})
				collect(symbol.children or {}, depth + 1)
			end
		end
		for _, response in pairs(responses) do
			collect(response.result or {}, 0)
		end

		vim.schedule(function()
			if vim.tbl_isempty(items) then
				vim.notify("No document symbols", vim.log.levels.INFO)
				return
			end
			show_document_symbols(items, filename, bufnr)
		end)
	end)
end

return M
