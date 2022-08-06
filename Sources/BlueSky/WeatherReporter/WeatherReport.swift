//
//  WeatherReport.swift
//  Wind
//
//  Created by Carlyn Maw on 6/24/22.
//

import Foundation
import WeatherKit



public struct WeatherReport {
    let date: Date
    let condition: String
    let symbolName: String
    
    let temperature: Temperature
    let precipitation: String?
    let precipitationChance: Double?
    
    let windSpeed: Measurement<UnitSpeed>
    let windDirection: Measurement<UnitAngle>
    let gustSpeed: Measurement<UnitSpeed>?
    let windCompassDirection:Wind.CompassDirection
    
    var isDailyForecast: Bool {
        temperature.isDaily
    }
    
    var isHourlyForecast: Bool {
        !temperature.isDaily
    }
    
    var age:TimeInterval {
        date.timeIntervalSince(Date.now)
    }
}


public extension WeatherReport {
    init(_ forecast: DayWeather) {
        date = forecast.date
        condition = forecast.condition.description
        symbolName = forecast.symbolName
        temperature = .daily(
            high: forecast.highTemperature,
            low: forecast.lowTemperature)
        precipitation = forecast.precipitation.description
        precipitationChance = forecast.precipitationChance
        windSpeed = forecast.wind.speed
        windDirection = forecast.wind.direction
        gustSpeed = forecast.wind.gust
        windCompassDirection = forecast.wind.compassDirection
    }
    
    init(_ forecast: HourWeather) {
        date = forecast.date
        condition = forecast.condition.description
        symbolName = forecast.symbolName
        temperature = .hourly(forecast.temperature)
        precipitation = forecast.precipitation.description
        precipitationChance = forecast.precipitationChance
        windSpeed = forecast.wind.speed
        windDirection = forecast.wind.direction
        gustSpeed = forecast.wind.gust
        windCompassDirection = forecast.wind.compassDirection
    }
    
    init(_ rawForcast: Forecast<DayWeather>) {
        let forecast = rawForcast.forecast[0]
        date = forecast.date
        condition = forecast.condition.description
        symbolName = forecast.symbolName
        temperature = .daily(
            high: forecast.highTemperature,
            low: forecast.lowTemperature)
        precipitation = forecast.precipitation.description
        precipitationChance = forecast.precipitationChance
        windSpeed = forecast.wind.speed
        windDirection = forecast.wind.direction
        gustSpeed = forecast.wind.gust
        windCompassDirection = forecast.wind.compassDirection
    }
    
    init(_ currentWeather: CurrentWeather) {
        let forecast = currentWeather
        date = forecast.date
        condition = forecast.condition.description
        symbolName = forecast.symbolName
        temperature = .hourly(forecast.temperature)
        precipitation = nil
        precipitationChance = nil
        windSpeed = forecast.wind.speed
        windDirection = forecast.wind.direction
        gustSpeed = forecast.wind.gust
        windCompassDirection = forecast.wind.compassDirection
    }
}

enum Temperature {
    typealias Value = Measurement<UnitTemperature>
    
    case daily(high: Value, low: Value)
    case hourly(Value)
    
    var isDaily: Bool {
        switch self {
        case .daily:
            return true
        case .hourly:
            return false
        }
    }
}


extension Temperature: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .daily(high, low):
            hasher.combine(0)
            hasher.combine(high)
            hasher.combine(low)
        case let .hourly(temp):
            hasher.combine(1)
            hasher.combine(temp)
        }
    }
}

#if DEBUG
// Use this for preview data.
extension WeatherReport {
    static var daily: WeatherReport {
        WeatherReport(
            date: .now,
            condition: condition,
            symbolName: "cloud.sun.rain",
            temperature: dailyTemperature,
            precipitation: "rain",
            precipitationChance: 0.15,
            windSpeed: manualSpeed,
            windDirection: windDirection,
            gustSpeed: gustSpeed,
            windCompassDirection: Wind.CompassDirection.north
        )
    }
    
    static var hourly: WeatherReport {
        WeatherReport(
            date: .now,
            condition: condition,
            symbolName: "cloud.sun.rain",
            temperature: hourlyTemperature,
            precipitation: "rain",
            precipitationChance: 0.15,
            windSpeed: manualSpeed,
            windDirection: windDirection,
            gustSpeed: gustSpeed,
            windCompassDirection: Wind.CompassDirection.north
        )
    }
    
    private static let condition =
    """
    Lorem ipsum dolor sit amet, \
    consectetur adipiscing elit."
    """
    
    private static var hourlyTemperature: Temperature = {
        let temp = Measurement<UnitTemperature>(value: 60.1, unit: .fahrenheit)
        return .hourly(temp)
    }()

    private static var dailyTemperature: Temperature = {
        let high = Measurement<UnitTemperature>(value: 81.7, unit: .fahrenheit)
        let low = Measurement<UnitTemperature>(value: 52.4, unit: .fahrenheit)
        return .daily(high: high, low: low)
    }()

    private static var manualSpeed: Measurement<UnitSpeed> = {
        Measurement<UnitSpeed>(value: 4.2, unit: .milesPerHour)
    }()
    
    private static var windDirection: Measurement<UnitAngle> = {
        Measurement<UnitAngle>(value: 0.0, unit: .radians)
    }()
    
    private static var gustSpeed: Measurement<UnitSpeed> = {
        Measurement<UnitSpeed>(value: 5.2, unit: .milesPerHour)
    }()
}
#endif

