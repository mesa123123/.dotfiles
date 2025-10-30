return {
  "gutsavgupta/nvim-gemini-companion",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  config = function()
    require("gemini").setup()
  end,
  keys = {
    { "<leader>a/", "<cmd>GeminiToggle<cr>", desc = "Toggle Gemini sidebar" },
    { "<leader>ac", "<cmd>GeminiSwitchToCli<cr>", desc = "Spawn or switch to AI session" },
    { "<leader>ay", "<cmd>GeminiAccept<cr>", desc = "Accept Geminis Changes" },
    { "<leader>an", "<cmd>GeminiReject<cr>", desc = "Reject Geminis Changes" },
    { "<leader>aq", "<cmd>GeminiClose<cr>", desc = "Reject Geminis Changes" },
    {
      "<leader>as",
      function()
        vim.cmd("normal! gv")
        vim.cmd("'<,'>GeminiSend")
      end,
      mode = { "x" },
      desc = "Send selection to AI",
    },
  },
}
