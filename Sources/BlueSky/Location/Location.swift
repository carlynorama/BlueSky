//
//  File.swift
//  
//
//  Created by Labtanza on 8/11/22.
//

import Foundation
import CoreLocation


public struct Location:Locatable, Hashable, Identifiable {
    public let latitude:Double
    public let longitude:Double
    public let description:String
    
    public var id:String {
        "\(latitude)+\(longitude)"
    }
}

public extension Location {
    init?(from placemark:CLPlacemark) {
        if let location = placemark.location {
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.latitude
        } else {
            return nil
        }
        
        self.description = LocationManager.descriptionFromPlacemark(placemark)

    }
}
