set encoding=utf-8
set fileencoding=utf-8

call plug#begin('~/.local/share/nvim/bundle/')
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
" Install nvim-cmp
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'jc-doyle/cmp-pandoc-references'
Plug 'kdheepak/cmp-latex-symbols'
Plug 'L3MON4D3/LuaSnip'
" Dashboard at start
Plug 'goolord/alpha-nvim'
" Zen mode plugin
Plug 'Pocco81/TrueZen.nvim'
"indents
Plug 'lukas-reineke/indent-blankline.nvim'
" plugin to manage formatting neovim
Plug 'jose-elias-alvarez/null-ls.nvim'
" git plugins
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
"Treesitter
Plug 'nvim-treesitter/nvim-treesitter'
" Quarto
Plug 'quarto-dev/quarto-nvim'
Plug 'jmbuhr/otter.nvim'
" vim telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'BurntSushi/ripgrep'
Plug 'kyazdani42/nvim-tree.lua'
Plug  'nvim-tree/nvim-web-devicons'
" nvim dap stuff
Plug 'mfussenegger/nvim-dap'
Plug 'simrat39/rust-tools.nvim'
Plug 'rcarriga/nvim-dap-ui'
" General theming matters
Plug 'olimorris/onedarkpro.nvim'
Plug 'nvimdev/galaxyline.nvim'
" General REPL 
Plug 'milanglacier/yarepl.nvim'
call plug#end()
function Myfoldtext()
    let line = getline(v:foldstart)
    let sub = substitute(line,'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)'
    return v:folddashes .. sub
endfunction
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set indentexpr=nvim_treesitter#indent()
set foldtext=Myfoldtext()
set fillchars="fold:\"
set foldnestmax=9
set foldminlines=1
set tabstop=8 
set softtabstop=0 
set expandtab 
set shiftwidth=4 
set smarttab
" default indentation settings
set shiftround
set shell=bash " fix the shell to something vim understand

set number " show line numbers

set fileformats=unix,dos,mac " set newline preferences
" Dashboard entries
let g:mapleader="\<Space>"

set clipboard+=unnamedplus
" ensure that ctrl+u in insert mode can be reversed
" http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" allow mouse control
set mouse=a

" put leader to space
map <space> <leader>
map <space><space> <leader><leader>
set completeopt = "menuone,noselect"

" color scheme
set termguicolors
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeToggle<CR>
augroup vim-colors
    autocmd!
augroup END
" terminal configurations 
autocmd TermOpen * setlocal nonumber norelativenumber

" lua for a bunch of configs 
lua << EOF
lspconfig = require("lspconfig")
require("mason").setup()
mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup()
lspconfig["r_language_server"].setup{}
lspconfig["julials"].setup{}
lspconfig["vimls"].setup{}
lspconfig["pyright"].setup{}
lspconfig["lua_ls"].setup{}
lspconfig["yamlls"].setup{}
lspconfig["sqlls"].setup{}
lspconfig["ltex"].setup{
        filetypes = { "quarto","rmd","latex", "tex", "bib", "markdown", "gitcommit" },
        settings = {
            ltex = {
                enabled = {"quarto" ,"rmd","latex", "tex", "bib", "markdown"},
                additionalRules = {
                        languageModel = {"$HOME/.ngram-plug/en/"},
                    },
                language = "en-US",
                },
         },
    }
require 'otter.config'.setup {}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

local cmp = require("cmp")

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local luasnip = require("luasnip")
if not luasnip then return end
local lsp_symbols = {
Text = "   (Text) ",
Method = "   (Method)",
Function = "   (Function)",
Constructor = "   (Constructor)",
Field = " ﴲ  (Field)",
Variable = "[] (Variable)",
Class = "   (Class)",
Interface = " ﰮ  (Interface)",
Module = "   (Module)",
Property = " 襁 (Property)",
Unit = "   (Unit)",
Value = "   (Value)",
Enum = " 練 (Enum)",
Keyword = "   (Keyword)",
Snippet = "   (Snippet)",
Color = "   (Color)",
File = "   (File)",
Reference = "   (Reference)",
Folder = "   (Folder)",
EnumMember = "   (EnumMember)",
Constant = " ﲀ  (Constant)",
Struct = " ﳤ  (Struct)",
Event = "   (Event)",
Operator = "   (Operator)",
TypeParameter = "   (TypeParameter)",
}

require'cmp'.setup.cmdline(':', {
  sources = {
    { name = 'cmdline' }
  }
})

cmp.setup.filetype({"tex","rmd","markdown","quarto"},
    {sources = cmp.config.sources({
    {name = "latex_symbols",
      option = {
        strategy = 2, -- latex 
        }
      },
    { name = "buffer" },
    { name = "nvim_lsp" },
    { name = "nvim_lua"},
    { name = "path"},
    { name = "luasnip" },
    { name = "pandoc_references"},
    { name = "otter"}
    }),
    mapping = {
 
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
      -- they way you will only jump inside the snippet region
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),  
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    formatting = {
        format = function(entry, item)
            item.kind = lsp_symbols[item.kind]
            item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                neorg = "[Neorg]",
            })[entry.source.name]

            return item
        end,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    })

cmp.setup({
    sources = {
        { name = "buffer" },
        { name = "nvim_lsp" },
        { name = "nvim_lua"},
        { name = "path"},
        { name = "luasnip" },
        { name = "pandoc_references"},
        { name = "otter"}
    },
    mapping = {
 
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
      -- they way you will only jump inside the snippet region
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),  
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    formatting = {
        format = function(entry, item)
            item.kind = lsp_symbols[item.kind]
            item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                neorg = "[Neorg]",
            })[entry.source.name]

            return item
        end,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
})

local M = {}
M.signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(M.signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
    underline = true,
    signs = true,
    virtual_text = false,
})

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.markdown.filetype_to_parsername = "rmd"
require'nvim-treesitter.configs'.setup{
   indent = {
    enable = true
  },
  highlight = {
      enable = true
  },
  incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-n>",
        node_incremental = "<C-n>",
        scope_incremental = "<C-s>",
        node_decremental = "<C-r>",
      },
    },
}
local actions = require("telescope.actions")
require "telescope".setup {
    file_ignore_patterns = { "node_modules", ".git" }
    }
require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}
local null_ls = require 'null-ls'
null_ls.setup({
     sources = {
        null_ls.builtins.formatting.styler,
        null_ls.builtins.formatting.rustfmt,
        null_ls.builtins.formatting.prettier.with({
            filetypes = {"markdown","rmarkdown","pandoc","rmd","quarto"},
            args = {"--std-filepath","$FILENAME","--prose-wrap", "always","--parser", "markdown"}
        }),
        null_ls.builtins.formatting.autopep8
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
		    vim.lsp.buf.format({bufnr = bufnr})
                end,
            })
        end
    end,
})
local dap = require("dap")
require "nvim-web-devicons".setup{}
dap.adapters.lldb = {
	type = "executable",
	command = "/home/seabass/.local/share/nvim/mason/bin/codelldb",
	name = "lldb",
}
dap.configurations.rust = {
	lldb
	}
require('onedarkpro').setup({
    options = {
        cursorline = true,
        bold = true
        },
    styles = {
        functions = "bold"
        }
})

local extension_path = vim.env.HOME .. '/.local/share/nvim/mason/packages/codelldb/extension/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
local rt = require("rust-tools")
local opts = {
    -- ... other configs
    dap = {
        adapter = require('rust-tools.dap').get_codelldb_adapter(
            codelldb_path, liblldb_path)
    }
}
rt.setup(opts)
local yarepl = require 'yarepl'

yarepl.setup {
    -- see `:h buflisted`, whether the REPL buffer should be buflisted.
    buflisted = true,
    -- whether the REPL buffer should be a scratch buffer.
    scratch = true,
    -- the filetype of the REPL buffer created by `yarepl`
    ft = 'REPL',
    -- How yarepl open the REPL window, can be a string or a lua function.
    -- See below example for how to configure this option
    wincmd = 'vertical 100 split',
    -- The available REPL palattes that `yarepl` can create REPL based on
    metas = {
        aichat = { cmd = 'aichat', formatter = yarepl.formatter.bracketed_pasting },
        radian = { cmd = 'radian', formatter = yarepl.formatter.bracketed_pasting },
        ipython = { cmd = 'ipython', formatter = yarepl.formatter.bracketed_pasting },
        python = { cmd = 'python', formatter = yarepl.formatter.trim_empty_lines },
        R = { cmd = 'R', formatter = yarepl.formatter.trim_empty_lines },
        julia = {cmd = 'julia',formatter = yarepl.formatter.trim_empty_lines},
        -- bash version >= 4.4 supports bracketed paste mode. but macos
        -- shipped with bash 3.2, so we don't use bracketed paste mode for
        -- bash.
        bash = { cmd = 'bash', formatter = yarepl.formatter.trim_empty_lines }
    },
    -- when a REPL process exits, should the window associated with those REPLs closed?
    close_on_exit = true,
    -- whether automatically scroll to the bottom of the REPL window after sending
    -- text? This feature would be helpful if you want to ensure that your view
    -- stays updated with the latest REPL output.
    scroll_to_bottom_after_sending = true
}

local function run_cmd_with_count(cmd)
    return function()
        vim.cmd(string.format('%d%s', vim.v.count, cmd))
    end
end

local keymap = vim.api.nvim_set_keymap
local bufmap = vim.api.nvim_buf_set_keymap


local ft_to_repl = {
    r = 'radian',
    rmd = 'radian',
    quarto = 'radian',
    markdown = 'radian',
    ['markdown.pandoc'] = 'radian',
    python = 'ipython',
    sh = 'bash',
    REPL = '',
    julia = 'julia'
}
local autocmd = vim.api.nvim_create_autocmd
autocmd('FileType', {
    pattern = {'r', 'quarto', 'markdown', 'markdown.pandoc', 'rmd', 'python', 'sh', 'REPL' ,'julia'},
    group = my_augroup,
    desc = 'set up REPL keymap',
    callback = function()
        local repl = ft_to_repl[vim.bo.filetype]
        bufmap(0, 'n', '<leader>rs', '', {
            callback = run_cmd_with_count('REPLStart ' .. repl),
            desc = 'Start a REPL',
        })
        bufmap(0, 'n', '<leader>rf', '', {
            callback = run_cmd_with_count 'REPLFocus',
            desc = 'Focus on REPL',
        })
        bufmap(0, 'n', '<leader>rv', '<CMD>Telescope REPLShow<CR>', {
            desc = 'View REPLs in telescope',
        })
        bufmap(0, 'n', '<leader>rh', '', {
            callback = run_cmd_with_count 'REPLHide',
            desc = 'Hide REPL',
        })
        bufmap(0, 'v', '<leader>s', '', {
            callback = run_cmd_with_count 'REPLSendVisual',
            desc = 'Send visual region to REPL',
        })
        bufmap(0, 'n', '<leader>ss', '', {
            callback = run_cmd_with_count 'REPLSendLine',
            desc = 'Send current line to REPL',
        })
        -- `<leader>sap` will send the current paragraph to the
        -- buffer-attached REPL, or REPL 1 if there is no REPL attached.
        -- `2<Leader>sap` will send the paragraph to REPL 2. Note that `ap` is
        -- just an example and can be replaced with any text object or motion.
        bufmap(0, 'n', '<leader>s', '', {
            callback = run_cmd_with_count 'REPLSendMotion',
            desc = 'Send motion to REPL',
        })
        bufmap(0, 'n', '<leader>rq', '', {
            callback = run_cmd_with_count 'REPLClose',
            desc = 'Quit REPL',
        })
        bufmap(0, 'n', '<leader>rc', '<CMD>REPLCleanup<CR>', {
            desc = 'Clear REPLs.',
        })
        bufmap(0, 'n', '<leader>rS', '<CMD>REPLSwap<CR>', {
            desc = 'Swap REPLs.',
        })
        bufmap(0, 'n', '<leader>r?', '', {
            callback = run_cmd_with_count 'REPLStart',
            desc = 'Start an REPL from available REPL metas',
        })
        bufmap(0, 'n', '<leader>ra', '<CMD>REPLAttachBufferToREPL<CR>', {
            desc = 'Attach current buffer to a REPL',
        })
        bufmap(0, 'n', '<leader>rd', '<CMD>REPLDetachBufferToREPL<CR>', {
            desc = 'Detach current buffer to any REPL',
        })
    end,
})
require('telescope').load_extension 'REPLShow'
require('onedarkpro').load()
require("nvim-tree").setup()
require("nvim-web-devicons").setup()
require'alpha'.setup(require'alpha.themes.dashboard'.opts)
require("gitsigns").setup()

local status_ok, gl = pcall(require, 'galaxyline')
if not status_ok then
	print("Couldn't load 'galaxyline'")
	return
end

local colors = require('galaxyline.theme').default
local condition = require('galaxyline.condition')

gl.short_line_list = { 'NvimTree', 'Outline', 'Trouble', 'qf', }

colors.green    = "#118822"
colors.blue     = "#4466aa"
colors.red      = "#aa4422"
colors.grayblue = "#283034"
colors.gray     = "#767676"
colors.none = function()
	local sl = vim.api.nvim_get_hl_by_name('StatusLine', true)
	local color = sl.reverse and sl.foreground or sl.background
	return color and string.format("#%x", color) or "NONE"
end

local separators = {
	right      = ' ',
	left       = '',
	right_thin = ' ',
	left_thin  = ' ',
}

local function buffer_not_empty()
	return #vim.fn.expand('%:t') > 0
end

---@param width integer
local function window_wider_than(width)
	return vim.fn.winwidth(0) >= width
end

---@param width integer
local function can_show_git_at(width)
	return function()
		return buffer_not_empty() and window_wider_than(width) and condition.check_git_workspace()
	end
end

local sections = { left = 0, mid = 0, right = 0, short_line_left = 0, short_line_right = 0, }
local function section(pos, tbl)
	sections[pos] = sections[pos] + 1
	gl.section[pos][sections[pos]] = tbl
end

--- Defines the highlight colors for a section of GalaxyLine
---@class VimMode
---@field text string?
---@field fg string
---@field bg string

local modes = {
	n       = { text = "NORMAL", fg = colors.bg, bg = colors.yellow, },      ---@type VimMode
	i       = { text = "INSERT", bg = colors.green, },                       ---@type VimMode
	v       = { text = "VISUAL", bg = colors.blue, },                        ---@type VimMode
	V       = { text = "VISUAL-LINE", bg = colors.blue, },                   ---@type VimMode
	['']  = { text = "VISUAL-BLOCK", bg = colors.blue, },                  ---@type VimMode
	S       = { text = "SELECT-LINE", bg = colors.red, },                    ---@type VimMode
	['']  = { text = "SELECT-BLOCK", bg = colors.red, },                   ---@type VimMode
	c       = { text = "COMMAND", fg = colors.bg, bg = colors.blue, },       ---@type VimMode
	R       = { text = "REPLACE", bg = colors.red, },                        ---@type VimMode
	r       = { text = "PRESS ENTER", fg = colors.bg, bg = colors.green, },  ---@type VimMode
	t       = { text = "TERMINAL", fg = colors.bg, bg = colors.red, },       ---@type VimMode
	default = { text = nil, fg = colors.bg, bg = colors.red, },              ---@type VimMode
}
for m, _ in pairs(modes) do
	modes[m] = vim.tbl_extend("keep", modes[m], { fg = colors.fg, bg = colors.bg })
end

local function ViModeLeftSection()
	---@type VimMode
	local vimode = modes.n

	section('left', {
		Vim = {
			provider = function() return ' ' end,
			highlight = { colors.green, colors.bg },
		}
	})
	section('left', {
		VimSeparator = {
			provider = function()
				vimode = modes[vim.fn.mode()] or modes.default
				vim.api.nvim_command('hi GalaxyVimSeparator guifg=' .. colors.bg .. ' guibg=' .. vimode.bg)
				return separators.right
			end,
		}
	})
	section('left', {
		ViMode = {
			provider = function()
				vim.api.nvim_command('hi GalaxyViMode gui=BOLD guifg=' .. vimode.fg .. ' guibg=' .. vimode.bg)
				return vimode.text or vim.fn.mode(1)
			end,
		}
	})
	section('left', {
		ViModeSeparator = {
			provider = function()
				local bgcolor = (buffer_not_empty() and condition.check_git_workspace()) and colors.bg or colors.none()
				vim.api.nvim_command('hi GalaxyViModeSeparator guifg=' .. vimode.bg .. ' guibg=' .. bgcolor)
				return separators.right
			end,
		}
	})
end
ViModeLeftSection()

section('left', {
	GitBranch = {
		condition = can_show_git_at(60),
		provider = function()
			return require('galaxyline.provider_vcs').get_git_branch()
		end,
		icon = '  ',
		highlight = { colors.orange, colors.bg },
		separator = separators.right,
		separator_highlight = { colors.bg, colors.none },
	}
})
local function GitChanges()
	local vcs = require('galaxyline.provider_vcs')
	section('left', {
		GitDiffs = {
			condition = can_show_git_at(90),
			provider = function()
				local diffs = vcs.diff_modified()
				return (diffs and '~'..diffs or '')
			end,
			highlight = { colors.blue, colors.none },
		}
	})
	section('left', {
		GitAdds = {
			condition = can_show_git_at(90),
			provider = function()
				local adds = vcs.diff_add()
				return (adds and '+'..adds or '')
			end,
			highlight = { colors.green, colors.none },
		}
	})
	section('left', {
		GitRems = {
			condition = can_show_git_at(90),
			provider = function()
				local rems = vcs.diff_remove()
				return (rems and '-'..rems or '')
			end,
			highlight = { colors.red, colors.none },
		}
	})
end
GitChanges()

section('mid', {
	FileInformationPre = {
		condition = buffer_not_empty,
		provider = function() return separators.left end,
		highlight = { colors.grayblue, colors.none },
	}
})
section('mid', {
	FileIcon = {
		condition = buffer_not_empty,
		provider = 'FileIcon',
		highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color, colors.grayblue },
	}
})
section('mid', {
	FileName = {
		condition = buffer_not_empty,
		provider = function()
			return vim.fn.expand('%:.') .. ' '
		end,
		highlight = { colors.fg, colors.grayblue, },
	}
})
section('mid', {
	FileModified = {
		condition = buffer_not_empty,
		provider = function() return vim.bo.modified and 'פֿ ' or '' end,
		highlight = { colors.yellow, colors.grayblue },
	}
})
section('mid', {
	FileReadOnly = {
		condition = function() return buffer_not_empty() and vim.bo.readonly end,
		provider = function() return '' end,
		separator = ' ',
		highlight = { colors.red, colors.grayblue },
		separator_highlight = { colors.red, colors.grayblue },
	}
})

local function LspMidSection()
	local lsp_active = false
	section('mid', {
		LspServerSeparator = {
			condition = function() return window_wider_than(75) and buffer_not_empty() end,
			provider = function()
				lsp_active = next(vim.lsp.buf_get_clients()) ~= nil
				return lsp_active and separators.right_thin or ''
			end,
			highlight = { colors.none, colors.grayblue, 'bold' },
		}
	})
	section('mid', {
		LspServerName = {
			condition = function() return window_wider_than(75) and buffer_not_empty() end,
			provider = function()
				return lsp_active and require('galaxyline.provider_lsp').get_lsp_client() or ''
			end,
			icon = ' ',
			highlight = { colors.violet, colors.grayblue },
		}
	})
end
LspMidSection()

section('mid', {
	FileInformationPost = {
		condition = buffer_not_empty,
		provider = function() return separators.right end,
		highlight = { colors.grayblue, colors.none },
	}
})

local function Diagnostics()
	local diagnostics = {}
	section('mid', {
		DiagnosticErrors = {
			condition = function() return window_wider_than(60) and buffer_not_empty() end,
			provider = function()
				diagnostics = vim.diagnostic.get(0)
				local errors = vim.tbl_filter(function(d)
					return d.severity == vim.diagnostic.severity.ERROR
				end, diagnostics)
				if #errors > 0 then
					return ' ' .. #errors .. ' '
				end
				return ''
			end,
			highlight = { colors.red, colors.none, },
		}
	})
	section('mid', {
		DiagnosticWarnings = {
			condition = function() return window_wider_than(60) and buffer_not_empty() end,
			provider = function()
				local warnings = vim.tbl_filter(function(d)
					return d.severity == vim.diagnostic.severity.WARN
				end, diagnostics)
				if #warnings > 0 then
					return ' ' .. #warnings .. ' '
				end
				return ''
			end,
			highlight = { colors.orange, colors.none, },
		}
	})
	section('mid', {
		DiagnosticInfo = {
			condition = function() return window_wider_than(60) and buffer_not_empty() end,
			provider = function()
				local info = vim.tbl_filter(function(d)
					return d.severity == vim.diagnostic.severity.INFO
				end, diagnostics)
				if #info > 0 then
					return ' ' .. #info .. ' '
				end
				return ''
			end,
			highlight = { colors.violet, colors.none, },
		}
	})
	section('mid', {
		DiagnosticHints = {
			condition = function() return window_wider_than(60) and buffer_not_empty() end,
			provider = function()
				local hints = vim.tbl_filter(function(d)
					return d.severity == vim.diagnostic.severity.HINT
				end, diagnostics)
				if #hints > 0 then
					return 'ﯧ ' .. #hints .. ' '
				end
				return ''
			end,
			highlight = { colors.gray, colors.none, },
		}
	})
end
Diagnostics()

section('right', {
	Indentation = {
		condition = function()
			return buffer_not_empty() and vim.bo.buftype ~= 'terminal'
		end,
		provider = function()
			return (vim.bo.expandtab and ('·'..vim.bo.shiftwidth) or 'ﬀ') .. ' '
		end,
		highlight = { colors.gray, colors.none, },
	}
})
section('right', {
	FileFormat = {
		condition = buffer_not_empty,
		provider = function()
			return ({
				unix = ' ',
				dos = ' ',
			})[vim.bo.fileformat]
		end,
		highlight = { colors.fg, colors.bg, },
		separator = separators.left,
		separator_highlight = { colors.bg, colors.none },
	}
})
section('right', {
	FileTypeName = {
		condition = function()
			return buffer_not_empty() and vim.bo.buftype ~= 'terminal'
		end,
		provider = function() return vim.bo.filetype end,
		highlight = { colors.fg, colors.bg, 'italic' },
		separator = separators.left_thin,
		separator_highlight = { colors.none, colors.bg, 'bold' },
	}
})
section('right', {
	FileSize = {
		condition = function()
			return buffer_not_empty() and vim.bo.buftype ~= 'terminal' and window_wider_than(60)
		end,
		provider = 'FileSize',
		highlight = { colors.fg, colors.bg, },
		separator = ' ' .. separators.left_thin,
		separator_highlight = { colors.none, colors.bg, 'bold' },
	}
})
section('right', {
	CurPos = {
		provider = function()
			return " " .. vim.fn.line('.') .. ":" .. vim.fn.col('.')
		end,
		highlight = { colors.fg, colors.bg, 'bold' },
		separator = separators.left_thin,
		separator_highlight = { colors.fg, colors.bg },
	}
})

local function shortlines()
	section("short_line_left", {
		ShortBuffer = {
			provider = function()
				return vim.bo.buftype == 'nofile' and vim.bo.filetype or vim.fn.expand("%:.:p")
			end,
			highlight = { colors.none, colors.gray },
			separator = separators.right,
			separator_highlight = { colors.gray, colors.bg },
		}
	})
end
shortlines()
require 'quarto'.setup {
        closePreviewOnExit = true,
        lspFeatures = {
          enabled = true,
          chunks = 'curly',
          languages = { 'r', 'python', 'julia', 'bash', 'lua', 'html' },
          diagnostics = {
            enabled = true,
            triggers = { "BufWritePost" }
          },
          completion = {
            enabled = true,
          },
        },
        keymap = {
          hover = 'K',
          definition = 'gd',
          rename = '<leader>lR',
          references = 'gr',
        },
      }
EOF
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" mappings for debugging code.
nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <Leader>bo <Cmd> lua require'dapui'.open()<CR>
nnoremap <silent> <Leader>bc <Cmd> lua require'dapui'.close()<CR>


" setup autocommand mappings for R and Rmarkdown
autocmd BufNewFile,BufRead *.R imap <C-a> <Space><-<Space>
autocmd BufNewFile,BufRead *.R imap <C-p> <Space>\|><Enter>
autocmd BufNewFile,BufRead *.Rmd imap <C-l> ```{r}<Enter>```
autocmd BufNewFile,BufRead *.R,*.Rmd,*.jl,*.py imap <C-s> <Esc> <Space>tsji
autocmd FileType r setlocal ts=2 sts=2 sw=2

" some formatting with julia
autocmd BufWritePre *.jl lua vim.lsp.buf.format()
let g:LanguageClient_serverCommands = {
    \ 'sql': ['sql-language-server', 'up', '--method', 'stdio'],
    \ }
