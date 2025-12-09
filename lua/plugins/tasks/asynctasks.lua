return {
    {
        "skywind3000/asynctasks.vim",
        dependencies = {
            "skywind3000/asyncrun.vim"
        },
        config = function()
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
                                print("Spawned: " .. selection[1])
                            end
                        end)
                        return true
                    end,
                }):find()
            end

            -- Create the keymap
            vim.keymap.set("n", "<leader>st", telescope_asynctasks, { desc = "Search Tasks" })
        end
    }
}
