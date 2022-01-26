## 

<img src="https://user-images.githubusercontent.com/46932291/151233225-4d1f7156-24c2-4eb6-afa9-e3ad60d1843a.png" alt="img" align="right" width="400px">


## Setup

Here are the instructions you should follow to replicate my AwesomeWM setup.

1. Install the [git version of AwesomeWM](https://github.com/awesomeWM/awesome/).

   **Arch users** can use the [awesome-git AUR package](https://aur.archlinux.org/packages/awesome-git/).
   ```shell
   yay -S awesome-git
   ```

   **For other distros**, build instructions are [here](https://github.com/awesomeWM/awesome/#building-and-installation).

2. Install dependencies and enable services

   *If you are curious, [click here](https://github.com/elenapan/dotfiles/wiki/Detailed-dependency-table) to see a table of dependencies and why they are needed.*

   + Software

     - **Ubuntu** 18.04 or newer (and all Ubuntu-based distributions)

         ```shell
         sudo apt install rofi lm-sensors acpid jq fortune-mod redshift mpd mpc maim feh pulseaudio inotify-tools xdotool

         # Install light, which is not in the official Ubuntu repositories
         wget https://github.com/haikarainen/light/releases/download/v1.2/light_1.2_amd64.deb
         sudo dpkg -i light_1.2_amd64.deb
         ```

     - **Arch Linux** (and all Arch-based distributions)

         *Assuming your AUR helper is* `yay`

         ```shell
         yay -S rofi lm_sensors acpid jq fortune-mod redshift mpd mpc maim feh light-git pulseaudio inotify-tools xdotool
         ```
   + Services

      ```shell
      # For automatically launching mpd on login
      systemctl --user enable mpd.service
      systemctl --user start mpd.service
      # For charger plug/unplug events (if you have a battery)
      sudo systemctl enable acpid.service
      sudo systemctl start acpid.service
      ```

3. Install needed fonts

   You will need to install a few fonts (mainly icon fonts) in order for text and icons to be rendered properly.

   Necessary fonts:
   + **Typicons** - [github](https://github.com/fontello/typicons.font)
   + **Material Design Icons** - [dropbox](https://www.dropbox.com/s/4fevs095ho7xtf9/material-design-icons.ttf?dl=0)
   + **Icomoon** - [dropbox](https://www.dropbox.com/s/hrkub2yo9iapljz/icomoon.zip?dl=0)
   + **Nerd Fonts** - [website](https://www.nerdfonts.com/font-downloads)
      (You only need to pick and download one Nerd Font. They all include the same icons)
   + **Scriptina** - [website](https://www.dafont.com/scriptina.font) - Handwritten font used in the lock screen

   Optional fonts:
   + **My custom Iosevka build** - [dropbox](https://www.dropbox.com/s/nqyurzy8wcupkkz/myosevka.zip?dl=0) - 💙 *my favorite monospace font*
   + **Anka/Coder**
   + **Google Sans** - 💙 *my favorite sans font*
   + **Roboto Condensed**
   + **San Francisco Display**

   Once you download them and unpack them, place them into `~/.fonts` or `~/.local/share/fonts`.
   - You will need to create the directory if it does not exist.
   - It does not matter that the actual font files (`.ttf`) are deep inside multiple directories. They will be detected as long as they can be accessed from `~/.fonts` or `~/.local/share/fonts`.

   You can find the fonts required inside the `misc/fonts` folder of the repository.
   ```shell
   cp -r ./misc/fonts/* ~/.fonts/
   # Or to ~/.local/share/fonts
   cp -r ./misc/fonts/* ~/.local/share/fonts/
   ```
   Finally, run the following in order for your system to detect the newly installed fonts.
   ```shell
   fc-cache -v
   ```

4. Install my AwesomeWM configuration files

   ```shell
   git clone https://github.com/elenapan/dotfiles
   cd dotfiles
   [ -e ~/.config/awesome ] && mv ~/.config/awesome ~/.config/awesome-backup-"$(date +%Y.%m.%d-%H.%M.%S)" # Backup current configuration
   cp -r config/awesome ~/.config/awesome
   ```

4. Configure stuff

   The relevant files are inside your `~/.config/awesome` directory.

   + User preferences and default applications

      In `rc.lua` there is a *User variables and preferences* section where user preferences and default applications are defined.
      You should change those to your liking. Probably the most important change you can make is to set your `terminal`.

      For more sophisticated control over your apps, check out `apps.lua`

      Note: For the weather widgets to work, you will also need to create an account on [openweathermap](https://openweathermap.org), get your key, look for your city ID, and set `openweathermap_key` and `openweathermap_city_id` accordingly.

   + Have a general idea of what my keybinds do

      My keybinds will most probably not suit you completely, but on your first login you might need to know how to navigate the desktop.

      See the [keybinds](#keybinds) section for more details.

      You can edit `keys.lua` to configure your keybinds.

   + *(Optional)* This is also a good time to take a look at [how my configuration is structured](#awesomewm-configuration-file-structure) in order to understand the purpose of each file.

5. Login with AwesomeWM 🎉

   Congratulations, at this point you should be ready to log out of your current desktop and into AwesomeWM.

   Your login screen should have a button that lets you change between available desktop sessions. If not, [click here](https://github.com/elenapan/dotfiles/wiki/Troubleshooting#i-cannot-find-the-login-screen-button-that-lets-me-login-with-awesomewm) to find out how to fix it.

   Try it, play with it, enjoy it.
   Consider checking out the [Advanced setup](https://github.com/elenapan/dotfiles/wiki/Advanced-setup) in order to enable and configure various components that are not needed to use the desktop, but provide a better experience.


6. *(Optional)* Eye-candy

   + Set the wallpaper

      ```shell
      feh --bg-fill /path/to/your/wallpaper
      ```

   + Load a colorscheme

      ```shell
      xrdb -merge /path/to/colorscheme
      ```

      Notes:
      - To see the new colors you should restart AwesomeWM with <kbd>super+shift+r</kbd> or by right-clicking the desktop and clicking the gear icon (bottom-right).
      - In the [.xfiles](.xfiles) directory of the repository I provide you with a few of my own colorschemes, but you can also use your favorite one.
      - All of my AwesomeWM themes take their colors from `xrdb`. This also means that they play nice with tools like [pywal](https://github.com/dylanaraps/pywal).

