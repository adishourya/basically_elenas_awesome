local awful = require("awful")
do
  local cmds =
  {
    "picom --experimental-backends",
    "sxhkd -c /home/adi/.config/awesome/sxhkdrc",
    "blueman-applet",
  }

  for _,i in pairs(cmds) do
    awful.util.spawn(i)
  end
end
