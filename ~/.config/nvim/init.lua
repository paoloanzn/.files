--[[

  init.lua: vscode-like nvim configuration

  Author: Paolo Anzani <paoloanzn@gmail.com>

  Keybinds:

  - M-p: Open/Close files fuzzy finder.
  - M-j: Open/Close a terminal emulator in a bottom panel.
  - M-b: Open/Close a file explorer in a left panel.
]]

-- General settings
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hidden = true

-- Terminal colors
vim.opt.termguicolors = true
vim.opt.signcolumn = "auto:1"
vim.opt.foldcolumn = "0"
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }

-- Tabbing
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Colorscheme
vim.cmd.colorscheme("habamax")

-- Override comments' color.
vim.api.nvim_set_hl(0, "Comment", { ctermfg = "green" })

vim.api.nvim_set_hl(0, "Comment", {
  ctermfg = "green",
  fg = "#00FF00",
})

-- Custom commands and keymaps for macOS clipboard.
if vim.fn.has("mac") == 1 then
  -- Custom commands.
  vim.api.nvim_create_user_command("Paste", "read !pbpaste", {})
  vim.api.nvim_create_user_command("Copy", "'<,'>write !pbcopy", {
    range = "%",
  })

  -- Keymaps.
  vim.keymap.set("n", "+p", ":read !pbpaste<CR>", { silent = true })
  vim.keymap.set("v", "+c", ":write !pbcopy<CR>", { silent = true })
end

-- Use nvim-tree instead of netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local result = vim.fn.system({
    "git", "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to install lazy.nvim:\n" .. result)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "neovim/nvim-lspconfig",
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  "nvim-tree/nvim-tree.lua",
  "akinsho/toggleterm.nvim",
})

-- Rust, C, C++ language servers
vim.lsp.enable({ "rust_analyzer", "clangd" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end

    local opts = { buffer = ev.buf }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "grr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(
        true, client.id, ev.buf, { autotrigger = true }
      )
    end
  end,
})

-- Fuzzy file finder
require("telescope").setup({})

local builtin = require("telescope.builtin")
local function find_files()
  builtin.find_files({ hidden = true })
end

vim.keymap.set("n", "<leader>p", find_files)
vim.keymap.set("n", "<M-p>", find_files)

-- Left file explorer
require("nvim-tree").setup({
  view = {
    side = "left",
    width = 30,
  },
  renderer = {
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = false,
        git = false,
      },
    },
  },
})

vim.keymap.set("n", "<leader>b", "<Cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<M-b>", "<Cmd>NvimTreeToggle<CR>")

-- Persistent terminal at the bottom
require("toggleterm").setup({
  size = 12,
  direction = "horizontal",
  open_mapping = "<C-t>",
  insert_mappings = true,
  terminal_mappings = true,
  persist_mode = true,
  start_in_insert = true,
})

vim.keymap.set("n", "<leader>j", "<Cmd>ToggleTerm<CR>")
vim.keymap.set(
  { "n", "i", "t" },
  "<M-j>",
  "<Cmd>ToggleTerm<CR>"
)

