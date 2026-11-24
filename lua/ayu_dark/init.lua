-- Ayu Dark with the original syntax/background colors and reworked UI contrast.
local M = {}

M.palette = {
	-- Editor and syntax: identical to upstream ayu dark.
	bg = "#0B0E14",
	fg = "#BFBDB6",
	accent = "#E6B450",
	tag = "#39BAE6",
	func = "#FFB454",
	entity = "#59C2FF",
	string = "#AAD94C",
	regexp = "#95E6CB",
	markup = "#F07178",
	keyword = "#FF8F40",
	special = "#E6B673",
	comment = "#636A72",
	constant = "#D2A6FF",
	operator = "#F29668",
	error = "#D95757",
	warning = "#FF8F40",
	lsp_parameter = "#CB9FF8",
	white = "#FFFFFF",

	-- UI: tuned so nothing is dark-on-dark.
	line = "#11151C", -- cursor line
	panel = "#141821", -- statusline, floats, popup menus
	panel_alt = "#1E2430", -- statusline section b, scrollbar track
	selection = "#1B3A5B", -- Visual, current popup item
	selection_dim = "#16283D", -- LSP references, diff change
	line_nr = "#707A8C",
	idle = "#6C7380", -- inactive statusline, folded text, inlay hints
	whitespace = "#5A616E", -- listchars, shown on demand
	guide = "#3A404B", -- `~` after buffer end, scrollbar thumb
	border = "#454C59", -- window separators, float borders

	vcs_added = "#7FD962",
	vcs_modified = "#73B8FF",
	vcs_removed = "#F26D78",
	diff_add = "#1F2A17",
	diff_delete = "#341F22",
	diff_text = "#1F3F63",
}

local function terminal_colors(c)
	-- Bright variants reuse the normal ones except black/white, which upstream mapped to
	-- the background and the comment color, making them unreadable.
	local ansi = {
		"#1E222A", c.markup, c.string, c.accent, c.tag, c.constant, c.regexp, c.fg,
		"#686F7A", c.markup, c.string, c.accent, c.tag, c.constant, c.regexp, "#E6E1CF",
	}
	for i, color in ipairs(ansi) do
		vim.g["terminal_color_" .. (i - 1)] = color
	end
end

local function groups(c)
	return {
		-- Editor.
		Normal = { fg = c.fg, bg = c.bg },
		NormalFloat = { fg = c.fg, bg = c.panel },
		NormalNC = { link = "Normal" },
		FloatBorder = { fg = c.border, bg = c.panel },
		FloatTitle = { fg = c.accent, bg = c.panel, bold = true },
		FloatFooter = { fg = c.idle, bg = c.panel },
		FloatShadow = { bg = "#000000", blend = 80 },
		FloatShadowThrough = { bg = "#000000", blend = 100 },
		Cursor = { fg = c.bg, bg = c.fg },
		CursorLine = { bg = c.line },
		CursorColumn = { bg = c.line },
		ColorColumn = { bg = c.line },
		CursorLineNr = { fg = c.accent, bg = c.line, bold = true },
		CursorLineSign = { bg = c.line },
		CursorLineFold = { bg = c.line },
		LineNr = { fg = c.line_nr },
		SignColumn = { bg = c.bg },
		FoldColumn = { fg = c.idle, bg = c.bg },
		Folded = { fg = c.idle, bg = c.panel },
		WinSeparator = { fg = c.border, bg = c.bg },
		VertSplit = { link = "WinSeparator" },
		EndOfBuffer = { fg = c.guide },
		NonText = { fg = c.whitespace },
		Whitespace = { fg = c.whitespace },
		SpecialKey = { fg = c.comment },
		Conceal = { fg = c.comment },
		CursorLineConceal = { fg = c.comment, bg = c.line },
		MatchParen = { sp = c.func, underline = true, bold = true },
		Directory = { fg = c.func },
		Title = { fg = c.keyword, bold = true },
		Visual = { bg = c.selection },
		VisualNOS = { link = "Visual" },
		QuickFixLine = { bg = c.selection },
		qfLineNr = { fg = c.keyword },
		qfError = { fg = c.error },

		-- Search.
		Search = { fg = c.bg, bg = c.constant },
		CurSearch = { fg = c.bg, bg = c.special },
		IncSearch = { fg = c.bg, bg = c.keyword },
		Substitute = { fg = c.bg, bg = c.markup },

		-- Messages.
		ErrorMsg = { fg = c.error },
		WarningMsg = { fg = c.warning },
		OkMsg = { fg = c.string },
		ModeMsg = { fg = c.string },
		MoreMsg = { fg = c.string },
		Question = { fg = c.string },

		-- Statusline, tabline, winbar.
		StatusLine = { fg = c.fg, bg = c.panel },
		StatusLineNC = { fg = c.idle, bg = c.panel },
		StatusLineTerm = { link = "StatusLine" },
		StatusLineTermNC = { link = "StatusLineNC" },
		TabLine = { fg = c.idle, bg = c.panel },
		TabLineFill = { bg = c.panel },
		TabLineSel = { fg = c.fg, bg = c.bg, bold = true },
		WinBar = { fg = c.fg, bg = c.bg, bold = true },
		WinBarNC = { fg = c.idle, bg = c.bg },

		-- Popup menu.
		Pmenu = { fg = c.fg, bg = c.panel },
		PmenuSel = { bg = c.selection, bold = true },
		PmenuKind = { fg = c.tag, bg = c.panel },
		PmenuKindSel = { fg = c.tag, bg = c.selection },
		PmenuExtra = { fg = c.idle, bg = c.panel },
		PmenuExtraSel = { fg = c.fg, bg = c.selection },
		PmenuMatch = { fg = c.keyword, bg = c.panel, bold = true },
		PmenuMatchSel = { fg = c.keyword, bg = c.selection, bold = true },
		PmenuSbar = { bg = c.panel_alt },
		PmenuThumb = { bg = c.guide },
		PmenuShadow = { link = "FloatShadow" },
		PmenuShadowThrough = { link = "FloatShadowThrough" },
		WildMenu = { link = "PmenuSel" },
		ComplHint = { fg = c.comment },

		-- Spelling.
		SpellBad = { sp = c.error, undercurl = true },
		SpellCap = { sp = c.tag, undercurl = true },
		SpellLocal = { sp = c.keyword, undercurl = true },
		SpellRare = { sp = c.regexp, undercurl = true },

		-- Syntax.
		Comment = { fg = c.comment, italic = true },
		Constant = { fg = c.constant },
		String = { fg = c.string },
		Identifier = { fg = c.entity },
		Function = { fg = c.func },
		Statement = { fg = c.keyword },
		Operator = { fg = c.operator },
		Exception = { fg = c.markup },
		PreProc = { fg = c.accent },
		Type = { fg = c.entity },
		Structure = { fg = c.special },
		Special = { fg = c.accent },
		Delimiter = { fg = c.special },
		Underlined = { sp = c.tag, underline = true },
		Ignore = { fg = c.fg },
		Error = { fg = c.white, bg = c.error },
		Todo = { fg = c.markup, bold = true },
		markdownCode = { fg = c.special },
		htmlTag = { fg = c.entity },
		htmlEndTag = { link = "htmlTag" },
		htmlTagName = { fg = c.entity },
		htmlArg = { fg = c.func },
		htmlTitle = { fg = c.fg, bold = true },

		-- Diff.
		Added = { fg = c.vcs_added },
		Changed = { fg = c.vcs_modified },
		Removed = { fg = c.vcs_removed },
		DiffAdd = { bg = c.diff_add },
		DiffChange = { bg = c.selection_dim },
		DiffDelete = { bg = c.diff_delete },
		DiffText = { bg = c.diff_text },
		DiffAdded = { fg = c.vcs_added },
		DiffRemoved = { fg = c.vcs_removed },

		-- Diagnostics.
		DiagnosticError = { fg = c.error },
		DiagnosticWarn = { fg = c.keyword },
		DiagnosticInfo = { fg = c.tag },
		DiagnosticHint = { fg = c.regexp },
		DiagnosticOk = { fg = c.string },
		DiagnosticUnderlineError = { sp = c.error, undercurl = true },
		DiagnosticUnderlineWarn = { sp = c.keyword, undercurl = true },
		DiagnosticUnderlineInfo = { sp = c.tag, undercurl = true },
		DiagnosticUnderlineHint = { sp = c.regexp, undercurl = true },
		DiagnosticUnderlineOk = { sp = c.string, undercurl = true },
		DiagnosticDeprecated = { sp = c.comment, strikethrough = true },
		DiagnosticUnnecessary = { fg = c.comment },

		-- LSP.
		LspReferenceText = { bg = c.selection_dim },
		LspReferenceRead = { bg = c.selection_dim },
		LspReferenceWrite = { bg = c.selection_dim, underline = true },
		LspReferenceTarget = { bg = c.selection_dim },
		LspInlayHint = { fg = c.idle, bg = c.line },
		LspCodeLens = { fg = c.comment },
		LspCodeLensSeparator = { fg = c.guide },
		LspSignatureActiveParameter = { fg = c.func, bold = true },

		-- Treesitter.
		["@property"] = { fg = c.tag },
		["@tag"] = { fg = c.keyword },
		["@tag.attribute"] = { fg = c.entity },
		["@tag.delimiter"] = { link = "Delimiter" },
		["@type.qualifier"] = { fg = c.keyword },
		["@variable"] = { fg = c.fg },
		["@variable.builtin"] = { fg = c.func },
		["@variable.member"] = { fg = c.tag },
		["@variable.parameter"] = { fg = c.fg },
		["@module"] = { fg = c.func },
		["@markup.heading"] = { fg = c.keyword },
		["@keyword.storage"] = { fg = c.keyword },

		-- LSP semantic tokens.
		["@lsp.type.namespace"] = { link = "@module" },
		["@lsp.type.type"] = { link = "@type" },
		["@lsp.type.class"] = { link = "@type" },
		["@lsp.type.enum"] = { link = "@type" },
		["@lsp.type.interface"] = { link = "@type" },
		["@lsp.type.struct"] = { link = "@variable.member" },
		["@lsp.type.parameter"] = { fg = c.lsp_parameter },
		["@lsp.type.field"] = { link = "@variable.member" },
		["@lsp.type.variable"] = { link = "@variable" },
		["@lsp.type.property"] = { link = "@property" },
		["@lsp.type.enumMember"] = { link = "@constant" },
		["@lsp.type.function"] = { link = "@function" },
		["@lsp.type.method"] = { link = "@function.method" },
		["@lsp.type.macro"] = { link = "@function.macro" },
		["@lsp.type.decorator"] = { link = "@function" },
		["@lsp.mod.constant"] = { link = "@constant" },
		["@lsp.mod.deprecated"] = { link = "DiagnosticDeprecated" },

		-- Telescope.
		TelescopeBorder = { link = "FloatBorder" },
		TelescopePromptBorder = { fg = c.accent, bg = c.panel },
		TelescopePromptTitle = { fg = c.bg, bg = c.accent, bold = true },
		TelescopePreviewTitle = { fg = c.bg, bg = c.string, bold = true },
		TelescopeResultsTitle = { fg = c.bg, bg = c.entity, bold = true },
		TelescopeSelection = { bg = c.selection, bold = true },
		TelescopeSelectionCaret = { fg = c.accent, bg = c.selection },
		TelescopeMultiSelection = { fg = c.constant },
		TelescopeMatching = { fg = c.keyword, bold = true },
		TelescopePromptCounter = { fg = c.idle },

		-- blink.cmp.
		BlinkCmpMenu = { link = "Pmenu" },
		BlinkCmpMenuBorder = { link = "FloatBorder" },
		BlinkCmpMenuSelection = { link = "PmenuSel" },
		BlinkCmpScrollBarGutter = { link = "PmenuSbar" },
		BlinkCmpScrollBarThumb = { link = "PmenuThumb" },
		BlinkCmpLabel = { fg = c.fg },
		BlinkCmpLabelDeprecated = { fg = c.comment, strikethrough = true },
		BlinkCmpLabelMatch = { fg = c.keyword, bold = true },
		BlinkCmpLabelDescription = { fg = c.idle },
		BlinkCmpLabelDetail = { fg = c.idle },
		BlinkCmpSource = { fg = c.idle },
		BlinkCmpGhostText = { fg = c.comment, italic = true },
		BlinkCmpDoc = { link = "NormalFloat" },
		BlinkCmpDocBorder = { link = "FloatBorder" },
		BlinkCmpDocSeparator = { fg = c.border, bg = c.panel },
		BlinkCmpSignatureHelp = { link = "NormalFloat" },
		BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },
		BlinkCmpSignatureHelpActiveParameter = { link = "LspSignatureActiveParameter" },
		BlinkCmpKind = { fg = c.tag },
		BlinkCmpKindText = { fg = c.string },
		BlinkCmpKindMethod = { fg = c.keyword },
		BlinkCmpKindFunction = { fg = c.func },
		BlinkCmpKindConstructor = { fg = c.keyword },
		BlinkCmpKindField = { fg = c.tag },
		BlinkCmpKindVariable = { fg = c.markup },
		BlinkCmpKindClass = { fg = c.entity },
		BlinkCmpKindInterface = { fg = c.entity },
		BlinkCmpKindModule = { fg = c.func },
		BlinkCmpKindProperty = { fg = c.tag },
		BlinkCmpKindUnit = { fg = c.constant },
		BlinkCmpKindValue = { fg = c.constant },
		BlinkCmpKindEnum = { fg = c.entity },
		BlinkCmpKindKeyword = { fg = c.keyword },
		BlinkCmpKindSnippet = { fg = c.markup },
		BlinkCmpKindColor = { fg = c.special },
		BlinkCmpKindFile = { fg = c.special },
		BlinkCmpKindReference = { fg = c.markup },
		BlinkCmpKindFolder = { fg = c.special },
		BlinkCmpKindEnumMember = { fg = c.regexp },
		BlinkCmpKindConstant = { fg = c.constant },
		BlinkCmpKindStruct = { fg = c.entity },
		BlinkCmpKindEvent = { fg = c.tag },
		BlinkCmpKindOperator = { fg = c.operator },
		BlinkCmpKindTypeParameter = { fg = c.lsp_parameter },

		-- which-key.
		WhichKey = { fg = c.accent },
		WhichKeyGroup = { fg = c.entity },
		WhichKeyDesc = { fg = c.fg },
		WhichKeySeparator = { fg = c.comment },
		WhichKeyValue = { fg = c.idle },

		-- fidget.nvim.
		FidgetTitle = { fg = c.accent, bold = true },
		FidgetTask = { fg = c.idle },
	}
end

function M.load()
	-- Set before `colors_name`: changing 'background' re-sources the active colorscheme.
	vim.o.background = "dark"
	vim.cmd("highlight clear")
	vim.g.colors_name = "ayu-dark"

	local c = M.palette
	terminal_colors(c)
	for name, spec in pairs(groups(c)) do
		vim.api.nvim_set_hl(0, name, spec)
	end
end

return M
