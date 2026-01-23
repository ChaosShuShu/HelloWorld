-- ===================================
-- LSP及自动补全配置
-- ===================================
-- 0 自动启动LSP服务器
--
-- 0.1 配置clangd
vim.lsp.config('clangd', {                                            -- 为cpp配置cland
    cmd = {'clangd'},
    filetypes   =   { "c", "cpp", "h", "hpp" },
    capabilities = require('cmp_nvim_lsp').default_capabilities(),  --  启用cmp补全
    settings    =   {
        clangd  =   {
            fallbackFlags   =   { 'std-c++11' },
        },
    },
    -- clangd 找项目根的关键
    root_markers    =   {
        '.clangd', 'compile_commands.json', 'compile_flags.txt', 'build/compile_commands.json', '.git',
    },
})
vim.lsp.enable('clangd')

-- 0.1 配置lua_ls
vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' }, 
    filetypes   =   { 'lua' },
    settings    =   {
        diagnostics = {
            globals = { 'vim' },
        },
    },
})
vim.lsp.enable('lua_ls')
