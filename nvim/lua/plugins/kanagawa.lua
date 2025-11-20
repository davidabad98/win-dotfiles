-- lua/plugins/kanagawa.lua
return {
  "rebelot/kanagawa.nvim",
  name = "kanagawa",
  priority = 1000,
  opts = {
    -- use dragon variant
    theme = "dragon",
    background = {
      dark = "dragon",
      light = "lotus", -- doesn't really matter if you're always dark
    },

    -- match your previous transparent_background = true
    transparent = true,

    -- optional: dim inactive windows
    dimInactive = false,

    -- Treesitter & plugin highlight overrides, including Telescope
    overrides = function(colors)
      local theme = colors.theme

      -- theme.ui.* and theme.syn.* are documented in kanagawa README 
      return {
        -- Telescope main window
        TelescopeNormal = { bg = theme.ui.bg_m1, fg = theme.ui.fg },
        TelescopeBorder = { bg = theme.ui.bg_m1, fg = theme.ui.bg_m1 },

        -- Prompt area
        TelescopePromptNormal = { bg = theme.ui.bg_p1, fg = theme.ui.fg },
        TelescopePromptBorder = { bg = theme.ui.bg_p1, fg = theme.ui.bg_p1 },

        -- Prompt title (give it a nice accent)
        TelescopePromptTitle = {
          bg = theme.syn.identifier,
          fg = theme.ui.bg_dim,
        },

        -- Hide these titles by making fg = bg
        TelescopePreviewTitle = { bg = theme.ui.bg_m1, fg = theme.ui.bg_m1 },
        TelescopeResultsTitle = { bg = theme.ui.bg_m1, fg = theme.ui.bg_m1 },
      }
    end,
  },
  config = function(_, opts)
    require("kanagawa").setup(opts)
    -- load dragon variant explicitly
    vim.cmd.colorscheme("kanagawa-dragon") -- 
  end,
}
