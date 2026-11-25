return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
		config = function(_, opts)
			local npairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")
			npairs.setup(opts)

			-- Typing `>` steps over a `>` already right of the cursor, e.g. the one clangd inserts with
			-- `vector<>`. `<` itself is never paired since it is also the less-than operator.
			npairs.add_rule(Rule("<", ">", { "c", "cpp", "cuda", "objcpp" })
				:with_pair(cond.none())
				:with_move(cond.done())
				:with_del(cond.none()))
		end,
	},
}
