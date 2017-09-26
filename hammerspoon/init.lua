-- Inspiration from https://github.com/talha131/dotfiles/tree/master/hammerspoon
hyper = { "cmd", "alt", "shift", "ctrl" }
--hyper = { "alt" }

loggerInfo = hs.logger.new('My Settings', 'info')

require 'caffeine'
--require 'clipboard'
require 'launch-applications'
require 'launch-chrome-applications'
require 'red-shift'
require 'reload-config'
require 'switch-display'
require 'window-management'

-- Lock System
hs.hotkey.bind(hyper, 'Q', 'Lock system', function() hs.caffeinate.lockScreen() end)
-- Sleep system
hs.hotkey.bind(hyper, 'S', 'Put system to sleep',function() hs.caffeinate.systemSleep() end)

-- Window Hints
hs.hints.style = 'vimperator'
--hs.hotkey.bind(hyper, 'H', 'Show window hints', hs.hints.windowHints)

