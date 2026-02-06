-- Telescope
--


require("telescope").setup{
    defaults    =   {},
    pickers     =   {},
}

vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Telescope Live Grep(项目全文搜索"})
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Telescope Find Files(项目全文搜索"})
vim.keymap.set("n", "<leader>fs", ":Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "Telescope Find Symbols(项目全文搜索"})
