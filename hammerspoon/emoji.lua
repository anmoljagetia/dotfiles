-- Emoji search chooser!
-- Adapted from https://github.com/aldur/dotfiles/blob/master/osx/hammerspoon/init.lua
--
-- This code doesn't currently use it, but if an update to the emoji json is needed,
-- this file might be a good candidate (would require minor code changes):
-- https://github.com/github/gemoji/blob/master/db/emoji.json

-- Focus the last active window
local wf = hs.window.filter
local function focusLastFocused()
    local lastFocused = wf.defaultCurrentSpace:getWindows(wf.sortByFocusedLast)
    if #lastFocused > 0 then lastFocused[1]:focus() end
end


local isLoaded = false
local chooser = hs.chooser.new(function(choice)
    if not choice then focusLastFocused() return end
    hs.pasteboard.setContents(choice.chars)
    focusLastFocused()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)


local function loadChoices()
    local choices = {}
    for _, emoji in ipairs(hs.json.decode(io.open("assets/emojis.json"):read())) do
        table.insert(choices, {
            text=emoji.chars .. ' ' .. emoji['name'],
            subText=table.concat(emoji.kwds, ", "),
            chars=emoji.chars
        })
    end

    chooser:rows(10)
    chooser:searchSubText(true)
    chooser:choices(choices)
end

local Commands = {}
Commands.choose = function()
    -- Loading all of the choices from json takes a while, so do it the first
    -- time the chooser is invoked, not at startup time
    if not isLoaded then
        loadChoices()
        isLoaded = true
    end
    chooser:show()
end

return Commands
