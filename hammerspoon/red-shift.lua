function getTime()
    
    local timeTable = {}
    timeTable.start = hs.timer.localTime()
    timeTable.fin = timeTable.start + hs.timer.hours(36)
    return timeTable
end

local lastKey = nil

function flux(key)

    if lastKey == key or key == 'C' then
        
        hs.redshift.stop()
        lastKey = nil
        return
    end

    local value = 0
    
    if key == '1' then
        value = 5500
    elseif key == '2' then
        value = 5000
    elseif key == '3' then
        value = 4500
    elseif key == '4' then
        value = 4000
    elseif key == '5' then
        value = 3500
    elseif key == '6' then
        value = 2500
    elseif key == '7' then
        value = 2000
    elseif key == '8' then
        value = 1500
    elseif key == '9' then
        value = 1000
    end

    if value ~= 0 then
        hs.redshift.start(value, getTime().start, getTime().fin, 1)
        lastKey = key
    elseif key == '0' then
        hs.redshift.start(3000, getTime().start, getTime().fin, 1, true)
    end
end

local modalKey = hs.hotkey.modal.new(hyper, 'R', 'Red Shift mode')
modalKey:bind('', 'escape', function() modalKey:exit() end)
function modalKey:exited()
    hs.alert.show('Red Shift mode exited', 1)
end

modalKey:bind('', '1', function() flux('1') end, function() modalKey:exit() end)
modalKey:bind('', '2', function() flux('2') end, function() modalKey:exit() end)
modalKey:bind('', '3', function() flux('3') end, function() modalKey:exit() end)
modalKey:bind('', '4', function() flux('4') end, function() modalKey:exit() end)
modalKey:bind('', '5', function() flux('5') end, function() modalKey:exit() end)
modalKey:bind('', '6', function() flux('6') end, function() modalKey:exit() end)
modalKey:bind('', '7', function() flux('7') end, function() modalKey:exit() end)
modalKey:bind('', '8', function() flux('8') end, function() modalKey:exit() end)
modalKey:bind('', '9', function() flux('9') end, function() modalKey:exit() end)
modalKey:bind('', '0', function() flux('0') end, function() modalKey:exit() end)
modalKey:bind('', 'C', function() flux('C') end, function() modalKey:exit() end)

