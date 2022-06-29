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

