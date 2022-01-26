local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local helpers = require("helpers")

local stroke = x.background
local transparent_pad = "80"
local white = "#dbdee9"
local purple = "#eceff4"
local charging_symbol = white
local  happy_color     =  purple .. transparent_pad
local  sad_color       =  purple .. transparent_pad
local  ok_color        =  purple .. transparent_pad
local  charging_color  =  purple .. transparent_pad
-- local mouth_sad_color = x.color1
local mouth_sad_color =  white
local mouth_ok_color = white
local mouth_charging_color = white


-- Not great not terrible
local ok_threshold = 65

-- sad times
local low_threshold = user.battery_threshold_low


local bar_shape = function()
    return function(cr, width, height)
        gears.shape.rect(cr, width, height, true, true, true, true, 1)
    end
end

local battery_bar = wibox.widget{
    max_value     = 100,
    value         = 50,
    forced_height = dpi(10),
    forced_width  = dpi(700),
    bar_shape     = gears.shape.rectangle,
    color         = happy_color,
    background_color = happy_color.."55",
    widget        = wibox.widget.progressbar,
}

local charging_icon = wibox.widget {
    font = "Material Icons 13",
    align = "right",
    markup = helpers.colorize_text("", charging_symbol.."80"),
    widget = wibox.widget.textbox()

}

local eye_size = dpi(5)
local mouth_size = dpi(10)

local mouth_shape = function()
    return function(cr, width, height)
        gears.shape.pie(cr, width, height, 0, math.pi)
    end
end

local mouth_widget = wibox.widget {
    forced_width = mouth_size,
    forced_height = mouth_size,
    shape = mouth_shape(),
    -- shape = gears.shape.pie,
    -- bg = stroke,
    bg = white,
    widget = wibox.container.background()
}

local frown = wibox.widget {
    {
        mouth_widget,
        bg = mouth_sad_color,
        direction = "south",
        widget = wibox.container.rotate()
    },
    top = dpi(8),
    widget = wibox.container.margin()
}

local smile = wibox.widget {
    mouth_widget,
    bg = mouth_happy_color,
    direction = "north",
    widget = wibox.container.rotate()
}

local ok = wibox.widget {
    {
        bg = mouth_ok_color,
        shape = helpers.rrect(dpi(2)),
        widget = wibox.container.background
    },
    top = dpi(5),
    bottom = dpi(1),
    widget = wibox.container.margin()
}

local mouth = wibox.widget {
    frown,
    ok,
    smile,
    top_only = true,
    widget = wibox.layout.stack()
}

local eye = wibox.widget {
    forced_width = eye_size,
    forced_height = eye_size,
    shape = gears.shape.circle,
    -- bg = stroke,
    bg = white,
    widget = wibox.container.background()
}

-- 2 eyes 1 semicircle (smile or frown)
local face = wibox.widget {
    -- eye,
    -- mouth,
    -- eye,
    spacing = dpi(10),
    layout = wibox.layout.fixed.horizontal
}

local cute_battery_face_wibar = wibox.widget {
    {
        battery_bar,
        shape = helpers.rrect(dpi(4)),
        border_color = "#000",
        border_width = dpi(1),
        widget = wibox.container.background
    },
    {
        nil,
        {
            nil,
            face,
            layout = wibox.layout.align.vertical,
            expand = "none"
        },
        layout = wibox.layout.align.horizontal,
        expand = "none"
    },
    {
        charging_icon,
        right = dpi(12),
        widget = wibox.container.margin()
    },
    top_only = false,
    layout = wibox.layout.stack
}

local last_value = 100
awesome.connect_signal("evil::battery", function(value)
    -- Update bar
    battery_bar.value = value
    last_value = value
    local color
    -- Update face
    if charging_icon.visible then
        color = charging_color
        mouth:set(1, smile)
    elseif value <= low_threshold then
        color = sad_color
        mouth:set(1, frown)
    elseif value <= ok_threshold then
        color = ok_color
        mouth:set(1, ok)
    else
        color = happy_color
        mouth:set(1, smile)
    end
    battery_bar.color = color
    battery_bar.background_color = color.."44"
end)

awesome.connect_signal("evil::charger", function(plugged)
    local color
    if plugged then
        charging_icon.visible = true
        color = charging_color
        mouth:set(1, smile)
    elseif last_value <= low_threshold then
        charging_icon.visible = false
        color = sad_color
        mouth:set(1, frown)
    elseif last_value <= ok_threshold then
        charging_icon.visible = false
        color = ok_color
        mouth:set(1, ok)
    else
        charging_icon.visible = false
        color = happy_color
        mouth:set(1, smile)
    end
    battery_bar.color = color
    battery_bar.background_color = "#c5cdd9".."60"
end)

return cute_battery_face_wibar
