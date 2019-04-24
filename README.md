#+begin_src

                   d88P          888          888     .d888 d8b 888
                  d88P           888          888    d88P"  Y8P 888
 d888b  d88      d88P            888          888    888        888
d888888888P     d88P         .d88888  .d88b.  888888 888888 888 888  .d88b.  .d8888b
88P  Y888P     d88P         d88" 888 d88""88b 888    888    888 888 d8P  Y8b 88K
              d88P          888  888 888  888 888    888    888 888 88888888 "Y8888b.
             d88P       d8b Y88b 888 Y88..88P Y88b.  888    888 888 Y8b.          X88
            d88P        Y8P  "Y88888  "Y88P"   "Y888 888    888 888  "Y8888   88888P'

#+end_src


* Dotfiles

I really like to configure my system in every possible way so that it can be geared towards a more personalized experience. This repository holds how I do it.
The goal here is to update my machine with Better™ system defaults, preferences, software configuration and even auto-install some handy development tools and apps.

* Installation

The easiest way to install these dotfiles is to clone the repository and then run the installer script. This will install the necessary packages, clone other dependent repositories and try and configure the system in as automated fashion as possible.

#+begin_src bash
git clone git@github.com:anmoljagetia/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
#+end_src

* The Directory Structure

The dotfiles are organized in the following way

|-------------+---------------------------------------------------------------------------------------------|
| directory   | purpose                                                                                     |
|-------------+---------------------------------------------------------------------------------------------|
| Terminal    | Settings for the colors and settings for the macos terminal and iterm                       |
| bash        | My bash shell configurations                                                                |
| bin         | Stores all the handy nifty binaries that I use. This directory is also added to system path |
| emacs       | My emacs settings                                                                           |
| functions   | These functions are lazy loaded using z shell                                               |
| git         | My git settings                                                                             |
| hammerspoon | Hammerspoon settings for macos automation                                                   |
| install.sh  | The installer script                                                                        |
| node        | Node packages and defaults                                                                  |
| sublime     | Settings for ST3. Slightly outdated since I don't use sublime extensively anymore           |
| tmux        | My tmux configuration                                                                       |
| vim         | My vim configuration                                                                        |
| zsh         | My z-shell configuration                                                                    |
|-------------+---------------------------------------------------------------------------------------------|
