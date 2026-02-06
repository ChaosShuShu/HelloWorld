-- 0. 插件管理Lazy,nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
-- 如果本地没有lazy.nvim, 从github下载安装
    vim.fn.system({
        "git", "clone", 
        "--filter=blob:none",   --只下载必要文件,加速下载
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", 
        lazypath,               -- 安装到此路径
    } )
end
--  将lazy-nvim的安装路径添加到nvim的runtimepath(rtp)最前
--  runtimepath是nvim查找插件,脚本,配置的路径列表
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
-- 调用lazy-nvim的setup函数,传入插件列表
-- lazy..nvim会自动下载,管理,加载以下插件

--  基础美化
    {"nvim-lualine/lualine.nvim"},              -- 安装lualine:美观的状态栏插件(底部显示文件名/模式/git分支等信息)
    {"Bekaboo/dropbar.nvim"},              -- 顶部bar, 显示当前文件路径及outline
    {
        "nvimdev/lspsaga.nvim",             --  LSP 的 UI美化+增强插件
        dependencies    =   {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",      --  图标库插件
        },
        config  =   function()
            require("lspsaga").setup{}      -- 默认配置
        end,
    },              -- 顶部bar, 显示当前文件路径及outline
    {
        "romgrk/barbar.nvim",
        dependencies    =   { "nvim-tree/nvim-web-devicons", },
        init            =   function()
            vim.g.barbar_auto_setup =   false
        end,
        icons           =   {
            filetype    =   { enable =  true },
            modified    =   { button = 'ο' },
        },
--         opts    =   {
--             animation   =   true,
--             sidebar_filetypes   =   { NvimTree  =   true, },
--         },
    },
-- 0.0.1 Mason, 外挂包-管理器
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim"},
-- 0.1 LSP配置(激活语言服务器)a
    {"neovim/nvim-lspconfig"},
    {"hrsh7th/nvim-cmp", dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer"}},
    -- quickfix增强插件, 优化quickfix使用体验
    {
        "kevinhwang91/nvim-bqf",
        ft      =   "qf",   --  只在quickfix filetype(buffer) 加载
        opts    =   {
            preview     =   {
                auto_preview    =   true,   --  上下移动时自动预览
                delay           =   100,    -- 预览延迟, 避免频繁刷新
            },
            auto_resize_height     =   true,
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build   =   ":TSUpdate",                    -- 每次更新插件后自动更新parser
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event   =   "VeryLazy",                 -- 延迟载入
        dependencies    =   {"nvim-treesitter/nvim-treesitter"},
        opts            =   {
            enable      =   true,   
            max_lines   =   7,  -- 最多显示3行上下文
            min_window_height   =   20,
            multiline_threshold =   20,
            mode        =   "cursor",   -- 跟随光标位置
            -- separator    =   "-",
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
-- 2.0 语言相关优化
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies    =   {"nvim-treesitter/nvim-treesitter"},
        ft              =   {"markdown"},
    },
--  3.0 功能扩展
    {
        "stevearc/oil.nvim",
        dependencies    =   { "nvim-tree/nvim-web-devicons" },
        ops             =   {},
    },

})

-- c. 相关快捷键
-- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '跳转至定义' })          -- key:gd
-- vim.keymap.set('n', 'gr', vim.lsp.buf.reference,  { desc = '查找所有引用' })          -- key:gr
-- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover 查看文档/类型' })          -- key:K, 显示悬浮窗
-- vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, { desc = '函数签名提示' })          -- key:<leader>k, 显示参数
-- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '重命名符号' })          -- key:<leader>rn, 重命名所有引用
-- vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '代码行动(修复/重构)' })          -- key:<leader>ca, 快速修复
