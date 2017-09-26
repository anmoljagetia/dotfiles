-- Launch Chrome applications

local modalKey = hs.hotkey.modal.new(hyper, 'G', 'Launch Chrome Application mode')
modalKey:bind('', 'escape', function() modalKey:exit() end)

local chromeAppShortCuts = {

    H = {id = 'oppompclolbipehgmpngoaalfhfdpdhl',
    title = 'Habits'},

    X = {id = 'ggohgaegpbmbmmmoobmogjfjopncbnfb',
    title = 'Expenses'}
}

function launchOrFocusChromeApp(key)

    if chromeAppShortCuts[key] == nil then

        return
    end

    local appWindow = hs.window.find(chromeAppShortCuts[key].title)
    if appWindow ~= nil then

        loggerInfo.i('Found app window')
        loggerInfo.i(appWindow)
        appWindow:becomeMain()
        appWindow:raise()
        appWindow:focus()
    else

        hs.execute('/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --app-id=' .. chromeAppShortCuts[key].id)
    end
end

for key, app in pairs(chromeAppShortCuts) do

    modalKey:bind('', key, 'Launching '..app.title ,function() launchOrFocusChromeApp(key) end, function() modalKey:exit() end)
end

