//
//  WindDescriptions.swift
//  Wind
//
//  Created by Carlyn Maw on 6/23/22.
//
// Combination of Beaufort Wind Scale and Saffir-Simpson Hurricane Wind Scale
// windVelocity = 0.836 pow(B,3/2)  m/s
// wave heights after hurricane are made up, record height 91ft, 2004 Hurricane Ivan

import Foundation
import WeatherKit


extension WeatherData {
    public func windCompassDirectionNameFor(radians:Double) -> String {
        Wind.CompassDirection.directionFromRadians(radians)?.description ?? "No direction"
    }
    
    public func windScaleFromSpeed(_ speed:Measurement<UnitSpeed>) -> (label:String, levelNumber:Int, calculatedLevel:Double) {
        let calculated = Wind.calculateBeaufortScale(for: speed)
        let levelNumber = Int(calculated.rounded())
        let label = WindScaleValue(rawValue: levelNumber)!.description
        
        return (label, levelNumber, calculated)
    }
}


public struct WindReport {
    public let date:Date
    public let windData:Wind
    
    public let direction:Measurement<UnitAngle>
    public let speed:Measurement<UnitSpeed>
    public let gustSpeed:Measurement<UnitSpeed>?
    public let asStandardUnits:(direction:Double, speed:Double, gust:Double?)
    public let compassDirection:Wind.CompassDirection
    public let extendedWindScaleRating:WindScaleValue?
    
    
    init(_ rawforecast:Forecast<DayWeather>) {
        let forecast = rawforecast[0]
        date = forecast.date
        windData = forecast.wind
        speed = forecast.wind.speed
        direction = forecast.wind.direction
        gustSpeed = forecast.wind.gust
        compassDirection = forecast.wind.compassDirection
        asStandardUnits = forecast.wind.asStandardUnits
        extendedWindScaleRating = forecast.wind.extendedWindScaleRating
    }
    
    init(_ rawforecast:Forecast<HourWeather>) {
        let forecast = rawforecast[0]
        date = forecast.date
        windData = forecast.wind
        speed = forecast.wind.speed
        direction = forecast.wind.direction
        gustSpeed = forecast.wind.gust
        compassDirection = forecast.wind.compassDirection
        asStandardUnits = forecast.wind.asStandardUnits
        extendedWindScaleRating = forecast.wind.extendedWindScaleRating
    }
    
    init(_ weather:CurrentWeather) {
        date = weather.date
        windData = weather.wind
        speed = weather.wind.speed
        direction = weather.wind.direction
        gustSpeed = weather.wind.gust
        compassDirection = weather.wind.compassDirection
        asStandardUnits = weather.wind.asStandardUnits
        extendedWindScaleRating = weather.wind.extendedWindScaleRating
    }
}

