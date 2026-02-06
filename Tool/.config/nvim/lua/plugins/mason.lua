-- ===================================
-- 外挂包管理器相关
-- ===================================
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "clangd"},
    automatic_installation = true,  -- 未来加新Server自动安装
})
