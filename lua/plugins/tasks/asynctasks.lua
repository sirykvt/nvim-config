local function configure_runners()
    local function run_in_toggleterm(name, id)
        return function(opts)
            local Terminal = require("toggleterm.terminal").Terminal

            local existing_term = Terminal:new({ id = id })
            if existing_term.job_id then
                existing_term:shutdown()
            end

            local shell = vim.o.shell
            local cmd = opts.cmd .. "; exec " .. shell

            if vim.fn.has("win32") == 1 then
                if shell:lower():match("cmd") then
                    cmd = opts.cmd .. " & " .. shell
                elseif shell:lower():match("powershell") or shell:lower():match("pwsh") then
                    cmd = opts.cmd .. "; " .. shell
                end
            end

            local task_term = Terminal:new({
                cmd = cmd,
                dir = opts.cwd,
                id = id,
                display_name = name,
                direction = "float",
                auto_scroll = true,
                close_on_exit = false,
                start_in_insert = true,
                on_open = function(term)
                    local opts = { buffer = term.bufnr, noremap = true, silent = true };
                    vim.keymap.set("n", "<leader>`", "<cmd>close<CR>", opts)
                    vim.keymap.set("n", "<Esc><Esc>", "<cmd>close<CR>", opts)

                    vim.schedule(function()
                        vim.cmd("startinsert")
                    end)
                end,
            })
            task_term:toggle()
        end
    end

    vim.g.asyncrun_runner = vim.tbl_deep_extend("force", vim.g.asyncrun_runner or {}, {
        build = run_in_toggleterm("Build", 10),
        run = run_in_toggleterm("Run", 11)
    })
    vim.g.asynctasks_term_pos = "toggleterm"
end

local function configure_tasks_list()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local function get_project_root()
        -- Find the project root by looking for .tasks, .git, or .root
        local root_file = vim.fs.find({ ".tasks", ".git", ".root" }, {
            path = vim.fn.getcwd(),
            upward = true,
            type = "file",
            stop = vim.env.HOME
        })[1]
        return root_file and vim.fs.dirname(root_file) or vim.fn.getcwd()
    end

    local function telescope_asynctasks()
        local root = get_project_root()
        local task_file = root .. "/.tasks"

        -- 1. Check if .tasks file exists
        if vim.fn.filereadable(task_file) == 0 then
            vim.notify("No .tasks file found in " .. root, vim.log.levels.WARN)
            return
        end

        -- 2. Parse the file for task names like [build] or [run]
        local tasks = {}
        for line in io.lines(task_file) do
            -- Match content inside brackets: [task_name]
            local task_name = line:match("^%s*%[([^%]]+)%]%s*$")
            if task_name then
                table.insert(tasks, task_name)
            end
        end

        -- 3. Open Telescope Picker
        pickers.new({}, {
            prompt_title = "AsyncTasks",
            finder = finders.new_table({
                results = tasks,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    if selection then
                        -- 4. Spawn the task
                        vim.cmd("AsyncTask " .. selection[1])
                    end
                end)
                return true
            end,
        }):find()
    end

    -- Create the keymap
    vim.keymap.set("n", "<leader>st", telescope_asynctasks, { desc = "Search Tasks" })
end

return {
    {
        "skywind3000/asynctasks.vim",
        lazy = false,
        dependencies = {
            "skywind3000/asyncrun.vim"
        },
        config = function()
            configure_runners()
            configure_tasks_list()
        end
    }
}
