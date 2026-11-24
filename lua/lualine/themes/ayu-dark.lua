local c = require("ayu_dark").palette

local function mode(color)
	return {
		a = { fg = c.bg, bg = color, gui = "bold" },
		b = { fg = color, bg = c.panel_alt },
		c = { fg = c.fg, bg = c.panel },
	}
end

return {
	normal = mode(c.entity),
	insert = mode(c.string),
	visual = mode(c.accent),
	replace = mode(c.markup),
	command = mode(c.constant),
	terminal = mode(c.regexp),
	inactive = {
		a = { fg = c.idle, bg = c.panel },
		b = { fg = c.idle, bg = c.panel },
		c = { fg = c.idle, bg = c.panel },
	},
}
