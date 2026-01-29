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

------------------------------------------
-- 搜索时忽略大小写，除非搜索内容包含大写
vim.o.ignorecase = true
vim.o.smartcase = true

-- 关闭备份文件和 swap 文件（可选，很多人喜欢干净）
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- 更好的滚动体验
vim.o.scrolloff = 40        -- 光标上下保留至少 5 行

-- 让 Backspace 和 Tab 行为模拟真实 Tab（一次性处理 4 个空格）
vim.o.tabstop = 4          -- Tab 显示宽度为 4
vim.o.shiftwidth = 4       -- >>、<<、自动缩进时移动 4 个空格
vim.o.softtabstop = 4      -- 关键！Backspace 和 Tab 一次处理 4 个空格
vim.o.expandtab = true     -- 输入 Tab 时插入 4 个空格（而不是 \t）
vim.o.smarttab = true      -- 行首 Tab 使用 shiftwidth 宽度

vim.diagnostic.config({ virtual_text = true })      -- 行尾显示诊断信息
