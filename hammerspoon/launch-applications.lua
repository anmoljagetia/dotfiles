-- Launch applications

local modalKey = hs.hotkey.modal.new(hyper, 'A', 'Launch Application mode')
modalKey:bind('', 'escape', function() modalKey:exit() end)

local appShortCuts = {

    C = 'Visual Studio Code',
    D = 'Dash',
    E = 'Anmol',
    F = 'Finder',
    G = 'Google Chrome Canary',
    I = 'Iridium',
    J = 'Jump Desktop',
    M = 'Go for Gmail',
    O = 'Microsoft Onenote',
    P = 'Lastpass',
    S = 'Sublime Text',
    T = 'iterm',
    V = 'vlc',
    W = 'Firefox',
    X = 'Xcode',
    Z = 'Franz'
}

for key, app in pairs(appShortCuts) do

    modalKey:bind('', key, 'Launching '..app, function() hs.application.launchOrFocus(app) end, function() modalKey:exit() end)
end

