return {
    
 "epwalsh/obsidian.nvim", 
    dependencies = {
        "hrsh7th/nvim-cmp",
        "nvim-lua/plenary.nvim"
    },
 event = "VeryLazy", config = function()
        ---------------------------------
        -- Wiki Functionality: <leader>k - Obsidian.nvim
        ---------------------------------

        -- Variables
        ----------
        local nmap = require('core.utils').norm_keyset
        local lk = require('core.keymaps').lk
        local keymap = vim.keymap
        local obsidian = require("obsidian")
        ----------

        -- Functions
        ----------
        local make_note_id = function(title)
          local suffix = ""
          if title ~= nil then
            suffix = title:gsub(" ", "-")
          else
            suffix = tostring(os.time())
          end
          return suffix
        end

        local make_note_frontmatter = function(note)
          note:add_tag("TODO")
          local out = { id = note.id, aliases = note.aliases, tags = note.tags }
          if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end
          return out
        end
        ----------

        -- Setup
        ----------
        obsidian.setup({
          dir = "~/Learning",
          templates = {
            subdir = "templates",
            date_format = "%Y-%m-%d-%a",
            time_format = "%H:%M",
          },
          mappings = {},
          note_id_func = make_note_id,
          note_frontmatter_func = make_note_frontmatter,
        })
        ----------

        -- Mappings
        ----------
        -- Normal Mode
        nmap(lk.wiki.key .. "b", "ObsidianBacklinks", "Get References To Current")
        nmap(lk.wiki.key .. "t", "ObsidianToday", "Open (New) Daily Note")
        nmap(lk.wiki.key .. "y", "ObsidianYesterday", "Create New Daily Note For Yesterday")
        nmap(lk.wiki.key .. "o", "ObsidianOpen", "Open in Obisidian App")
        nmap(lk.wiki.key .. "s", "ObsidianSearch", "Search Vault Notes")
        nmap(lk.wiki.key .. "q", "ObsidianQuickSwitch", "Note Quick Switch")
        nmap(lk.wiki_linkOpts.key .. "l", "ObsidianFollowLink", "Go To Link Under Cursor")
        nmap(lk.wiki_linkOpts.key .. "t", "ObsidianTemplate", "Insert Template Into Link")
        keymap.set("n", lk.wiki_createPage.key .. "n", ":ObsidianNew ", { silent = false, desc = "Create New Note" })
        -- Visual Mode
        keymap.set("v", lk.wiki_createPage.key .. "l", ":ObsidianLinkNew ", { silent = false, desc = "Created New Linked Note" })
        keymap.set("v", lk.wiki_linkOpts.key .. "a", "<cmd>ObsidianLink<cr>", { silent = true, desc = "Link Note To Selection" })
        -----------
end,
}

