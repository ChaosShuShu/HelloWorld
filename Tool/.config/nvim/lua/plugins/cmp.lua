-- 设置cmp补全引擎
local cmp = require('cmp')
require('cmp').setup {
    mapping = {
        ['<C-j>']   = cmp.mapping.select_next_item(),             -- Ctrl+j 下移候选列表
        ['<C-k>']   = cmp.mapping.select_prev_item(),             -- Ctrl+k 上移候选列表
        ['<Enter>']    = cmp.mapping.confirm({ select = true }),       -- Enter 确认选中
        ['<C-e>']   = cmp.mapping.abort(),                          -- Ctrl+e 取消选中
    },
    sources = {
        { name = 'nvim_lsp' },                                      -- 从lsp获取智能补全建议
        { name = 'buffer' },                                        -- 从当前文件内容补全
    }
}
