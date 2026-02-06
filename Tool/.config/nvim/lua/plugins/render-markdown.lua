-- Render Markdown
return{
    "MeanderingProgrammer/render-markdown.nvim",
    config      =   function()
        require("render-markdown").setup({
            heading     =   { enabled = true },
            code        =   { enabled = true, style = "full" },
            bullet      =   { enabled = true },
            checkbox    =   { enabled = true },
            quote       =   { enabled = true },
            pipe_table  =   { enabled = true },
            callout     =   { enabled = true },
            link        =   { enabled = true },
            image       =   { enabled = true },
            sign        =   { enabled = true },
            
            --  打开treesitter配合
            max_file_size   =   1.5,
            file_types      =   { "markdown", "quarto", "rmd" },
        })
    end,
}
