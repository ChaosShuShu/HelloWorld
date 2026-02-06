return{
    "nvim-treesitter/nvim-treesitter",
    version =   false,                          -- 使用最新版commit而非release
    lazy    =   false,                          -- 强制不延迟载入
    dependencies    =   {},                     -- 其他依赖扩展
    config  =   function()
        require("nvim-treesitter.configs").setup({
            -- 安装以下语言的parser
            ensure_installed    =   {
                "c", "cpp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "base", "python",
            },

            -- 核心功能
            highlight   =   {enable = true},
            indent      =   {enable = true},
            fold        =   {enable = true,
            },
        })
    end,
}
