-- ~/.config/nvim/init.lua

-- Установка лидера на пробел
vim.g.mapleader = " "

-- Установка lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Функция для закрытия дерева, если оно открыто
local function close_tree_if_open()
    local tree_windows = vim.tbl_filter(function(win)
        local buf = vim.api.nvim_win_get_buf(win)
        local bufname = vim.api.nvim_buf_get_name(buf)
        return bufname:match("NvimTree") ~= nil
    end, vim.api.nvim_list_wins())
    
    if #tree_windows > 0 then
        vim.cmd("NvimTreeClose")
    end
end

-- Функция для открытия файла с автоматическим закрытием дерева
local function open_file_and_close_tree(open_func)
    return function()
        open_func()
        close_tree_if_open()
    end
end

-- Плагины
require("lazy").setup({
    -- Pi агент
    {
        "carderne/pi-nvim",
        lazy = false,
        config = function()
            require("pi-nvim").setup()
        end,
    },

    -- Цветовая схема
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "night",
                transparent = false,
            })
            vim.cmd("colorscheme tokyonight-night")
        end,
    },

    -- Статусбар
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({ options = { theme = "tokyonight" } })
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local ok, treesitter = pcall(require, "nvim-treesitter.configs")
            if not ok then
                vim.notify("Treesitter not ready yet", vim.log.levels.WARN)
                return
            end
            treesitter.setup({
                ensure_installed = { "go", "typescript", "tsx", "javascript", "json", "css", "html", "lua" },
                highlight = { enable = true },
                indent = { enable = true },
                autotag = { enable = true },
            })
        end,
    },

    -- Автозакрытие JSX тегов
    {
        "windwp/nvim-ts-autotag",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact" },
        config = function()
            local ok, autotag = pcall(require, "nvim-ts-autotag")
            if ok then
                autotag.setup()
            end
        end,
    },

    -- Автозакрытие скобок
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },

    -- Mason
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "gopls", "ts_ls", "cssls", "html" },
                automatic_installation = true,
            })
        end,
    },

    -- nvim-cmp
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },

    -- LSP конфиги
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.lsp.config("gopls", {
                cmd = { "gopls" },
                capabilities = capabilities,
                settings = {
                    gopls = {
                        analyses = { unusedparams = true },
                        staticcheck = true,
                    },
                },
            })

            vim.lsp.config("ts_ls", {
                cmd = { "typescript-language-server", "--stdio" },
                capabilities = capabilities,
                filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
            })

            vim.lsp.config("cssls", {
                cmd = { "css-languageserver", "--stdio" },
                capabilities = capabilities,
                filetypes = { "css", "scss", "less" },
            })

            vim.lsp.config("html", {
                cmd = { "html-languageserver", "--stdio" },
                capabilities = capabilities,
                filetypes = { "html", "htmldjango" },
            })

            vim.lsp.enable({ "gopls", "ts_ls", "cssls", "html" })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local opts = { buffer = args.buf }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover docs" }))
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
                    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, vim.tbl_extend("force", opts, { desc = "Format file" }))
                    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Prev diagnostic" }))
                    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
                end,
            })
        end,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "Telescope",
        config = function()
            require("telescope").setup({
                defaults = {
                    file_ignore_patterns = { "node_modules", ".git" },
                },
            })
        end,
    },

    -- Gitsigns
    {
        "lewis6991/gitsigns.nvim",
        event = "BufRead",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "│" },
                    change = { text = "│" },
                    delete = { text = "_" },
                },
                current_line_blame = true,
            })
        end,
    },

    -- Diffview
    {
        "dlyongemallo/diffview.nvim",
        version = "*",
        cmd = "DiffviewOpen",
        config = function()
            require("diffview").setup({
                enhanced_diff_hl = true,
                use_icons = true,
                view = {
                    default = { layout = "diff2_horizontal" },
                    merge_tool = { layout = "diff3_horizontal" },
                },
                file_panel = {
                    listing_style = "tree",
                    win_config = { position = "left", width = 35 },
                },
            })
        end,
    },

    -- Файловый навигатор
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "NvimTreeToggle",
        config = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            vim.opt.termguicolors = true

            require("nvim-tree").setup({
                on_attach = function(bufnr)
                    local api = require("nvim-tree.api")
                    vim.keymap.set('n', 'q', api.tree.close, { buffer = bufnr, desc = "Close tree" })
                    vim.keymap.set('n', '<CR>', open_file_and_close_tree(function() api.node.open.edit() end), { buffer = bufnr, desc = "Open file" })
                    vim.keymap.set('n', 'o', open_file_and_close_tree(function() api.node.open.edit() end), { buffer = bufnr, desc = "Open file" })
                    vim.keymap.set('n', 'v', function() api.node.open.vertical() end, { buffer = bufnr, desc = "Vertical split" })
                    vim.keymap.set('n', 's', function() api.node.open.horizontal() end, { buffer = bufnr, desc = "Horizontal split" })
                end,
                sort = { sorter = "case_sensitive" },
                view = { width = 30, side = "left", preserve_window_proportions = true },
                renderer = {
                    group_empty = true,
                    highlight_git = true,
                    icons = { show = { git = true, folder = true, file = true, folder_arrow = true } },
                },
                filters = { dotfiles = false, custom = { ".git$" } },
                git = { ignore = false },
            })
        end,
    },

    -- Which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        config = function()
            require("which-key").setup({
                preset = "modern",
                plugins = {
                    marks = true,
                    registers = true,
                    presets = {
                        operators = true, motions = true, text_objects = true,
                        windows = true, nav = true, z = true, g = true,
                    },
                },
            })
        end,
    },
})

-- ─── Горячие клавиши ──────────────────────────────────────────────────────────

-- Diffview
local function toggle_diffview()
    if next(require("diffview.lib").views) == nil then
        vim.cmd("DiffviewOpen")
    else
        vim.cmd("DiffviewClose")
    end
end

vim.keymap.set("n", "<leader>d", toggle_diffview, { desc = "Toggle Diffview" })
vim.keymap.set("n", "<leader>в", toggle_diffview, { desc = "Toggle Diffview (русская раскладка)" })

-- File tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>у", ":NvimTreeToggle<CR>", { desc = "Toggle file tree (русская раскладка)" })

-- Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>аа", "<cmd>Telescope find_files<CR>", { desc = "Find files (русская раскладка)" })

vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>ап", "<cmd>Telescope live_grep<CR>", { desc = "Live grep (русская раскладка)" })

vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>аи", "<cmd>Telescope buffers<CR>", { desc = "Buffers (русская раскладка)" })

vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
-- help_tags использует ту же клавишу "ап" (fg), поэтому дублируем так:
vim.keymap.set("n", "<leader>ап", "<cmd>Telescope help_tags<CR>", { desc = "Help tags (русская раскладка)" })

-- LSP действия
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>кт", vim.lsp.buf.rename, { desc = "Rename (русская раскладка)" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>вф", vim.lsp.buf.code_action, { desc = "Code action (русская раскладка)" })

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format file" })
vim.keymap.set("n", "<leader>а", vim.lsp.buf.format, { desc = "Format file (русская раскладка)" })

-- Pi агент (главный хоткей) - исправленная версия
vim.keymap.set("n", "<leader>p", function()
    -- Пробуем разные варианты
    vim.cmd("Pi")  -- Команда :PI
    -- Или vim.cmd("Pi")  -- Команда :Pi
    -- Или vim.cmd("PIToggle")  -- Команда :PIToggle
end, { desc = "Open PI agent" })

vim.keymap.set("n", "<leader>з", function()
    vim.cmd("Pi")  -- Та же команда для русской раскладки
end, { desc = "Open PI agent (русская раскладка)" })

-- Навигация между окнами через Ctrl+hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })


-- Прозрачный фон для Neovim
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

-- Для боковых панелей (если используете)
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- ─── Базовые настройки ────────────────────────────────────────────────────────
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 250
vim.opt.mouse = "a"

vim.opt.shortmess:append("c")

-- Установка деревьев парсеров после загрузки
vim.defer_fn(function()
    pcall(vim.cmd, "TSInstallSync go")
    pcall(vim.cmd, "TSInstallSync typescript")
    pcall(vim.cmd, "TSInstallSync javascript")
    pcall(vim.cmd, "TSInstallSync lua")
end, 1000)
