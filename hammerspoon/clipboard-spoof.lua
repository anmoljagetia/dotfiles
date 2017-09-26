-- Type the current clipboard, to get around web forms that don't let you paste
-- (Note: I have Fn-v mapped to F17 in Karabiner)
fnv = { "fn" }
hs.hotkey.bind(fnv, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)
