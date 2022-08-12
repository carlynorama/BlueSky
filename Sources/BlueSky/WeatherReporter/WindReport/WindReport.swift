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
    
    public let direction:Measurement<UnitAngle>
    public let speed:Measurement<UnitSpeed>
    public let gustSpeed:Measurement<UnitSpeed>?
    public let directionAsRadians:Double
    public let speedAsMPS:Double
    public let gustSpeedAsMPS:Double?
    public let compassDirection:Wind.CompassDirection
    public let windLevel:WindLevel?
    
    public var age:TimeInterval {
        date.timeIntervalSince(Date.now)
    }
    
    public var calculatedLevel:Double {
        WindLevel.calculateBeaufortScale(for: self.speed)
    }
}

public extension WindReport {
    init(_ rawforecast:Forecast<DayWeather>) {
        let forecast = rawforecast[0]
        self = MutatingWindReport(date:forecast.date, windData:forecast.wind).returnStatic()
    }
    
    init(_ rawforecast:Forecast<HourWeather>) {
        let forecast = rawforecast[0]
        self = MutatingWindReport(date:forecast.date, windData:forecast.wind).returnStatic()
        
    }
    
    init(_ weather:CurrentWeather) {
        self = MutatingWindReport(date:weather.date, windData:weather.wind).returnStatic()
    }
    
    init(date: Date, windData:Wind) {
        self = MutatingWindReport(date:date, windData:windData).returnStatic()
    }
    
    init(date:Date = Date.now, direction:Measurement<UnitAngle>, speed: Measurement<UnitSpeed>, gustSpeed: Measurement<UnitSpeed>?) {
        let temp = MutatingWindReport(date: date, direction: direction, speed: speed, gustSpeed: gustSpeed)
        self = Self(temp)
    }
    
    fileprivate init(_ mutatingWR: MutatingWindReport) {
        date = mutatingWR.date
        //windData = mutatingWR.windData
        speed = mutatingWR.speed
        direction = mutatingWR.direction
        gustSpeed = mutatingWR.gustSpeed
        compassDirection = mutatingWR.compassDirection
        directionAsRadians = mutatingWR.directionAsRadians
        speedAsMPS = mutatingWR.speedAsMPS
        gustSpeedAsMPS = mutatingWR.gustSpeedAsMPS
        windLevel = mutatingWR.windLevel
    }
}


//TODO: Wrap in if debug?
//Intended for prototypes
public struct MutatingWindReport {
    public var date:Date
    
    public var direction:Measurement<UnitAngle>
    public var speed:Measurement<UnitSpeed>
    public var gustSpeed:Measurement<UnitSpeed>?
    
    public var directionAsRadians:Double {
        self.direction.converted(to: .radians).value
    }
    public var speedAsMPS:Double {
        self.speed.converted(to: .metersPerSecond).value
    }
    public var gustSpeedAsMPS:Double? {
        self.gustSpeed?.converted(to: .metersPerSecond).value
    }
    public var compassDirection:Wind.CompassDirection{
        Wind.CompassDirection(compassAngle: self.direction)
    }
    public var windLevel:WindLevel {
        print("BlueSky: getting windscale for \(speed.description)")
        return WindLevel(averageSpeed: self.speed)
    }
    public var calculatedLevel:Double {
        WindLevel.calculateBeaufortScale(for: self.speed)
    }
}

//MARK: Mutating Wind Report
//Public use in generating dynamically updatable example Wind Data
public extension MutatingWindReport {
    
    init(from report:WindReport) {
        self.date = report.date
        self.direction = report.direction
        self.speed = report.speed
        self.gustSpeed = report.gustSpeed
    }
    
    init(date: Date, windData:Wind) {
        self.date = date
        self.direction = windData.direction
        self.speed = windData.speed
        self.gustSpeed = windData.gust
        
        //TODO: Turn into unit test
        if (windData.compassDirection != self.compassDirection) {
            print("BlueSky: windData CD\(windData.compassDirection.description) does not equal \(self.compassDirection.description) ")
        }
        
        
    }
    
    func returnStatic() -> WindReport {
        return WindReport(self)
    }
}

