//
//  File.swift
//  
//
//  Created by Labtanza on 8/11/22.
//

import Foundation
import CoreLocation
import MapKit


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
            self.longitude = location.coordinate.longitude
        } else {
            return nil
        }
        
        self.description = LocationManager.descriptionFromPlacemark(placemark)
    }
    
    init(coordinates:CLLocation, name:String) {
        self.latitude = coordinates.latitude
        self.longitude = coordinates.longitude
        self.description = name
    }
    
    
    
//    init(from mkitem:MKMapItem) {
//        self.latitude = mkitem.coordinate.latitude
//        self.longitude = mkitem.coordinate.longitude
//        self.description = mkitem.name ?? "No name provided."
//    }
}
