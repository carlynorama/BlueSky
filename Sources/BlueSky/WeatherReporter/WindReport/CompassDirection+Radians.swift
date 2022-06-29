//
//  File.swift
//  
//
//  Created by Labtanza on 6/29/22.
//

import Foundation
import WeatherKit

extension WeatherKit.Wind.CompassDirection {
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
    
    var radianValues:(mid:Double, lower:Double, upper:Double) {
        return Wind.CompassDirection.rangeCalculation(wedgeNumber:self.wedgeNumber)
    }
    
    private static func rangeCalculation(wedgeNumber:Int, numberOfWedges:Double = 16.0) -> (mid:Double, lower:Double, upper:Double) {
        let wedgeSize = (2 * Double.pi)/numberOfWedges
        let halfWedge = wedgeSize/2
        let midpoint = wedgeSize * Double(wedgeNumber)
        let lowerBound = midpoint - halfWedge
        let upperBound = midpoint + halfWedge
        return (midpoint, lowerBound, upperBound)
    }
}
