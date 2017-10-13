-- Caffeine replacement
local imagePath =  os.getenv("HOME") .. '/.hammerspoon/assets/';
local iconAwake = imagePath .."caffeine-on.pdf"
local iconSleep = imagePath .."caffeine-off.pdf"

local caffeine = hs.menubar.new()

function setCaffeineDisplay(state)
    if state then
        caffeine:setIcon(iconAwake)
        caffeine:setTooltip(imagePath .."Awake - machine will refuse to sleep")
        hs.alert.show("Caffeinated!")
    else
        caffeine:setIcon(iconSleep)
        caffeine:setTooltip("Sleepy - machine is allowed to sleep")
        hs.alert.show("Decaffeinated!")
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

hs.hotkey.bind(hyper, 'C',function() caffeineClicked() end)


