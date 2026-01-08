-- ===================================
-- Neovim 基础配置（等价于你的 vimrc）
-- ===================================

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

-- 0.0 基础美化
    {"nvim-lualine/lualine.nvim"},              -- 安装lualine:美观的状态栏插件(底部显示文件名/模式/git分支等信息)
-- 0.1 LSP配置(激活语言服务器)a
    {"neovim/nvim-lspconfig"},
        {"hrsh7th/nvim-cmp", dependencies = {"hrsh7th/cmp-nvim-lsp", "hr7th/cmp-buffer"}},
})

-- 1. 启用文件类型检测、插件和自动缩进
vim.o.filetype = "on"              -- 检测文件类型
vim.cmd([[filetype plugin indent on]])  -- 启用 filetype plugin 和 indent

-- 2. 启用语法高亮
vim.o.syntax = "on"
vim.cmd([[syntax on]])

-- 3. 显示行号
vim.o.number = true

-- 4. 增量搜索（边输入边高亮匹配）
vim.o.incsearch = true

-- 5. 显示括号匹配
vim.o.showmatch = true

-- 6. 在底部显示当前模式（如 -- INSERT --）
vim.o.showmode = true

-- 7. 编码设置（完全保留你的中文支持意图）
vim.o.encoding = "utf-8"
-- fileencoding 可以留空，让 Neovim 自动检测，通常更智能
-- 如果你经常编辑中文旧编码文件，可取消下面注释
-- vim.o.fileencodings = "utf-8,gbk,gb18030,gb2312"

-- 8. 高亮搜索结果
vim.o.hlsearch = true

-- 9. 高亮当前行
vim.o.cursorline = true

-- ===================================
-- 小优化（推荐保留，体验更好）
-- ===================================

-- 真彩色支持（现代终端必备）
vim.o.termguicolors = true

-- 搜索时忽略大小写，除非搜索内容包含大写
vim.o.ignorecase = true
vim.o.smartcase = true

-- 关闭备份文件和 swap 文件（可选，很多人喜欢干净）
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- 更好的滚动体验
vim.o.scrolloff = 5        -- 光标上下保留至少 5 行

-- 显示不可见字符（你原来注释了，这里也先注释，可随时打开）
vim.o.list = true
vim.o.listchars = "leadmultispace:····,tab:→ ,trail:·,eol:↲"

-- 让 Backspace 和 Tab 行为模拟真实 Tab（一次性处理 4 个空格）
vim.o.tabstop = 4          -- Tab 显示宽度为 4
vim.o.shiftwidth = 4       -- >>、<<、自动缩进时移动 4 个空格
vim.o.softtabstop = 4      -- 关键！Backspace 和 Tab 一次处理 4 个空格
vim.o.expandtab = true     -- 输入 Tab 时插入 4 个空格（而不是 \t）
vim.o.smarttab = true      -- 行首 Tab 使用 shiftwidth 宽度

-- 高亮当前行更柔和（可选美化）
vim.api.nvim_set_hl(0, "CursorLine", { underline = true })  -- 只显示下划线，不加背景
-- 或者加浅色背景（取消注释下面这行）：
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2a2a3a" })

-- 设置主题
vim.cmd[[colorscheme lunaperche]]
vim.api.nvim_set_hl(0, 'Comment', { fg = '#6a9955', italic = true})

-- ===================================
-- 状态栏Lualine配置
-- ===================================
require('lualine').setup {
    options = {
        icons_enabled = true,   -- 使用图标
        theme = 'auto',         -- 自动根据colorscheme
        component_separators =  { left = '|', right = '|' },
        section_separators = { left = '-', right = '-' },
        disabled_filetypes = {},
        always_divide_middle = true,
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_c = {'filename'},
        lualine_x = {'location'}
    },
}





