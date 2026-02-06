-- 设置Oil插件

return{
    "stevearc/oil.nvim",
    config      =   function()
        require("oil").setup({
            default_file_explorer       =   true,
            view_type                   =   "float",
            float   =   {
                max_width   =   0.8,
                max_height  =   0.8,
                boarder     =   "rounded",
                win_options =   {
                    winblend    =   10,
                },
            },
            keymap  =   {
                ["g"]       =   "actions.show_help",
                ["<CR>"]       =   "actions.select",
                -- ["<C-v>"]       =   "actions.select_vsplit",
                ["p"]       =   "actions.preview",
                ["q"]       =   "actions.close",
                -- ["g"]       =   "actions.show_help",
                -- ["g"]       =   "actions.show_help",
                -- ["g"]       =   "actions.show_help",
                -- ["g"]       =   "actions.show_help",
            },
            skip_confirm_for_simple_edits   =   true,
            delete_to_trash                 =   true,
        })
    end
}
