---------------------------
-- Default awesome theme --
---------------------------
local theme_assets = require("beautiful.theme_assets")
local theme = {}

---------------------------
-- Font-Settings         --
---------------------------
theme.font = "Fira Code Nerd Font Bold 8"
theme.taglist_font = "Fira Code Nerd Font Mono 12"

---------------------------
-- Color-Settings        --
---------------------------
theme.bg_normal = "#000000"
theme.bg_focus = "#aaa949"
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"
theme.bg_systray = theme.bg_normal

theme.fg_normal = "#ffffff"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.border_normal = "#000000"
theme.border_focus = "#e03c31"
theme.border_marked = "#91231c"

theme.useless_gap = 5
theme.border_width = 1
theme.systray_icon_spacing = 10

-- Generate taglist squares:
local taglist_square_size = 4
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)


-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
