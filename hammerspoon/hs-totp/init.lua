local gauth = require "hs-totp.gauth"

-- code is based on:
--   https://github.com/imzyxwvu/lua-gauth/blob/master/gauth.lua (with small modifications)
--   https://github.com/kikito/sha.lua

-- read a password from a keychain
function password_from_keychain(name)
    -- 'name' should be saved in the login keychain
    local cmd="/usr/bin/security 2>&1 >/dev/null find-generic-password -ga " .. name .. " | sed -En '/^password: / s,^password: \"(.*)\"$,\\1,p'"
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    return (result:gsub("^%s*(.-)%s*$", "%1"))
end

-- read a token seed from keychain, generate a code and make keystrokes for it
function token_keystroke(token_name, chars)
    local token = password_from_keychain(token_name)
    local hash = gauth.GenCode(token, math.floor(os.time() / 30), chars)

    -- generate keystrokes for the result
    --hs.eventtap.keyStrokes(("%06d"):format(hash))
    hs.eventtap.keyStrokes(hash)
end

-- Cmd-Alt-A : Type AWS Token
hs.hotkey.bind({"cmd", "alt"}, "A", function()
    token_keystroke("token_aws", "07")
end)

-- Cmd-Alt-V-1 : Type VPN1 Token
hs.hotkey.bind({"cmd", "alt"}, "1", function()
    token_keystroke("token_vpn", "06")
end)

-- Cmd-Alt-V-2 : Type VPN2 Token
hs.hotkey.bind({"cmd", "alt"}, "2", function()
    token_keystroke("token_vpn2", "06")
end)

