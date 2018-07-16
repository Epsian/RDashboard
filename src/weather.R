
#### Setup ####
library(XML)

.api = "34ad73aa478d18b8725749e737584c99"
.cityid = "5341704" # Davis, CA

#### Function ####

get_forecast = function(cityid = .cityid, apikey = .api){
  
  forecast = query = paste0("http://api.openweathermap.org/data/2.5/forecast?id=", cityid, "&mode=xml&units=imperial&APPID=", apikey)
  weather_forecast = xmlToList(xmlParse(forecast))
  
  Sys.sleep(3)
  
  today = paste0("http://api.openweathermap.org/data/2.5/weather?id=", cityid, "&mode=xml&units=imperial&APPID=", apikey)
  weather_today = xmlToList(xmlParse(today))
  
  weather_return = list("today" = weather_today, "forecast" = weather_forecast)
  
  return(weather_return)
}

# testx = xmlParse("http://api.openweathermap.org/data/2.5/forecast?id=5341704&mode=xml&APPID=34ad73aa478d18b8725749e737584c99")
