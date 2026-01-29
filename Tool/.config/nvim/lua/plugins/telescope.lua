-- Telescope
--


require("telescope").setup{
    defaults    =   {},
    pickers     =   {},
}

vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Telescope Live Grep(项目全文搜索"})
