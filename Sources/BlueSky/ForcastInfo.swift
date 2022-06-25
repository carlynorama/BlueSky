//
//  WindData.swift
//  Wind
//
//  Created by Labtanza on 6/24/22.
//

import Foundation
import WeatherKit


struct ForcastInfo {
    var date: Date
    var condition: String
    var symbolName: String
    
    var temperature: Temperature
    var precipitation: String
    var precipitationChance: Double
    
    var windSpeed: Measurement<UnitSpeed>
    var windDirection: Measurement<UnitAngle>
    var gustSpeed: Measurement<UnitSpeed>?
    var windCompassDirection:Wind.CompassDirection
    
    var isDailyForecast: Bool {
        temperature.isDaily
    }
    
    var isHourlyForecast: Bool {
        !temperature.isDaily
    }
}

extension ForcastInfo {
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
}

extension ForcastInfo {
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
}

extension ForcastInfo.Temperature: Hashable {
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

