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


-- Create a new Snippet
local newSnip = snippet("newFmtSnip", fmt([=[
-- {}
local {} = snippet("{}",  {{ {} }})
table.insert(snippets, {})
    ]=],
    {
        inode(1, "snip_blurb"),
        inode(2, "snip_name"),
        dnode(3, function(args)
            return snode(nil, { inode(2, args[1]) })
        end, { 2 }),
        inode(4, "snip_content"),
        dnode(5, function(args)
            return snode(nil, { inode(2, args[1]) })
        end, { 2 })
    }))
table.insert(snippets, newSnip)

-- Creates a New Function
local func = snippet("func", fmt([[
local function {}()
    {}
end]],
    {
        inode(1, "func_name"),
        inode(2, "@TODO")
    }
))
table.insert(snippets, func)

-- Creates a SnippetsFile
local snipfile = snippet("snipfile", {
    tnode({ "--------------------------------",
        "-- ########################## --",
        "-- #   Snippets for Html    # --",
        "-- ########################## --",
        "--------------------------------",
        "",
        "-- Required Module Loading Core Lsp Stuff",
        "----------",
        "local snip = require(\"luasnip\")",
        "----------",
        "",
        "-- Required Extras",
        "----------",
        "local snippet = snip.s",
        "local snode = snip.snippet_node",
        "local inode = snip.i -- Insert Node",
        "local tnode = snip.t -- Text Node",
        "local dnode = snip.dynamic_node",
        "local cnode = snip.choice_node",
        "local fnode = snip.fucntion_node",
        "local fmt = require(\"luasnip.extras.fmt\").fmt",
        "local rep = require(\"luasnip.extras\").rep",
        "----------",
        "",
        "--------------------------------",
        "-- Snippets",
        "--------------------------------",
        "-- Create a table to hold snippets",
        "local snippets, autosnippets = {{}}, {{}} ",
        "", "", "return snippets, autosnippets" }),
}
)
table.insert(snippets, snipfile)

return snippets, autosnippets
