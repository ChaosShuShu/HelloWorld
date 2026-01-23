
-- 真彩色支持（现代终端必备）
vim.o.termguicolors = true

-- 显示不可见字符（你原来注释了，这里也先注释，可随时打开）
vim.o.list = true
vim.o.listchars = "leadmultispace:····,tab:→ ,trail:·,eol:↲"

-- 高亮当前行更柔和（可选美化）
vim.api.nvim_set_hl(0, "CursorLine", { underline = true })  -- 只显示下划线，不加背景
-- 或者加浅色背景（取消注释下面这行）：
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2a2a3a" })

-- 设置主题
vim.cmd[[colorscheme lunaperche]]
vim.api.nvim_set_hl(0, 'Comment', { fg = '#6a9955', italic = true})
