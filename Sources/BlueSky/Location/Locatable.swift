//
//  Location.swift
//  Wind
//
//  Created by Carlyn Maw on 6/24/22.
//

import CoreLocation

public protocol Locatable {
    var latitude:Double {get}
    var longitude:Double {get}
}

public extension Locatable {
    
    var cllocation:CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var placemarkDescription:String? {
        get async throws {
            try await lookUpPlacemark().locality
        }
    }
    
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
                               -> Void ) {
        // Use the last reported location.
        let location = self.cllocation
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location,
                                        completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
            }
            else {
                // An error occurred during geocoding.
                completionHandler(nil)
            }
        })
    }
    
    func lookUpPlacemark() async throws -> CLPlacemark {
        let result = try await CLGeocoder().reverseGeocodeLocation(self.cllocation)
        let firstLocation = result[0]
        return firstLocation
    }
}

