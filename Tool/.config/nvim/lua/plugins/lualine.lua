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

