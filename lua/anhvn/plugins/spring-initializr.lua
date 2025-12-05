return {
    {
        "jkeresman01/spring-initializr.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-telescope/telescope.nvim",
        },
        opts = {},
        cmd = { "SpringInitializr", "SpringGenerateProject" },
        keys = {
            { "<leader>si", "<cmd>SpringInitializr<cr>", desc = "Spring Initializr" },
            { "<leader>sg", "<cmd>SpringGenerateProject<cr>", desc = "Spring Generate Project" },
        },
    },
}
