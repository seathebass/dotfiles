-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
vim.keymap.set("n", "<space>n", "<Cmd>Neotree toggle<CR>")
vim.keymap.set("n", "<Leader>fg", "<Cmd> Telescope live_grep<cr>")

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "r" },
    group = vim.api.nvim_create_augroup("r_keymaps", { clear = true }),
    callback = function()
        vim.keymap.set("i", "<C-a>", "<Space><-<Space>")
        vim.keymap.set("i", "<C-p>", "<Space>|><Enter>")
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({ bufnr = args.buf })
    end,
})

-- some yarepl keyboard bindings
local ft_to_repl = {
    r = "radian",
    rmd = "radian",
    quarto = "radian",
    markdown = "radian",
    ["markdown.pandoc"] = "radian",
    python = "ipython",
    sh = "bash",
    REPL = "",
    julia = "julia",
}

local bufmap = vim.api.nvim_buf_set_keymap

local function run_cmd_with_count(cmd)
    return function()
        vim.cmd(string.format("%d%s", vim.v.count, cmd))
    end
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "r", "quarto", "markdown", "markdown.pandoc", "rmd", "python", "sh", "REPL", "julia" },
    desc = "set up REPL keymap",
    callback = function()
        local repl = ft_to_repl[vim.bo.filetype]
        bufmap(0, "n", "<leader>rs", "", {
            callback = run_cmd_with_count("REPLStart " .. repl),
            desc = "Start a REPL",
        })
        bufmap(0, "n", "<leader>rf", "", {
            callback = run_cmd_with_count("REPLFocus"),
            desc = "Focus on REPL",
        })
        bufmap(0, "n", "<leader>rv", "<CMD>Telescope REPLShow<CR>", {
            desc = "View REPLs in telescope",
        })
        bufmap(0, "n", "<leader>rh", "", {
            callback = run_cmd_with_count("REPLHide"),
            desc = "Hide REPL",
        })
        bufmap(0, "v", "<leader>s", "", {
            callback = run_cmd_with_count("REPLSendOperator"),
            desc = "Send visual region to REPL",
        })
        bufmap(0, "n", "<leader>ss", "", {
            callback = run_cmd_with_count("REPLSendLine"),
            desc = "Send current line to REPL",
        })
        -- `<leader>sap` will send the current paragraph to the
        -- buffer-attached REPL, or REPL 1 if there is no REPL attached.
        -- `2<Leader>sap` will send the paragraph to REPL 2. Note that `ap` is
        -- just an example and can be replaced with any text object or motion.
        bufmap(0, "n", "<leader>s", "", {
            callback = run_cmd_with_count("REPLSendOperator"),
            desc = "Send motion to REPL",
        })
        bufmap(0, "n", "<leader>rq", "", {
            callback = run_cmd_with_count("REPLClose"),
            desc = "Quit REPL",
        })
        bufmap(0, "n", "<leader>rc", "<CMD>REPLCleanup<CR>", {
            desc = "Clear REPLs.",
        })
        bufmap(0, "n", "<leader>rS", "<CMD>REPLSwap<CR>", {
            desc = "Swap REPLs.",
        })
        bufmap(0, "n", "<leader>r?", "", {
            callback = run_cmd_with_count("REPLStart"),
            desc = "Start an REPL from available REPL metas",
        })
        bufmap(0, "n", "<leader>ra", "<CMD>REPLAttachBufferToREPL<CR>", {
            desc = "Attach current buffer to a REPL",
        })
        bufmap(0, "n", "<leader>rd", "<CMD>REPLDetachBufferToREPL<CR>", {
            desc = "Detach current buffer to any REPL",
        })
    end,
})
