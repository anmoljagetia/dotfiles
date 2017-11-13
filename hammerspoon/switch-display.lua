-- DISPLAY FOCUS SWITCHING --

--One hotkey should just suffice for dual-display setups as it will naturally
--cycle through both.
--A second hotkey to reverse the direction of the focus-shift would be handy
--for setups with 3 or more displays.

-- Setting up the hyper key

--Bring focus to next display/screen
hs.hotkey.bind(hyper, "1", function ()
  focusScreen(hs.window.focusedWindow():screen():next(), hs.mouse.getCurrentScreen():next())
end)

--Bring focus to previous display/screen
hs.hotkey.bind(hyper, "`", function() 
  focusScreen(hs.window.focusedWindow():screen():previous(), hs.mouse.getCurrentScreen():previous())
end)

--Predicate that checks if a window belongs to a screen
function isInScreen(screen, win)
  return win:screen() == screen
end

-- Adds a circle around the mouse when swiching the display to show that the
-- focus has shifted.
local mouseCircle = nil
local mouseCircleTimer = nil

function mouseHighlight()
    -- Delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.getAbsolutePosition ()
    -- Prepare a big red circle around the mouse pointer
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show(0.5)

    -- Set a timer to delete the circle after 1.5 second
    mouseCircleTimer = hs.timer.doAfter(1.5, function() mouseCircle:delete() end)
end

-- Brings focus to the screen by setting focus on the front-most application in it.
-- Also move the mouse cursor to the center of the screen. This is because
-- Mission Control gestures & keyboard shortcuts are anchored, oddly, on where the
-- mouse is focused.
function focusScreen(screen, mouse)
  --Get windows within screen, ordered from front to back.
  --If no windows exist, bring focus to desktop. Otherwise, set focus on
  --front-most application window.
  local windows = hs.fnutils.filter(
      hs.window.orderedWindows(),
      hs.fnutils.partial(isInScreen, screen))
  local windowToFocus = #windows > 0 and windows[1] or hs.window.desktop()
  windowToFocus:focus()

  -- Move mouse to center of screen
  --local pt = geometry.rectMidPoint(screen:fullFrame())
  local pt = hs.geometry.rectMidPoint(mouse:fullFrame())
  hs.mouse.setAbsolutePosition(pt)
  mouseHighlight()
end

-- Mouse switching logic taken and adapted from : https://gist.github.com/sthtodo/51710df48cf6110e758f
-- END DISPLAY FOCUS SWITCHING --
