--  ########### LspSAGA ###############
require("lspsaga").setup{
    rename  =   {
        enable_preview  =   true,
        preview_lines   =   20,
        in_select   =   fasle,          --  不在选择模式下触发
        auto_save   =   false,          --  不自动保存
        keys    =   {
            quit    =   q,  --在rename浮窗里按q退出
            exec    =   "<CR>",
        },
    },
--    symbol_in_winbar =   {   enable  =   false   },
--    lightbulb       =   {   enable  =   false   },
    preview         =   true,
    ui              =   {   border  =   "rounded"   },
}

vim.keymap.set("n", "<leader>ci", ":Lspsaga incoming_calls<CR>", { desc = "lspsaga Incoming Calls(查看被调用层次)"})
vim.keymap.set("n", "<leader>co", ":Lspsaga outgoing_calls<CR>", { desc = "lspsaga Outgoing Calls(查看被调用层次)"})
