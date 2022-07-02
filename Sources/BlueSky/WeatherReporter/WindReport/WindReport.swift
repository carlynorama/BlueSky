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

//TODO: Is this the best place for these function to live?
extension WeatherData {
    public func windCompassDirectionNameFor(radians:Double) -> String {
        WindReport.compassDirectionFor(radians: radians).description
    }
    
    public func windScaleFromSpeed(_ speed:Measurement<UnitSpeed>) -> (label:String, levelNumber:Int, calculatedLevel:Double) {
        let calculated = WindLevel.calculateBeaufortScale(for: speed)
        let levelNumber = Int(calculated.rounded())
        let label = WindLevel(rawValue: levelNumber)!.description
        
        return (label, levelNumber, calculated)
    }
}


public struct WindReport {
    public let date:Date
    //public let windData:Wind
    
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

//For ProtoypingUI
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
        print("getting windscale")
        return WindLevel(averageSpeed: self.speed.converted(to: .knots))
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
            print("windData CD\(windData.compassDirection.description) does not equal \(self.compassDirection.description) ")
        }
        
        
    }
    
    func returnStatic() -> WindReport {
        return WindReport(self)
    }
}

//MARK: For UI Prototyping purposes only
//Deprecated for direct access to MutatingWindReport
//public extension WindReport {
//
//    func windReportWithNew(speed:Measurement<UnitSpeed>) -> WindReport {
//        var dummyReport = MutatingWindReport(from: self)
//        dummyReport.speed = speed
//        dummyReport.date = Date.now
//        return WindReport(dummyReport)
//    }
//
//    func windReportWithNew(speedMPS:Double) -> WindReport {
//        let speed = Measurement<UnitSpeed>(value: speedMPS, unit: .metersPerSecond)
//        return self.windReportWithNew(speed: speed)
//    }
//
//    func windReportWithNew(gustSpeed:Measurement<UnitSpeed>) -> WindReport {
//        var dummyReport = MutatingWindReport(from: self)
//        dummyReport.speed = gustSpeed
//        dummyReport.date = Date.now
//        return WindReport(dummyReport)
//    }
//
//    func windReportWithNew(gustSpeedMPS:Double) -> WindReport {
//        let speed = Measurement<UnitSpeed>(value: gustSpeedMPS, unit: .metersPerSecond)
//        return self.windReportWithNew(speed: speed)
//    }
//
//
//    func windReportWithNew(direction:Measurement<UnitAngle>) -> WindReport {
//        var dummyReport = MutatingWindReport(from: self)
//        dummyReport.direction = direction
//        dummyReport.date = Date.now
//        return WindReport(dummyReport)
//    }
//
//    func windReportWithNew(directionRadians:Double) -> WindReport {
//        let direction = Measurement<UnitAngle>(value: directionRadians, unit: .radians)
//        return self.windReportWithNew(direction: direction)
//    }
//
//    func windReportWithNew(directionDegrees:Double) -> WindReport {
//        let direction = Measurement<UnitAngle>(value: directionDegrees, unit: .degrees)
//        return self.windReportWithNew(direction: direction)
//    }
//
//}

