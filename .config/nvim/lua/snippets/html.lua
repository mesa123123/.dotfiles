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

-- Creates a new html struct
local doctype = snippet("doctype", tnode({
    "<!DOCTYPE html>",
    "<html>",
    "<head></head>",
    "<body></body>",
    "</html>"
}))
table.insert(snippets, doctype)


--return snippets to the luasnip engine
return snippets, autosnippets
