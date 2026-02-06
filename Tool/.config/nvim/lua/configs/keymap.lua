-- opts = {
--      noremap =   true,   -- 防止递归映射
--      silent  =   true,   -- 不显示命令在command-line
--      expr    =   true,   -- rhs是表达式
--      desc   =   "move UP",   --  描述
--      nowait  =   true,   -- 不等超时
--      }

-- ===========================
-- Global Keymap
-- ===========================
vim.g.mapleader         =   " "     -- 空格设为<leader>键
vim.g.maplocalleader    =   " "     -- 

-- ===========================
-- Normal Mode Keymap
-- ===========================
-- vim.keymap.set('n', 'H', '5h', {noremap = true, silent = true, desc = 'move left 5 lines'})
-- vim.keymap.set('n', 'L', '5l', {noremap = true, silent = true, desc = 'move right 5 lines'})
vim.keymap.set('n', 'J', '5j', {noremap = true, silent = true, desc = 'move down 5 lines'})
vim.keymap.set('n', 'K', '5k', {noremap = true, silent = true, desc = 'move up 5 lines'})

-- ===========================
-- Visual Mode Keymap
-- ===========================
vim.keymap.set('v', '<C-c>', '"+y', {noremap = true, silent = true, desc = 'Copy to System clipboard'})

-- ===========================
-- LSP Keymap
-- ===========================
vim.api.nvim_create_autocmd("LspAttach", {  -- event:LspAttach 触发时自动执行
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback    =   function (ev)   -- 事件触发时执行的函数
        local   opts    ={ buffer = ev.buf, noremap = true, silent = true}
        
        vim.keymap.set("n", "gd", vim.lsp.buf.definition,               { buffer = ev.buf, noremap = true, silent = true, desc = "[LSP]: Go to definition"})
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration,               { buffer = ev.buf, noremap = true, silent = true, desc = "[LSP]: Go to declaration"})
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation,               { buffer = ev.buf, noremap = true, silent = true, desc = "[LSP]: Go to implemtntation"})
        vim.keymap.set("n", "gr", vim.lsp.buf.references,               { buffer = ev.buf, noremap = true, silent = true, desc = "[LSP]: Go to reference"})
        vim.keymap.set('n', 'gk', vim.lsp.buf.hover,                    { buffer = ev.buf, noremap = true, silent = true, desc = '[LSP]: hover'})
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,                    { buffer = ev.buf, noremap = true, silent = true, desc = '[LSP]: Code Action'})
        vim.keymap.set('n', '<leader>rn', "<cmd>Lspsaga rename<CR>",                    { buffer = ev.buf, noremap = true, silent = true, desc = '[LSPsaga]: Rename symbol(with preview)'})
    end,
})
