local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local apps = require("apps")
local lain = require("lain")
local markup = lain.util.markup
local keys = require("keys")
local helpers = require("helpers")
local naughty = require("naughty")


local gray   = "#dbdee9"

-- Helper function that creates a button widget
local create_button = function(symbol, color, bg_color, hover_color)
	local widget = wibox.widget {font = "icomoon 14", align = "center", id = "text_role", valign = "center", markup = helpers.colorize_text(symbol, color), widget = wibox.widget.textbox()}

	local section = wibox.widget {widget, forced_width = dpi(70), bg = bg_color, widget = wibox.container.background}

	-- Hover animation
	section:connect_signal("mouse::enter", function()
		section.bg = hover_color
	end)
	section:connect_signal("mouse::leave", function()
		section.bg = bg_color
	end)

	-- helpers.add_hover_cursor(section, "hand1")

	return section
end

local display = create_button("", x.color6, x.color8 .. "60", x.color8 .. "80")
display:buttons(gears.table.join(awful.button({}, 1, function()
	awful.spawn.with_shell("lxrandr")
end)))

-- got from awesome copycats
-- CPU
local cpu = lain.widget.sysload({
    settings = function()
        widget:set_markup(markup.font("SFMono Nerd Font 10", markup(beautiful.cpu_bar_active_color , " Cpu : " .. load_1 .. " " .. "% ")))
    end
})
local cpubg = wibox.container.background(cpu.widget, x.color8 .. "10", gears.shape.rectangle)
local cpuwidget = wibox.container.margin(cpubg)

-- MEM
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font("SFMono Nerd Font 10", markup(beautiful.ram_bar_active_color , " RAM : " .. mem_now.used .. " " .. "MB ")))
    end
})
local membg = wibox.container.background(mem.widget, x.color8 .. "20", gears.shape.rectangle)
local memwidget = wibox.container.margin(membg)

-- Net checker
local net = lain.widget.net({
    settings = function()
        if net_now.state == "up" then net_state = "👍"
        else net_state = "🗿" end
        widget:set_markup(markup.font("SFMono Nerd Font 10", markup(gray, " Internet : ") .. net_state .. " "))
    end
})

local netbg = wibox.container.background(net.widget, x.color8 .. "30", gears.shape.rectangle)
local netwidget = wibox.container.margin(netbg)

-- clock
local clock = wibox.widget.textclock(markup.fontfg("SFMono Nerd Font 10", "#FFFFFF", " " .. "  %d %b |  %H:%M" .. markup.font("SFMono Nerd Font 10", " ")))
local clockbg = wibox.container.background(clock, x.color8 .. "30", gears.shape.rectangle)

-- local clockwidget = wibox.container.margin(clockbg, dpi(0), dpi(3), dpi(5), dpi(5))
local clockwidget = wibox.container.margin(clockbg)

local volume_symbol = ""
local volume_muted_color = x.color8
local volume_unmuted_color = x.color5
local volume = create_button(volume_symbol, volume_unmuted_color, x.color8 .. "30", x.color8 .. "50")

volume:buttons(gears.table.join(
	-- Left click - Mute / Unmute
	awful.button({}, 1, function()
		helpers.volume_control(0)
	end),

	-- Right click - Run or raise volume control client
	awful.button({}, 3, apps.volume),

	-- Scroll - Increase / Decrease volume
	awful.button({}, 4, function()
		helpers.volume_control(5)
	end),
	awful.button({}, 5, function()
		helpers.volume_control(-5)
	end)
))

awesome.connect_signal("evil::volume", function(_, muted)
	local t = volume:get_all_children()[1]
	if muted then
		t.markup = helpers.colorize_text(volume_symbol, volume_muted_color)
	else
		t.markup = helpers.colorize_text(volume_symbol, volume_unmuted_color)
	end
end)

local microphone_symbol = ""
local microphone_muted_color = x.color8
local microphone_unmuted_color = x.color3
local microphone = create_button(microphone_symbol, microphone_unmuted_color, x.color8 .. "60", x.color8 .. "80")

microphone:buttons(gears.table.join(awful.button({}, 1, function()
	awful.spawn.with_shell("amixer set Capture toggle")
end)))

awesome.connect_signal("evil::microphone", function(muted)
	local t = microphone:get_all_children()[1]
	if muted then
		t.markup = helpers.colorize_text(microphone_symbol, microphone_muted_color)
		naughty.notify({text = 'Microphone Muted'})
	else
		t.markup = helpers.colorize_text(microphone_symbol, microphone_unmuted_color)
		naughty.notify({text = 'Microphone Active'})
	end
end)

local music = create_button("", x.color4, x.color8 .. "30", x.color8 .. "50")

music:buttons(gears.table.join(
	awful.button({}, 1, apps.music),
	awful.button({}, 3, apps.music),

	-- Scrolling: Adjust mpd volume
	awful.button({}, 4, function()
		awful.spawn.with_shell("mpc volume +5")
	end),
	awful.button({}, 5, function()
		awful.spawn.with_shell("mpc volume -5")
	end)
))

-- Battery
local cute_battery_face_wibar = require("noodle.cute_battery_face_wibar")
cute_battery_face_wibar:buttons(gears.table.join(awful.button({}, 1, apps.battery_monitor)))

helpers.add_hover_cursor(cute_battery_face_wibar, "hand1")

local sandwich = create_button("", x.color1, x.color8 .. "30", x.color8 .. "50")
sandwich:buttons(gears.table.join(
	awful.button({}, 1, function()
		-- app_drawer_show()
		sidebar_toggle()
	end),
	awful.button({}, 2, apps.scratchpad),
	awful.button({}, 3, function()
		tray_toggle()
	end)
))

local tag_colors_empty = {
	"#00000020",
	"#00000020",
	"#00000020",
	"#00000020",
	"#00000020",
	"#00000020",
	"#00000020",
	"#00000020",
	"#00000020",
	"#00000020",
}

local tag_colors_urgent = {x.background, x.background, x.background, x.background, x.background, x.background, x.background, x.background, x.background, x.background}

local blue = '#5e81ac'
local yellow = '#ebcb8b'
local orange = '#d08770'
local purple = '#b48ead'
local cyan_dark = '#1a1d23'
local occupied_tag_color = "#4c566a"

local tag_colors_focused = {
	blue,
	yellow,
	orange,
	purple,
	cyan_dark,
	blue,
	yellow,
	orange,
	purple,
	cyan_dark,
}

local tag_colors_occupied = {
  occupied_tag_color ..  "99",
  occupied_tag_color ..  "99",
  occupied_tag_color ..  "99",
  occupied_tag_color ..  "99",
  occupied_tag_color ..  "99",
  occupied_tag_color ..  "99",
  occupied_tag_color ..  "99",
  occupied_tag_color ..  "99",
  occupied_tag_color ..  "99",
  occupied_tag_color ..  "99",
}

-- Helper function that updates a taglist item
local update_taglist = function(item, tag, index)
	if tag.selected then
		item.bg = tag_colors_focused[index]
	elseif tag.urgent then
		item.bg = tag_colors_urgent[index]
	elseif #tag:clients() > 0 then
		item.bg = tag_colors_occupied[index]
	else
		item.bg = tag_colors_empty[index]
	end
end

awful.screen.connect_for_each_screen(function(s)
	-- Create a taglist for every screen
	--
	s.linetaglist = awful.widget.taglist {
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = keys.taglist_buttons,
		layout = wibox.layout.flex.vertical,
		widget_template = {
			widget = wibox.container.background,
      shape=gears.shape.rounded_bar,
			create_callback = function(self, tag, index, _)
				update_taglist(self, tag, index)
			end,
			update_callback = function(self, tag, index, _)
				update_taglist(self, tag, index)
			end,
		}
	}

	-- Create a tasklist for every screen
	s.mytasklist = awful.widget.tasklist {
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = keys.tasklist_buttons,
		style = {
			-- font = beautiful.tasklist_font,
			font = "SFMono Nerd Font 10",
			bg = x.color0,
		},
		layout = {
			-- spacing = dpi(10),
			-- layout  = wibox.layout.fixed.horizontal
			layout = wibox.layout.flex.horizontal
		},
		widget_template = {
			{
				{
					id = 'text_role',
					align = "center",
					widget = wibox.widget.textbox,
				},
				forced_width = dpi(100),
				left = dpi(3),
				right = dpi(0),

				-- Add margins to top and bottom in order to force the
				-- text to be on a single line, if needed. Might need
				-- to adjust them according to font size.
				top = dpi(4),
				bottom = dpi(4),
				widget = wibox.container.margin
			},

			-- shape = helpers.rrect(dpi(8)),
			-- border_width = dpi(2),
			id = "bg_role",

			-- id = "background_role",
			-- shape = gears.shape.rounded_bar,
			widget = wibox.container.background,
		},
	}

	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox.resize = true
	s.mylayoutbox.forced_width = beautiful.wibar_height - dpi(5)
	s.mylayoutbox.forced_height = beautiful.wibar_height - dpi(5)
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

	-- Create the wibox
	s.mywibox = awful.wibar({screen = s, visible = true, ontop = true, type = "dock", position = "top"})
	s.mywibox.height = beautiful.wibar_height

	-- s.mywibox.width = beautiful.wibar_width

	-- For antialiasing
	-- The actual background color is defined in the wibar items
	-- s.mywibox.bg = "#00000000"

	-- s.mywibox.bg = x.color8
	-- s.mywibox.bg = x.foreground
	-- s.mywibox.bg = x.background.."88"
	-- s.mywibox.bg = x.background
	-- s.mywibox.bg = x.background
	s.mywibox.bg = "#1a1d23"

	-- s.mywibox.bg = "#1a1d23"

	-- Bar placement
	awful.placement.maximize_horizontally(s.mywibox)

	-- Item placement
	s.mywibox:setup {
		{
			----------- TOP GROUP -----------
			sandwich,
                        memwidget,
                        cpuwidget,
                        netwidget,
			layout = wibox.layout.fixed.horizontal
		},
		{
			----------- MIDDLE GROUP -----------
			right = dpi(50),
			{
				-- Put some margins at the left and right edge so that
				-- it looks better with extremely long titles/artists
				left = dpi(293),
				cute_battery_face_wibar,
				right = dpi(100),
				widget = wibox.container.margin
			},
			layout = wibox.layout.fixed.horizontal
		},
		{
			----------- BOTTOM GROUP -----------
			nil,
			{{volume, microphone, music, display, clockwidget, layout = wibox.layout.fixed.horizontal}, widget = wibox.container.margin},
			nil,
			layout = wibox.layout.align.horizontal,
			expand = "none"
		},
		layout = wibox.layout.align.horizontal,

		-- expand = "none"
	}

	-- Create the top bar
	s.mytopwibox = awful.wibar({screen = s, visible = true, ontop = false, type = "dock", position = "left", width = dpi(6)})

	-- Bar placement
	awful.placement.maximize_vertically(s.mytopwibox)
	s.mytopwibox.bg = "#00000000"
	-- s.mytopwibox.bg = "#1a1d23"

	s.mytopwibox:setup {
		widget = s.linetaglist,
	}

	-- Create a system tray widget
	s.systray = wibox.widget.systray()

	-- Create a wibox that will only show the tray
	-- Hidden by default. Can be toggled with a keybind.
	s.traybox = wibox({visible = false, ontop = true, type = "normal"})
	s.traybox.width = dpi(120)
	s.traybox.height = beautiful.wibar_height
	awful.placement.bottom_left(s.traybox, {honor_workarea = true, margins = beautiful.screen_margin * 2})
	s.traybox.bg = "#00000000"
	s.traybox:setup {s.systray, bg = beautiful.bg_systray, shape = helpers.rrect(beautiful.border_radius), widget = wibox.container.background()}

	s.traybox:buttons(gears.table.join(
	-- Middle click - Hide traybox
	awful.button({}, 2, function()
		s.traybox.visible = false
	end)))

	-- Hide traybox when mouse leaves
	s.traybox:connect_signal("mouse::leave", function()
		s.traybox.visible = false
	end)

	-- Place bar at the bottom and add margins
	-- awful.placement.bottom(s.mywibox, {margins = beautiful.screen_margin * 2})
	-- Also add some screen padding so that clients do not stick to the bar
	-- For "awful.wibar"
	-- s.padding = { bottom = s.padding.bottom + beautiful.screen_margin * 2 }
	-- For "wibox"
	-- s.padding = { bottom = s.mywibox.height + beautiful.screen_margin * 2 }
end)

-- We have set the wibar(s) to be ontop, but we do not want it to be above fullscreen clients
local function no_wibar_ontop(c)
	local s = awful.screen.focused()
	if c.fullscreen then
		s.mywibox.ontop = false
	else
		s.mywibox.ontop = true
	end
end

client.connect_signal("focus", no_wibar_ontop)
client.connect_signal("unfocus", no_wibar_ontop)
client.connect_signal("property::fullscreen", no_wibar_ontop)

-- Every bar theme should provide these fuctions
function wibars_toggle()
	local s = awful.screen.focused()
	s.mywibox.visible = not s.mywibox.visible
	s.mytopwibox.visible = not s.mytopwibox.visible
end

function tray_toggle()
	local s = awful.screen.focused()
	s.traybox.visible = not s.traybox.visible
end
