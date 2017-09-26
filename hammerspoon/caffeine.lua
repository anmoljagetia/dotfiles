-- Caffeine replacement
local imagePath =  os.getenv("HOME") .. '/.hammerspoon/assets/';
local iconAwake = imagePath .."caffeine-on.pdf"
local iconSleep = imagePath .."caffeine-off.pdf"

local caffeine = hs.menubar.new()

function setCaffeineDisplay(state)
    if state then
        caffeine:setIcon(iconAwake)
        caffeine:setTooltip(imagePath .."Awake - machine will refuse to sleep")
    else
        caffeine:setIcon(iconSleep)
        caffeine:setTooltip("Sleepy - machine is allowed to sleep")
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    hs.caffeinate.set("displayIdle", true, true)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

