-- Inspiration from https://github.com/talha131/dotfiles/tree/master/hammerspoon
hyper = { "cmd", "alt", "shift", "ctrl" }
mash = { "cmd", "alt", "ctrl" }

loggerInfo = hs.logger.new('My Settings', 'info')

--require 'battery'
require 'beat-paste-blocking'
require 'caffeine'
require 'double_cmd_q_to_quit'
require 'emoji'
require 'imgur'
require 'launch-applications'
require 'red-shift'
require 'reload-config'
require 'switch-display'
require 'window-management'

require 'hs-totp'
require 'hs-anycomplete'
require 'hs-tabs'
require 'hs-worktime'
require 'hs-layout'

-- Lock System
hs.hotkey.bind(hyper, 'Q', 'Lock system', function() hs.caffeinate.lockScreen() end)
-- Sleep system
hs.hotkey.bind(hyper, 'S', 'Put system to sleep',function() hs.caffeinate.systemSleep() end)

-- Window Hints
hs.hints.style = 'vimperator'
hs.hotkey.bind(hyper, 'H', 'Show window hints', hs.hints.windowHints)

-- Load TextClipboardHistory Spoon 
hs.loadSpoon("TextClipboardHistory")
spoon.TextClipboardHistory:bindHotkeys({show_clipboard={mash, "V"}})
spoon.TextClipboardHistory:start()

--Weather Menubar
local weather = require('hs-weather')
weather.start()

-- Tiling Manager
local tiling = require('hs-tiling')

hs.hotkey.bind(mash, "c", function() tiling.cycleLayout() end)
hs.hotkey.bind(mash, "j", function() tiling.cycle(1) end)
hs.hotkey.bind(mash, "k", function() tiling.cycle(-1) end)
hs.hotkey.bind(mash, "s", function() tiling.promote() end)
hs.hotkey.bind(mash, "f", function() tiling.goToLayout("fullscreen") end)

-- If you want to set the layouts that are enabled
tiling.set('layouts', {
  'fullscreen', 'main-vertical'
})

