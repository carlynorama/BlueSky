

//
//  File.swift
//
//
//  Created by Labtanza on 6/29/22.
//

import Foundation
import WeatherKit

extension WindReport {
    static func compassDirectionFor(angle:Measurement<UnitAngle>) -> Wind.CompassDirection {
        Wind.CompassDirection(compassAngle: angle)
    }
    
    static func compassDirectionFor(radians:Double) -> Wind.CompassDirection {
        Wind.CompassDirection(compassAngle: Measurement<UnitAngle>(value: radians, unit: .radians))
    }
    
    static func compassDirectionFor(degrees:Double) -> Wind.CompassDirection {
        Wind.CompassDirection(compassAngle: Measurement<UnitAngle>(value: degrees, unit: .degrees))
    }
}

extension WeatherKit.Wind.CompassDirection {
        static let degreesCircle = 360.0
        static let numberOfWedges = 16

        static let wedgeSize = Measurement<UnitAngle>(value: degreesCircle/Double(numberOfWedges), unit: .degrees)
        static let halfWedgeSize = wedgeSize/2.0
        static let wedgeOffSet = -1 * halfWedgeSize
        
        static func wedgeNumberFor(angle:Measurement<UnitAngle>) -> Int {
            var compassAngle = angle.converted(to: .degrees)
            if compassAngle.value.magnitude > degreesCircle {
                //print("BlueSky CD.wedgeNumberFor\(angle): Caught a large magnitude value")
                compassAngle.value = compassAngle.value.truncatingRemainder(dividingBy: degreesCircle)
                //print("BlueSky CD.wedgeNumberFor\(angle): \(compassAngle)")
            }
            var wedgeShiftedAngle = compassAngle + wedgeOffSet
            //print("BlueSky CD.wedgeNumberFor\(angle): adjusted degrees: \(wedgeShiftedAngle)")
            if wedgeShiftedAngle.value < 0 {
                //print("BlueSky CD.wedgeNumberFor\(angle): Caught a negative value")
                wedgeShiftedAngle.value = wedgeShiftedAngle.value + degreesCircle
                //print("BlueSky CD.wedgeNumberFor\(angle): newDegreesValue: \(wedgeShiftedAngle)")
            }

            
            let wedgeNumberRaw:Double = (wedgeShiftedAngle.value/wedgeSize.value)
            //print("BlueSky CD.wedgeNumberFor\(angle): raw \(wedgeNumberRaw)")
            var wedgeNumberToReturn = Int(wedgeNumberRaw.rounded(.awayFromZero))
            //print("BlueSky CD.wedgeNumberFor\(angle): as Int \(wedgeNumberToReturn)")
            if wedgeNumberToReturn == Int(numberOfWedges) {
                wedgeNumberToReturn = 0
            }
            //print("BlueSky CD.wedgeNumberFor\(angle): got wedgeNumber \(wedgeNumberToReturn)")
            return  wedgeNumberToReturn
        }
        
        static func wedgeNumberFor(degrees:Double) -> Int {
            wedgeNumberFor(angle: Measurement<UnitAngle>(value: degrees, unit: .degrees))
        }
        
        static func wedgeNumberFor(radians:Double) -> Int {
            wedgeNumberFor(angle: Measurement<UnitAngle>(value: radians, unit: .radians))
        }
        
        init(compassAngle:Measurement<UnitAngle>) {
            self = Self.init(wedgeNumber: Self.wedgeNumberFor(angle:compassAngle))
        }
        
        init(degrees:Double) {
            self = Self.init(wedgeNumber: Self.wedgeNumberFor(degrees: degrees))
        }
        
        init(radians:Double) {
            self = Self.init(wedgeNumber: Self.wedgeNumberFor(radians: radians))
        }
        
        init(wedgeNumber:Int) {
            self = Self.directionFromWedgeNumber(wedgeNumber: wedgeNumber)
        }
        
        static func directionFromWedgeNumber(wedgeNumber:Int) -> Self {
            guard Range(0...(Self.numberOfWedges - 1)).contains(wedgeNumber) else {
                //TODO: throw error? clamp? divide?
                //print("BlueSky CD.directionFromWedgeNumber: Bad wedgeNumer: \(wedgeNumber)")
                fatalError("BlueSky CD.directionFromWedgeNumber: Attempted wedgeNumber \(wedgeNumber) is out of bounds")

            }
            
            return Self.allCases.first(where: { $0.wedgeNumber == wedgeNumber })!
        }
        
        var wedgeNumber:Int {
            switch self {
            case .north: return 0
            case .northNortheast: return 1
            case .northeast: return 2
            case .eastNortheast: return 3
            case .east: return 4
            case .eastSoutheast: return 5
            case .southeast: return 6
            case .southSoutheast: return 7
            case .south: return 8
            case .southSouthwest: return 9
            case .southwest: return 10
            case .westSouthwest: return 11
            case .west: return 12
            case .westNorthwest: return 13
            case .northwest: return 14
            case .northNorthwest: return 15
            }
        }
    }

//    var radianValues:(mid:Double, lower:Double, upper:Double) {
//        return Wind.CompassDirection.rangeCalculation(wedgeNumber:self.wedgeNumber)
//    }
//
//    private static func rangeCalculation(wedgeNumber:Int, numberOfWedges:Double = 16.0) -> (mid:Double, lower:Double, upper:Double) {
//        let wedgeSize = (2 * Double.pi)/numberOfWedges
//        let halfWedge = wedgeSize/2
//        let midpoint = wedgeSize * Double(wedgeNumber)
//        let lowerBound = midpoint - halfWedge
//        let upperBound = midpoint + halfWedge
//        return (midpoint, lowerBound, upperBound)
//    }
//}
