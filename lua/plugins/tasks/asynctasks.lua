-- Tasks share the single <leader>` terminal: a task restarts it with the task command,
-- then leaves an interactive shell behind.
local TERMINAL_ID = 1

local function with_shell(cmd)
    local shell = vim.o.shell
    if vim.fn.has("win32") == 1 then
        if shell:lower():match("cmd") then
            return cmd .. " & " .. shell
        end
        if shell:lower():match("powershell") or shell:lower():match("pwsh") then
            return cmd .. "; " .. shell
        end
    end
    return cmd .. "; exec " .. shell
end

local function run_in_terminal(opts)
    local terminal = require("toggleterm.terminal")
    local existing = terminal.get(TERMINAL_ID, true)
    if existing then
        existing:shutdown()
    end
    -- Direction, size and keymaps come from the toggleterm config.
    terminal.Terminal:new({ id = TERMINAL_ID, cmd = with_shell(opts.cmd), dir = opts.cwd }):open()
end

local function configure_runners()
    vim.g.asyncrun_runner = vim.tbl_deep_extend("force", vim.g.asyncrun_runner or {}, {
        terminal_task = run_in_terminal,
        -- Older .tasks files use pos=build / pos=run.
        build = run_in_terminal,
        run = run_in_terminal,
    })
    -- Default for output=terminal tasks without pos=; asyncrun's own toggleterm runner
    -- fails when its terminal already exists.
    vim.g.asynctasks_term_pos = "terminal_task"
end

local TASKS_TEMPLATE = [[
# Project tasks for asynctasks.vim: https://github.com/skywind3000/asynctasks.vim
# <leader>tl picks a task, <leader>tt repeats the last one.
# Lines starting with '#' or ';' are comments.
#
# Task fields:
#   [name]               Task name. [name:profile] defines a variant of the same task;
#                        switch with :AsyncTaskProfile <profile> (default profile: debug).
#   command=...          Shell command to run (required).
#   command:c,cpp=...    Command used only for the listed filetypes.
#   command/win32=...    Command used only on win32 or linux (macOS counts as linux).
#   cwd=<root>           Working directory; <root> is the project root, same as $(VIM_ROOT).
#   output=terminal      terminal: run in the <leader>` terminal (restarts it); quickfix (default):
#                        collect output into the quickfix list and parse errors with errorformat.
#   save=2               Save before running: 1 = current file, 2 = all modified buffers.
#   errorformat=...      Error pattern for output=quickfix, see :help errorformat.
#   silent=1             Do not open the quickfix window.
#
# Macros expanded in command and cwd (also exported as environment variables):
#   $(VIM_ROOT)      project root               $(VIM_CWD)        current directory
#   $(VIM_FILEPATH)  current file, full path    $(VIM_FILEDIR)    directory of the current file
#   $(VIM_FILENAME)  current file name          $(VIM_FILENOEXT)  file name without extension
#   $(VIM_PRONAME)   project directory name     $(-name)          ask for a value on start
#   :AsyncTaskMacro lists all macros with their current values.
#
# Example:
#
# [build]
# command=cmake -S . -B build && cmake --build build
# cwd=<root>
# output=terminal
# save=2
#
# [run]
# command=build/$(VIM_PRONAME)
# cwd=<root>
# output=terminal
]]

-- Project .tasks visible from the current buffer, searched upward like asynctasks does.
local function find_tasks_file()
    local name = vim.api.nvim_buf_get_name(0)
    local start = name ~= "" and vim.fs.dirname(name) or vim.fn.getcwd()
    return vim.fs.find(".tasks", { upward = true, path = start, type = "file" })[1]
end

local function create_tasks_file()
    local path = vim.fs.joinpath(vim.fn.getcwd(), ".tasks")
    if vim.fn.filereadable(path) == 0 then
        vim.fn.writefile(vim.split(TASKS_TEMPLATE, "\n", { trimempty = true }), path)
    end
    vim.cmd.edit(vim.fn.fnameescape(path))
end

local function configure_tasks_list()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local function telescope_asynctasks()
        -- Uses asynctasks' own lookup: project .tasks files up the tree plus global tasks.ini.
        local tasks = vim.fn["asynctasks#list"]("")
        local entries = {}
        for _, task in ipairs(type(tasks) == "table" and tasks or {}) do
            table.insert(entries, {
                value = task.name,
                display = string.format("%-20s %s", task.name, task.command),
                ordinal = task.name,
                run = function()
                    vim.cmd("AsyncTask " .. task.name)
                end,
            })
        end

        local tasks_file = find_tasks_file()
        if not tasks_file then
            table.insert(entries, {
                display = "+ Create .tasks in " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~"),
                ordinal = "create .tasks",
                run = create_tasks_file,
            })
        elseif vim.tbl_isempty(entries) then
            table.insert(entries, {
                display = "  Edit " .. vim.fn.fnamemodify(tasks_file, ":~:.") .. " (no tasks defined)",
                ordinal = "edit .tasks",
                run = function()
                    vim.cmd.edit(vim.fn.fnameescape(tasks_file))
                end,
            })
        end

        pickers.new(require("telescope.themes").get_dropdown({
            previewer = false,
            layout_config = { width = 0.8, height = 0.5 },
        }), {
            prompt_title = "AsyncTasks",
            finder = finders.new_table({
                results = entries,
                entry_maker = function(entry)
                    return entry
                end,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    if selection then
                        selection.run()
                    end
                end)
                return true
            end,
        }):find()
    end

    -- Create the keymap
    vim.keymap.set("n", "<leader>tl", telescope_asynctasks, { desc = "Task list" })
    vim.keymap.set("n", "<leader>tt", "<cmd>AsyncTaskLast<CR>", { desc = "Repeat last task" })
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
