-- imgur upload from pasteboard

-- read a password from a keychain
function password_from_keychain(name)
    -- 'name' should be saved in the login keychain
    local cmd="/usr/bin/security 2>&1 >/dev/null find-generic-password -ga " .. name .. " | sed -En '/^password: / s,^password: \"(.*)\"$,\\1,p'"
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    return (result:gsub("^%s*(.-)%s*$", "%1"))
end

hs.hotkey.bind(hyper, "U", function()
    local image = hs.pasteboard.readImage()
    local token = password_from_keychain("token_imgur")

    if image then
      local tempfile = "/tmp/tmp.png"
      image:saveToFile(tempfile)
      local b64 = hs.execute("base64 -i "..tempfile)
      b64 = hs.http.encodeForQuery(string.gsub(b64, "\n", ""))

      local url = "https://api.imgur.com/3/upload.json"
      local headers = {Authorization = "Client-ID "..token}
      local payload = "type='base64'&image="..b64

      hs.http.asyncPost(url, payload, headers, function(status, body, headers)
          print(status, headers, body)
          if status == 200 then
            local response = hs.json.decode(body)
            local imageURL = response.data.link
            hs.pasteboard.setContents(imageURL)
            hs.urlevent.openURLWithBundle(imageURL, hs.urlevent.getDefaultHandler("http"))
          end
        end)
    end
  end)
