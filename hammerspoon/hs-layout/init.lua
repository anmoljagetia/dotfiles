-------------------------------------
-- Window layouts
-------------------------------------

local leftScreen = hs.screen{x=0,y=0}
local centerScreen = hs.screen{x=1,y=0}
local rightScreen = hs.screen{x=2,y=0}

local threeScreenLayout = {
 {"Spotify", nil, leftScreen, hs.layout.maximized, nil, nil},
 {"Flock", nil, leftScreen, hs.layout.maximized, nil, nil},
 {"Go for Gmail", nil, leftScreen, hs.layout.maximized, nil, nil},
 {"iTerm2", nil, centerScreen, hs.layout.left50, nil, nil},
 {"Emacs", nil, centerScreen, hs.layout.right50, nil, nil},
 {"Firefox", nil, rightScreen, hs.layout.maximized, nil, nil}
}

local twoScreenLayout = {
-- {"Emacs", nil, leftScreen, hs.layout.maximized, nil, nil},
-- {"Google Chrome", nil, leftScreen, hs.layout.left50, nil, nil},
-- {"iTerm2", nil, leftScreen, hs.layout.maximized, nil, nil},
-- {"Gmail", nil, leftScreen, hs.layout.maximized, nil, nil},
-- {"GmailPersonal", nil, leftScreen, hs.layout.left50, nil, nil},
-- {"GCalendar", nil, leftScreen, hs.layout.left50, nil, nil},
-- {"Slack", nil, leftScreen, hs.layout.right50, nil, nil},
-- {"MacVim", nil, leftScreen, hs.layout.right50, nil, nil},
-- {"Org", nil, leftScreen, hs.layout.left50, nil, nil},
-- {"Xcode", nil, leftScreen, hs.layout.right50, nil, nil},
-- {"Finder", nil, leftScreen, hs.layout.left50, nil, nil},
-- {"Preview", nil, leftScreen, hs.layout.left50, nil, nil},
-- {"OmniGraffle 6", nil, leftScreen, hs.layout.maximized, nil, nil},
-- {"Terminal", nil, leftScreen, hs.layout.left50, nil, nil},
-- {"Spotify", nil, leftScreen, hs.layout.left50, nil, nil},
-- {"PowerPoint", nil, leftScreen, hs.layout.left50, nil, nil},
-- {"Calendar", nil, leftScreen, hs.layout.left50, nil, nil},
-- {"System Preferences", nil, leftScreen, hs.layout.left50, nil, nil}
}

function switchLayout()
  local numScreens = #hs.screen.allScreens()
  local layout = {}
  if numScreens == 1 then
    layout = twoScreenLayout
  elseif numScreens == 2 then
    layout = twoScreenLayout
  elseif numScreens == 3 then
    layout = threeScreenLayout
  end
  hs.layout.apply(layout)
end

hs.hotkey.bind(mash, "p", function()
  switchLayout()
end)
