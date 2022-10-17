--------------------------------
-- ########################## --
-- #   Snippets for Html    # --
-- ########################## --
--------------------------------

-- Required Module Loading Core Lsp Stuff
----------
local snip = require("luasnip")
----------

-- Required Extras
----------
local snippet = snip.s
local snode = snip.snippet_node
local inode = snip.i -- Insert Node
local tnode = snip.t -- Text Node
local dnode = snip.dynamic_node
local cnode = snip.choice_node
local fnode = snip.fucntion_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
----------

--------------------------------
-- Snippets
--------------------------------
-- Create a table to hold snippets
local snippets, autosnippets = {}, {}

-- Struct
local struct = snippet("struct", fmt([[
struct <> {
    <>
}
    ]],
    { inode(1, "struct_name"), inode(2, "struct_fields") },
    { delimiters = "<>" }))
table.insert(snippets, struct)


return snippets, autosnippets
