local m = {}

local hammerDir = hs.fs.currentDir()
local iconsDir = (hammerDir .. '/hs-weather/icons/')
local configFile = (hammerDir .. '/hs-weather/config.json')
local urlBase = 'http://api.openweathermap.org/data/2.5/weather?'
local query = '&APPID=9d58c913dd7e0a32801130b9ebcfe9e0&units=metric&q='

-- https://developer.yahoo.com/weather/archive.html#codes
-- icons by RNS, Freepik, Vectors Market, Yannick at http://www.flaticon.com
local weatherSymbols = {
  -- Group 2xx : Thunderstorm 
  [200] = (iconsDir .. 'storm.png'),      -- thunderstorm with light rain
  [201] = (iconsDir .. 'storm.png'),      -- thunderstorm with rain
  [202] = (iconsDir .. 'storm-5.png'),      -- thunderstorm with heavy rain
  [210] = (iconsDir .. 'storm-1.png'),      -- light thunderstorm
  [211] = (iconsDir .. 'storm-2.png'),      -- thunderstorm
  [212] = (iconsDir .. 'storm-3.png'),      -- heavy thunderstorm
  [221] = (iconsDir .. 'storm-4.png'),      -- ragged thunderstorm
  [230] = (iconsDir .. 'storm.png'),      -- thunderstorm with light drizzle
  [231] = (iconsDir .. 'storm.png'),      -- thunderstorm with drizzle
  [232] = (iconsDir .. 'storm-5.png'),      -- thunderstorm with heavy drizzle
  -- Group 3xx : Drizzle 
  [300] = (iconsDir .. '.png'),      -- light intensity drizzle
  [301] = (iconsDir .. 'drizzle.png'),      -- drizzle
  [302] = (iconsDir .. 'rain-1.png'),      -- heavy intensity drizzle
  [310] = (iconsDir .. 'rain-1.png'),      -- light intensity drizzle with rain
  [311] = (iconsDir .. 'rain.png'),      -- drizzle rain
  [312] = (iconsDir .. 'rain-1.png'),      -- heavy intensity drizzle rain
  [313] = (iconsDir .. 'rain.png'),      -- shower rain and drizzle
  [314] = (iconsDir .. 'rain-1.png'),      -- heavy shower rain and drizzle
  [321] = (iconsDir .. 'drizzle.png'),      -- shower drizzle
  -- Group 5xx : Rains 
  [500] = (iconsDir .. 'rain-6.png'),      -- light rain 
  [501] = (iconsDir .. 'rain-3.png'),      -- moderate rain
  [502] = (iconsDir .. 'rain-1.png'),      -- heavy intensity rain
  [503] = (iconsDir .. 'rain-1.png'),      -- very heavy rain
  [504] = (iconsDir .. 'rain-7.png'),      -- extreme rain
  [511] = (iconsDir .. 'rain-8.png'),      -- freezing rain
  [520] = (iconsDir .. 'rain-6.png'),      -- light intensity shower rain
  [521] = (iconsDir .. 'rain-1.png'),      -- shower rain
  [522] = (iconsDir .. 'rain.png'),      -- heavy intensity shower rain
  [531] = (iconsDir .. 'rain-4.png'),      -- ragged shower rain
  -- Group 6xx : Snow 
  [600] = (iconsDir .. 'snowflake.png'),      -- light snow
  [601] = (iconsDir .. 'snowflake.png'),      -- snow
  [602] = (iconsDir .. 'snowflake-1.png'),      -- heavy snow
  [611] = (iconsDir .. 'sleet.png'),      -- sleet
  [612] = (iconsDir .. 'sleet.png'),      -- light shower sleet
  [613] = (iconsDir .. 'sleet.png'),      -- shower sleet
  [615] = (iconsDir .. 'rain-8.png'),      -- light rain and snow
  [616] = (iconsDir .. 'hail.png'),      -- rain and snow
  [620] = (iconsDir .. 'rain-8.png'),      -- light shower snow
  [621] = (iconsDir .. 'rain-8.png'),      -- shower snow
  [622] = (iconsDir .. 'rain-8.png'),      -- heavy shower snow
  -- Group 7xx : Atmosphere 
  [701] = (iconsDir .. 'mist.png'),       -- mist 
  [711] = (iconsDir .. 'wind-1.png'),       -- smoke
  [721] = (iconsDir .. 'haze.png'),      -- haze
  [731] = (iconsDir .. 'tornado.png'),      -- sand, dust whirls
  [741] = (iconsDir .. 'dawn-1.png'),      -- fog
  [751] = (iconsDir .. 'windy-3.png'),      -- sand
  [761] = (iconsDir .. 'windy-2.png'),      -- dust
  [762] = (iconsDir .. 'windy.png'),      -- volcanic ash
  [771] = (iconsDir .. 'night.png'),      -- squalls
  [781] = (iconsDir .. 'tornado.png'),      -- tornado
  -- Group 8xx : Clear and Cloudy
  [800] = (iconsDir .. 'sun-4.png'),      -- clear sky
  [801] = (iconsDir .. 'cloud.png'),      -- few clouds
  [802] = (iconsDir .. 'cloud-1.png'),      -- scattered clouds
  [803] = (iconsDir .. 'cloudy-3.png'),      -- broken clouds
  [804] = (iconsDir .. 'clouds.png'),      -- overcast clouds
  -- Group N/A
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

local function setWeatherTitle(app, temp)
    app:setTitle(temp .. '°C')
end


local function getWeather(location)
  local weatherEndpoint = (urlBase .. query .. location)
  print(weatherWndpoint)
  return hs.http.get(weatherEndpoint)
end

local function setWeatherForLocation(location, unitSys)
  local weatherEndpoint = (urlBase .. query .. location)
  hs.http.asyncGet(weatherEndpoint, nil,
    function(code, body, table)
      if code ~= 200 then
        print('-- hs-weather: Could not get weather. Response code: ' .. code)
      else
        print('-- hs-weather: Weather for ' .. location .. ': ' .. body)
        local response = hs.json.decode(body)
        if response == nil then
          if m.weatherApp:title() == '' then
            setWeatherIcon(m.weatherApp, 3200)
          end
        else
          local temp = response.main.temp
          local code = tonumber(response.weather[1].id)
          local description = response.weather[1].description
          local title = response.weather[1].main
          setWeatherIcon(m.weatherApp, code)
          setWeatherTitle(m.weatherApp, temp)
          m.weatherApp:setTooltip((title .. '\n' .. 'Description: ' .. description))
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
  m.config.location = m.config.location or 'Mumbai,IN'

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
