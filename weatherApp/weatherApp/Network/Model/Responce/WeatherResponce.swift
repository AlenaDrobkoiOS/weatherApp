//
//  WeatherResponce.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//

import Foundation

/// Weather responce data model - contains info that comes with Weather responce
struct WeatherResponce: BaseResponseProtocol {
    var cod: CodeValue? // A short code identifying the type of error returned.
    var message: String? // A fuller description of the error, usually including how to fix it.
    
    var coord: Coord?
    var weather: [Weather]?
    var base: String? // Internal parameter
    var main: Main?
    var visibility: Float? // Visibility, meter. The maximum value of the visibility is 10 km
    var wind: Wind?
    var clouds: Clouds?
    var rain: Rain?
    var snow: Snow?
    var dt: Int? // Time of data calculation, unix, UTC
    var sys: System?
    var timezone: Int? // Shift in seconds from UTC
    var id: Int? /// City ID. Please note that built-in geocoder functionality has been deprecated. Learn more here
    var name: String? // City name. Please note that built-in geocoder functionality has been deprecated. Learn more here
}

struct Coord: Codable {
    var lon: Float? // Longitude of the location
    var lat: Float? // Latitude of the location
}

struct Weather: Codable {
    var id: Int? // Weather condition id
    var main: String? // Group of weather parameters (Rain, Snow, Clouds etc.)
    var description: String? // Group of weather parameters (Rain, Snow, Clouds etc.) weather.description Weather condition within the group.
    var icon: String? // Weather icon id
}

struct Main: Codable {
    var temp: Float? // Temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit
    var feelsLike: Float? // Temperature. This temperature parameter accounts for the human perception of weather. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit
    var pressure: Float? // Atmospheric pressure on the sea level, hPa
    var humidity: Float? // Humidity, %
    var tempMin: Float? // Minimum temperature at the moment. This is minimal currently observed temperature (within large megalopolises and urban areas). Please find more info here. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit
    var tempMax: Float? // Maximum temperature at the moment. This is maximal currently observed temperature (within large megalopolises and urban areas). Please find more info here. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit
    var seaLevel: Float? // Atmospheric pressure on the sea level, hPa
    var grndLevel: Float? // Atmospheric pressure on the ground level, hPa
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Wind: Codable {
    var speed: Float? // Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour
    var degrees: Float? // Wind direction, degrees (meteorological)
    var gust: Float? // Wind gust. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour clouds
    
    enum CodingKeys: String, CodingKey {
        case speed
        case degrees = "deg"
        case gust
    }
}

struct Clouds: Codable {
    var cloudiness: Float? // Cloudiness, %
    
    enum CodingKeys: String, CodingKey {
        case cloudiness = "all"
    }
}

struct Rain: Codable {
    var inHour: Float? // Rain volume for the last 1 hour, mm. Please note that only mm as units of measurement are available for this parameter
    var inHours: Float? // Rain volume for the last 3 hours, mm. Please note that only mm as units of measurement are available for this parameter
    
    enum CodingKeys: String, CodingKey {
        case inHour = "1h"
        case inHours = "3h"
    }
}

struct Snow: Codable {
    var inHour: Float? // Snow volume for the last 1 hour, mm. Please note that only mm as units of measurement are available for this parameter
    var inHours: Float? // Snow volume for the last 3 hours, mm. Please note that only mm as units of measurement are available for this parameter
    
    enum CodingKeys: String, CodingKey {
        case inHour = "1h"
        case inHours = "3h"
    }
}

struct System: Codable {
    var type: Int? // Internal parameter
    var id: Int? // Internal parameter
    var message: String? // Internal parameter
    var country: String? // Country code (GB, JP etc.)
    var sunrise: Int? // Sunrise time, unix, UTC
    var sunset: Int? // Sunset time, unix, UTC
}
