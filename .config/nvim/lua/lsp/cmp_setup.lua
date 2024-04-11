---------------------------------
-- ########################### --
-- # Code Completion Config  # --
-- ########################### --
---------------------------------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Vim Vars
----------
-- Api Exposures
local api = vim.api -- vim api (I'm not sure what this does)
local lsp = vim.lsp -- Lsp inbuilt
G = vim.g -- global variables
--------

-- Requires
----------
local cmp = require("cmp") -- Autocompletion for the language servers
local cmp_lsp = require("cmp_nvim_lsp")
local snip = require("luasnip")
local lspkind = require("lspkind")
local putils = require("personal_utils")
----------

-- Tables
----------
-- General Sources
local general_sources = {
  { name = "luasnip" },
  { name = "nvim_lsp" },
  { name = "nvim_lsp_document_symbol" },
  { name = "otter" },
  { name = "htmx" },
  { name = "path" },
  { name = "buffer" },
  { name = "nvim_lua" },
  { name = "spell" },
  { name = "treesitter" },
  { name = "dotenv" },
}
-- Text Search Sources
local text_search_sources = {
  { name = "buffer" },
}
-- Cmdline Sources
local cmdline_sources = {
  { name = "cmdline" },
  { name = "cmdline_history" },
  { name = "path" },
}
-- Gitignore Sources
local git_ignore_sources = {
  cmp.config.sources({
    { name = "cmp_git" },
  }),
}
----------

--------------------------------
-- Functions
--------------------------------

-- Enablement for General Setup
----------
local general_enabled = function()
  local context = require("cmp.config.context") -- disable completion in comments
  if api.nvim_get_mode().mode == "c" then -- keep command mode completion enabled when cursor is in a comment
    return true
  else
    return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
  end
end
----------

-- Helps the completion decide whether to pop up, also helps with manually triggering cmp
----------
local has_words_before = function()
  local line, col = unpack(api.nvim_win_get_cursor(0))
  return col ~= 0 and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
----------

-- Next Selection
----------
local snip_cmp_next = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif has_words_before() then
    cmp.complete()
  else
    fallback()
  end
end, { "i", "s", "c" })
----------

-- Previous Selection
----------
local snip_cmp_previous = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  else
    fallback()
  end
end, { "i", "s", "c" })
----------

-- Abort Selection
----------
local cmp_abort = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.abort()
  else
    fallback()
  end
end, { "i", "s", "c" })
----------

-- Confirm Selection
----------
local cmp_select = cmp.mapping(function(fallback)
  if cmp.visible() and has_words_before() and cmp.get_active_entry() then
    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
  elseif snip.expandable() and has_words_before and cmp.get_active_entry() then
    snip.expand_or_jump()
  else
    fallback()
  end
end, { "i" })
----------

-- Toggle Cmp window on and off
----------
local cmp_toggle = cmp.mapping(function()
  if cmp.visible() then
    cmp.close()
  else
    cmp.complete()
  end
end, { "i", "s" })
----------

--------------------------------
-- Formatting
--------------------------------

local cmp_formatting = {
  format = function(entry, vim_item)
    if vim.tbl_contains({ "path" }, entry.source.name) then
      local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
      if icon then
        vim_item.kind = icon
        vim_item.kind_hl_group = hl_group
        return vim_item
      end
    end
    return lspkind.cmp_format({ with_text = false })(entry, vim_item)
  end,
}
----------

--------------------------------
-- Setups
--------------------------------

-- Pick your sources
----------
local load = function(sources)
  return cmp.setup({
    enabled = { general_enabled },
    sources = sources,
    completion = { completeopt = "menu,menuone,noinsert,noselect", keyword_length = 1 },
    snippet = {
      expand = function(args)
        snip.lsp_expand(args.body)
      end,
    },
    -- Making autocomplete menu look nice
    formatting = cmp_formatting,
    mapping = {
      ["<C-l>"] = snip_cmp_next,
      ["<C-h>"] = snip_cmp_previous,
      ["<C-k>"] = cmp.mapping.scroll_docs(-4),
      ["<C-j>"] = cmp.mapping.scroll_docs(4),
      ["<Esc>"] = cmp_abort,
      ["<CR>"] = cmp_select,
      ["<c-space>"] = cmp_toggle, -- toggle completion suggestions
    },
    window = {
      completion = cmp.config.window.bordered({
        border = "rounded",
      }),
      documentation = cmp.config.window.bordered({
        border = "rounded",
      }),
    },
  })
end
----------

-- A General Cmp Source
----------
local general = load(general_sources)
----------

-- Setup - Text Search '/'
----------
local text_search = function()
  return cmp.setup.cmdline("/", {
    sources = text_search_sources,
    mapping = {
      ["<TAB>"] = cmp_select,
    },
  })
end
----------

-- Setup - Commandline ':'
----------
local cmdline = function()
  return cmp.setup.cmdline(":", {
    sources = cmdline_sources,
    mapping = {
      ["<TAB>"] = cmp_select,
    },
  })
end
----------

-- Git Commit Setup
----------
local git_commit = function()
  return cmp.setup.cmdline("gitcommit", {
    sources = git_ignore_sources,
  })
end
----------

--------------------------------
-- Capabilities
--------------------------------

local capabilities = function()
  local capabilities = cmp_lsp.default_capabilities(lsp.protocol.make_client_capabilities())
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return capabilities
end

----------

--------------------------------
-- Module Table
--------------------------------

-- Table
local M = {
  general = general,
  load = load,
  source_ft = {
    gitcommit = git_commit,
    cmdline = cmdline,
    text_search = text_search,
  },
  capabilities = capabilities,
}

return M

----------
