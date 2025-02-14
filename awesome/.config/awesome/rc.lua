-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
--awful.spawn.with_shell("xrandr -s 1920x1080")

require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")

-- Print the current DPI at AwesomeWM startup
beautiful.xresources_dpi = 96 -- Replace 96 with your desired DPI

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Handle runtime errors after startup
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local log_file = io.open(os.getenv("HOME") .. "/awesome.log", "w")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(gears.filesystem.get_configuration_dir() .. "mytheme.lua")

-- fix for the notification icon size being too big
-- changes in mytheme.lua didn't do the trick
beautiful.notification_icon_size = 100

-- This is used later as the default terminal and editor to run.
-- terminal = "x-terminal-emulator"
terminal = "alacritty"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	--    awful.layout.suit.floating,
	awful.layout.suit.tile,
	--    awful.layout.suit.tile.left,
	--    awful.layout.suit.tile.bottom,
	--    awful.layout.suit.tile.top,
	--    awful.layout.suit.fair,
	--    awful.layout.suit.fair.horizontal,
	--    awful.layout.suit.spiral,
	--    awful.layout.suit.spiral.dwindle,
	--    awful.layout.suit.max,
	--    awful.layout.suit.max.fullscreen,
	--    awful.layout.suit.magnifier,
	--    awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

mylauncher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = mymainmenu,
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)


awful.screen.connect_for_each_screen(function(s)
	-- Each screen has its own tag table.
	awful.tag(
		{
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
		},
		s,
		awful.layout.layouts[1]
	)

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	})

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
	})

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", height = 24, screen = s, bg = beautiful.bg_normal .. "F0" })

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.stack,
		{
			layout = wibox.layout.align.horizontal,
			{
				-- Left widgets
				layout = wibox.layout.fixed.horizontal,
				--mylauncher,
				s.mytaglist,
				s.mypromptbox,
			},
			--s.mytasklist, -- Middle widget
			nil,
			{
				-- Right widgets
				layout = wibox.layout.fixed.horizontal,
				wibox.container.margin(wibox.widget.systray(), 3, 3, 3, 3),
        -- spacer to the right border of the screen
				wibox.widget.textbox(" "),
			},
		},
		{
			mytextclock,
			valign = "center",
			halign = "center",
			layout = wibox.container.place,
		},
	})
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
	--    awful.button({ }, 3, function () mymainmenu:toggle() end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "s", function()
		awful.spawn.with_shell("flameshot gui")
	end, { description = "screenshot", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "t", function()
		awful.spawn.with_shell("scratchpad")
	end, { description = "open kitty", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "p", function()
		awful.spawn.with_shell("scrcpy -S --power-off-on-close")
	end, { description = "phone", group = "awesome" }),
	awful.key({ modkey }, "u", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modkey }, "i", awful.tag.viewnext, { description = "view next", group = "tag" }),
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),
	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),

	-- toggle wibar - Show/Hide Wibox
	awful.key({ modkey }, "b", function()
		for s in screen do
			s.mywibox.visible = not s.mywibox.visible
			if s.mybottomwibox then
				s.mybottomwibox.visible = not s.mybottomwibox.visible
			end
		end
	end, { description = "toggle wibox", group = "awesome" }),

	awful.key({ modkey, "Control" }, "h", function()
		for _, cl in ipairs(mouse.screen.selected_tag:clients()) do
			local c = cl
			--if c then
			--   c.unminimize = true
			--end
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "maximize all windows in current tag", group = "client" }),

	-- Layout manipulation
	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),
	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),
	awful.key({ modkey, "Control" }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),
	awful.key({ modkey, "Control" }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),
	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "go back", group = "client" }),

	-- Standard program
	--awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
	awful.key({ modkey }, "t", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "launcher" }),
	-- awful.key({ modkey, }, "Return", function() awful.spawn.with_shell("rofi -show drun") end,
	awful.key({ modkey }, "Return", function()
		awful.spawn.with_shell("rofi -show drun")
	end, { description = "open a terminal", group = "launcher" }),
	-- awful.key({ altkey, }, "Return", function() awful.spawn.with_shell("~/.config/rofi/launchers/type-2/launcher.sh") end,
	--   { description = "open a terminal", group = "launcher" }),
	awful.key({ modkey, "Control", "Shift" }, "l", function()
		awful.spawn.with_shell("systemctl suspend")
	end, { description = "suspend machine", group = "launcher" }),

	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),
	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),
	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),
	awful.key({ modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),
	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),
	awful.key({ modkey }, "space", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),
	awful.key({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),

	--awful.key({ modkey, "Control" }, "n",
	--          function ()
	--              local c = awful.client.restore()
	--              -- Focus restored client
	--              if c then
	--                c:emit_signal(
	--                    "request::activate", "key.unminimize", {raise = true}
	--                )
	--              end
	--          end,
	--          {description = "restore minimized", group = "client"}),

	-- Prompt
	-- awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
	-- awful.key({ modkey }, "r", function () awful.spawn("dmenu_run -fn 'JetBrains::pixelsize=18'") end,
	-- toggle touchpad
	awful.key({ modkey, "Shift" }, "m", function()
		awful.spawn("toggle_touch")
	end, { description = "toggle touchpad", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "p", function()
		awful.spawn("killall mpv")
	end, { description = "kill mpv", group = "launcher" }),
	awful.key({ modkey }, "r", function()
		awful.spawn("dmenu_run -fn 'Fira Mono::pixelsize=18'")
	end, { description = "run prompt", group = "launcher" }),
	-- youtube clipboard workaround
	awful.key({ modkey }, ",", function()
		awful.spawn("ytclipboard")
	end, { description = "youtube cli", group = "launcher" }),
	-- youtube fzf dmenu
	awful.key({ modkey }, "y", function()
		awful.spawn("ytfzf -D")
	end, { description = "youtube cli", group = "launcher" }),
	awful.key({ modkey }, "n", function()
		awful.spawn("noflix")
	end, { description = "youtube cli", group = "launcher" }),
	awful.key({ modkey }, "d", function()
		awful.spawn("brave-browser")
	end, { description = "Firefox", group = "launcher" }),
	awful.key({ modkey }, "v", function()
		awful.spawn("vb")
	end, { description = "start vbox", group = "launcher" }),
	awful.key({ modkey }, "x", function()
		awful.spawn("vb_off")
	end, { description = "stop vbox", group = "launcher" }),
	awful.key({ modkey }, "w", function()
		awful.spawn("/usr/local/bin/back.sh")
	end, { description = "random background", group = "launcher" }),

	awful.key({ modkey }, "V", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" }),
	-- Menubar
	awful.key({ modkey }, "p", function()
		menubar.show()
	end, { description = "show the menubar", group = "launcher" })
)

clientkeys = gears.table.join(
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),
	--awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
	awful.key({ modkey }, "q", function(c)
		c:kill()
	end, { description = "close", group = "client" }),
	awful.key(
		{ modkey, "Control" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),
	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),
	awful.key({ modkey }, "o", function(c)
		c:move_to_screen()
	end, { description = "move to screen", group = "client" }),
	awful.key({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),
	--    awful.key({ modkey,           }, "n",
	--        function (c)
	--            -- The client currently has the input focus, so it cannot be
	--            -- minimized, since minimized clients can't have the focus.
	--            c.minimized = true
	--        end ,
	--        {description = "minimize", group = "client"}),
	awful.key({ modkey }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" }),
	awful.key({ modkey, "Control" }, "m", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end, { description = "(un)maximize vertically", group = "client" }),
	awful.key({ modkey, "Shift" }, "m", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c:raise()
	end, { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Matplotlib",
				"matplotlib",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
				"gnome-calculator",
				"Gnome-calculator",
				"scrcpy",
				"nemo",
				"Zathura",
				"Shadow",
				"obs",
				"gedit",
				"Gedit",
				"megasyrc",
				"MEGAsync",
				"kitty",
				"nemo",
				"thunar",
				"Thunar",
				"steam_app_0", -- Witcher
			},
			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				--    "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true, placement = awful.placement.centered },
	},
	-- -- Spawn floating clients centered
	--    { rule_any = {floating = true},
	--        properties = {
	--            placement = awful.placement.centered
	--        }
	--    },
	-- Set width and hight for python3.8 for kivyMD development
	{
		-- rule = { class = "www.youtube.com", role = "pop-up" },
		rule = { class = "www.youtube.com" },
		properties = { width = "1400", height = "800", placement = awful.placement.centered, floating = true },
		--properties = { placement = awful.placement.centered,  floating = true }
	},
	-- Set width and hight for python3.8 for kivyMD development
	{
		rule = { class = "obsidian" },
		properties = { floating = false },
		--properties = { placement = awful.placement.centered,  floating = true }
	},
	-- Add titlebars to normal clients and dialogs
	{
		rule_any = { type = { "normal", "dialog" } },
		properties = { titlebars_enabled = false },
	},
	-- Set width and hight for python3.8 for kivyMD development
	{
		rule = { class = "python3.8" },
		--properties = { width = "405", height = "900",  floating = true }
		properties = { placement = awful.placement.centered, floating = true },
	},
	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- individual - open right
	if not awesome.startup then
		awful.client.setslave(c)
	end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c):setup({
		{
			-- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{
			-- Middle
			{
				-- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{
			-- Right
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	})
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- try to prevent memory increase over time
-- source: https://new.reddit.com/r/awesomewm/comments/iguwcj/memory_leaks/
gears.timer.start_new(10, function()
	collectgarbage("step", 20000)
	return true
end)

-- openAI toggle implementation
-- Define a function to set the shape based on the client's fullscreen state
local function setWindowShape(c)
	if c.fullscreen then
		c.shape = gears.shape.rectangle
	else
		c.shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, 10)
		end
	end
end

-- Set the initial shape for existing clients
client.connect_signal("manage", function(c)
	setWindowShape(c)
end)

-- Connect the signal to handle fullscreen and normal mode changes
client.connect_signal("property::fullscreen", setWindowShape)

-- Connect the signal to handle the client being unmanaged
client.connect_signal("unmanage", function(c)
	c.shape = nil -- Reset the shape when the client is unmanaged
end)
-- individual settings
-- beautiful.useless_gap = 5

-- Startup programs individuell
awful.util.spawn_with_shell("~/.config/awesome/autorun.sh")
-- }}}
