local m = {}

local hammerDir = hs.fs.currentDir()
local iconsDir = (hammerDir .. '/hs-weather/icons/')
local configFile = (hammerDir .. '/hs-weather/config.json')
local urlBase = 'https://query.yahooapis.com/v1/public/yql?q='
local query = 'select item.title, item.condition from weather.forecast where \
               woeid in (select woeid from geo.places(1) where text="'

-- https://developer.yahoo.com/weather/archive.html#codes
-- icons by RNS, Freepik, Vectors Market, Yannick at http://www.flaticon.com
local weatherSymbols = {
  [0] = (iconsDir .. 'tornado.png'),      -- tornado
  [1] = (iconsDir .. 'storm.png'),        -- tropical storm
  [2] = (iconsDir .. 'tornado.png'),      -- hurricane
  [3] = (iconsDir .. 'storm-5.png'),      -- severe thunderstorms
  [4] = (iconsDir .. 'storm-4.png'),      -- thunderstorms
  [5] = (iconsDir .. 'sleet.png'),        -- mixed rain and snow
  [6] = (iconsDir .. 'sleet.png'),        -- mixed rain and sleet
  [7] = (iconsDir .. 'sleet.png'),        -- mixed snow and sleet
  [8] = (iconsDir .. 'drizzle.png'),      -- freezing drizzle
  [9] = (iconsDir .. 'drizzle.png'),      -- drizzle
  [10] = (iconsDir .. 'drizzle.png'),     -- freezing rain
  [11] = (iconsDir .. 'rain-1.png'),      -- showers
  [12] = (iconsDir .. 'rain-1.png'),      -- showers
  [13] = (iconsDir .. 'snowflake.png'),   -- snow flurries
  [14] = (iconsDir .. 'snowflake.png'),   -- light snow showers
  [15] = (iconsDir .. 'snowflake.png'),   -- blowing snow
  [16] = (iconsDir .. 'snowflake.png'),   -- snow
  [17] = (iconsDir .. 'hail.png'),        -- hail
  [18] = (iconsDir .. 'sleet.png'),       -- sleet
  [19] = (iconsDir .. 'haze.png'),        -- dust
  [20] = (iconsDir .. 'mist.png'),        -- foggy
  [21] = (iconsDir .. 'haze.png'),        -- haze
  [22] = (iconsDir .. 'mist.png'),        -- smoky
  [23] = (iconsDir .. 'wind-1.png'),      -- blustery
  [24] = (iconsDir .. 'windy-1.png'),     -- windy
  [25] = (iconsDir .. 'cold.png'),        -- cold
  [26] = (iconsDir .. 'clouds.png'),      -- cloudy
  [27] = (iconsDir .. 'night.png'),       -- mostly cloudy (night)
  [28] = (iconsDir .. 'cloudy.png'),      -- mostly cloudy (day)
  [29] = (iconsDir .. 'cloudy-4.png'),    -- partly cloudy (night)
  [30] = (iconsDir .. 'cloudy-5.png'),    -- partly cloudy (day)
  [31] = (iconsDir .. 'moon-2.png'),      -- clear (night)
  [32] = (iconsDir .. 'sun-1.png'),       -- sunny
  [33] = (iconsDir .. 'night-2.png'),     -- fair (night)
  [34] = (iconsDir .. 'cloudy-1.png'),    -- fair (day)
  [35] = (iconsDir .. 'hail.png'),        -- mixed rain and hail
  [36] = (iconsDir .. 'temperature.png'), -- hot
  [37] = (iconsDir .. 'storm-4.png'),     -- isolated thunderstorms
  [38] = (iconsDir .. 'storm-2.png'),     -- scattered thunderstorms
  [39] = (iconsDir .. 'rain-3.png'),      -- scattered thunderstorms
  [40] = (iconsDir .. 'rain-6.png'),      -- scattered showers
  [41] = (iconsDir .. 'snowflake.png'),   -- heavy snow
  [42] = (iconsDir .. 'snowflake.png'),   -- scattered snow showers
  [43] = (iconsDir .. 'snowflake.png'),   -- heavy snow
  [44] = (iconsDir .. 'cloudy.png'),      -- party cloudy
  [45] = (iconsDir .. 'storm.png'),       -- thundershowers
  [46] = (iconsDir .. 'snowflake.png'),   -- snow showers
  [47] = (iconsDir .. 'lightning.png'),   -- isolated thundershowers
  [3200] = (iconsDir .. 'na.png')         -- not available
}

local function readConfig(file)
  local f = io.open(file, "rb")
  if not f then
    return {}
  end
  local content = f:read("*all")
  f:close()
  return hs.json.decode(content)
end

local function setWeatherIcon(app, code)
  local iconPath = weatherSymbols[code]
  local size = {w=16,h=16}
  if iconPath ~= nil then
    app:setIcon(hs.image.imageFromPath(iconPath):setSize(size))
  else
    app:setIcon(hs.image.imageFromPath(weatherSymbols[3200]):setSize(size))
  end
end

local function toCelsius(f)
  return (f - 32) * 5 / 9
end

local function setWeatherTitle(app, unitSys, temp)
  if unitSys == 'C' then
    local tempCelsius = toCelsius(temp)
    local tempRounded = math.floor(tempCelsius * 10 + 0.5) / 10
    app:setTitle(tempRounded .. ' °C  ')
  else
    app:setTitle(temp .. ' °F  ')
  end
end

local function urlencode(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w ])",
      function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str
end

local function getWeather(location)
  local weatherEndpoint = (
    urlBase .. urlencode(query .. location .. '")') .. '&format=json')
  return hs.http.get(weatherEndpoint)
end

local function setWeatherForLocation(location, unitSys)
  local weatherEndpoint = (
    urlBase .. urlencode(query .. location .. '")') .. '&format=json')
  hs.http.asyncGet(weatherEndpoint, nil,
    function(code, body, table)
      if code ~= 200 then
        print('-- hs-weather: Could not get weather. Response code: ' .. code)
      else
        print('-- hs-weather: Weather for ' .. location .. ': ' .. body)
        local response = hs.json.decode(body)
        if response.query.results == nil then
          if m.weatherApp:title() == '' then
            setWeatherIcon(m.weatherApp, 3200)
          end
        else
          local temp = response.query.results.channel.item.condition.temp
          local code = tonumber(response.query.results.channel.item.condition.code)
          local condition = response.query.results.channel.item.condition.text
          local title = response.query.results.channel.item.title
          setWeatherIcon(m.weatherApp, code)
          setWeatherTitle(m.weatherApp, unitSys, temp)
          m.weatherApp:setTooltip((title .. '\n' .. 'Condition: ' .. condition))
        end
      end
    end
  )
end

-- Get weather for current location
-- Hammerspoon needs access to OS location services
local function setWeatherForCurrentLocation(unitSys)
  if hs.location.servicesEnabled() then
    hs.location.start()
    hs.timer.doAfter(1,
      function ()
        local loc = hs.location.get()
        hs.location.stop()
        setWeatherForLocation(
          '(' .. loc.latitude .. ',' .. loc.longitude .. ')', unitSys)
      end)
  else
    print('\n-- Location services disabled!\n')
  end
end

local function setWeather()
  if m.config.geolocation then
    setWeatherForCurrentLocation(m.config.units)
  else
    setWeatherForLocation(m.config.location, m.config.units)
  end
end

m.start = function(cfg)
  m.config = cfg or readConfig(configFile)

  -- defaults if not set
  m.config.refresh = m.config.refresh or 300
  m.config.units = m.config.units or 'C'
  m.config.location = m.config.location or 'Berlin, DE'

  m.weatherApp = hs.menubar.new()
  setWeather()

  -- refresh on click
  m.weatherApp:setClickCallback(function () setWeather() end)

  m.timer = hs.timer.doEvery(
    m.config.refresh, function () setWeather() end)
end

m.stop = function()
  m.timer:stop()
end

return m
