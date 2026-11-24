-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", "<cmd>echo 'Use h to move!!'<CR>", { desc = "Disabled, use h" })
vim.keymap.set("n", "<right>", "<cmd>echo 'Use l to move!!'<CR>", { desc = "Disabled, use l" })
vim.keymap.set("n", "<up>", "<cmd>echo 'Use k to move!!'<CR>", { desc = "Disabled, use k" })
vim.keymap.set("n", "<down>", "<cmd>echo 'Use j to move!!'<CR>", { desc = "Disabled, use j" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper window" })

vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("n", "<leader>xs", "<cmd>set list!<CR>", { desc = "Toggle visible whitespace" })
vim.keymap.set("n", "<leader>xw", "<cmd>set wrap!<CR>", { desc = "Toggle line wrap" })
vim.keymap.set("n", "<leader>xt", function()
	local view = vim.fn.winsaveview()
	vim.cmd([[keeppatterns %s/\s\+$//e]])
	vim.fn.winrestview(view)
end, { desc = "Remove trailing whitespace" })
vim.keymap.set("n", "<leader>yp", function()
	vim.fn.setreg("+", vim.fn.expand("%:."))
end, { desc = "Relative file path" })
vim.keymap.set("n", "<leader>yP", function()
	vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Absolute file path" })
vim.keymap.set("n", "<BS>", "<C-^>", { desc = "Alternate buffer" })
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>d", "<cmd>bd<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>W", "<cmd>%bd<CR>", { desc = "Close all buffers" })
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
-- vim.keymap.set('n', 'j', 'gj', { silent = true })
-- vim.keymap.set('n', 'k', 'gk', { silent = true })
-- vim.keymap.set('n', '<C-d>', '<C-d>zz')
-- vim.keymap.set('n', '<C-u>', '<C-u>zz')
-- vim.keymap.set('n', 'n', 'nzzzv')
-- vim.keymap.set('n', 'N', 'Nzzzv')
-- vim.keymap.set({ "n", "v" }, "d", "_d", { desc = "Delete without copying" })
-- vim.keymap.set("n", "dd", "_dd", { desc = "Delete line without copying" })
-- vim.keymap.set({ "n", "v" }, "<leader>d", "d", { desc = "Cut (standard d behavior)" })
-- vim.keymap.set("x", "p", "P", { desc = "Paste without overwriting clipboard" })