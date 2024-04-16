return {
    'simrat39/rust-tools.nvim',
    opts = function()
        local mason_registry = require("mason-registry")
        local path = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
        local codelldb_path = path .. "adapter/codelldb"
        local liblldb_path = path .. "lldb/lib/liblldb.so"
        return {
            server = {
                on_attach = function(_, bufnr)
                    local rt = require("rust-tools")
                    -- Hover actions
                    vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                    -- Code action groups
                    vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                end,
            },
            dap = {
                adapter = require('rust-tools.dap').get_codelldb_adapter(
                    codelldb_path, liblldb_path)
            },
        }
    end
}
