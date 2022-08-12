//
//  LocationService.swift
//  Wind
//
//  Created by Labtanza on 8/9/22.
//

import Foundation
import CoreLocation
import MapKit



public protocol LocationService:ObservableObject {
    var defaultLocation:CLLocation { get set }
    
    var locationToUse:CLLocation { get }
    var locationPublisher:Published<CLLocation>.Publisher { get }
    var locationPublished: Published<CLLocation> { get }
    
    var deviceLocation:CLLocation? { get }
}

public extension LocationService {
    
    var latitude:Double { locationToUse.coordinate.latitude }
    var longitude:Double { locationToUse.coordinate.longitude }
    
    // TODO:Returns a string that is a location in memory?
    //    var description:String? {
    //        get async throws {
    //            try await Self.placemarkForLocation(self.locationToUse).locality
    //        }
    //    }
    
    static func placemarkForLocation(_ location:CLLocation) async throws -> CLPlacemark {
        let result = try await CLGeocoder().reverseGeocodeLocation(location)
        let firstLocation = result[0]
        return firstLocation
    }
    
    
    static func locationForString(_ addressString:String) async throws -> CLLocation? {
        let result = try await CLGeocoder().geocodeAddressString(addressString)
        let firstPlaceMark = result[0]
        return firstPlaceMark.location
        //func geocodeAddressString(_ addressString: String) async throws -> [CLPlacemark]
    }
    
    static func descriptionFromPlacemark(_ placemark:CLPlacemark) -> String {
        let firstItem = placemark.locality //placemark.areasOfInterest?[0] ?? placemark.locality
        let availableInfo:[String?] = [firstItem, placemark.administrativeArea, placemark.country]
        let string = availableInfo.compactMap{ $0 }.joined(separator: ", ")
        return string
    }
    
//    static func descriptionFromLocation(_ location:CLLocation) -> String {
//        Task {
//            do {
//                let placemark = try await Self.placemarkForLocation(location)
//                let string = Self.descriptionFromPlacemark(placemark)
//                DispatchQueue.main.async {
//                    return string//?? "No place name available"
//                }
//                
//            } catch {
//                print("LM updateDescription: couldn't find locality")
//            }
//        }
//    }
}


public class LocationManager: NSObject, ObservableObject,LocationService  {
    public static let shared = LocationManager()
    
    let manager = CLLocationManager()
    
    @Published public var deviceLocation:CLLocation?
    @Published public var deviceLocality:String?
    
    public override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyReduced
        manager.requestWhenInUseAuthorization()
    }
    
    public var defaultLocation:CLLocation = CLLocation(latitude: 34.0536909,
                                                       longitude: -118.242766)
    
    //TODO:Check user defaults for a saved defaultLocation, add to init? static builder?
    @Published public var locationToUse:CLLocation = CLLocation(latitude: 34.0536909,
                                                                longitude: -118.242766)
    @Published public var locationName:String = "Default Location"
    
    //    static func determineLocationToUse(_ location:CLLocation? = nil) -> CLLocation {
    //        if let loc = location {
    //            return loc
    //        } else {
    //            //TODO: Look in user defaults.
    //            return CLLocation(latitude: 34.0536909,
    //                                      longitude: -118.242766)
    //        }
    //    }
    
    public var locationPublisher:Published<CLLocation>.Publisher {
        $locationToUse
    }
    public var locationPublished:Published<CLLocation> {
        _locationToUse
    }
    
}

extension LocationManager:CLLocationManagerDelegate {
    
    public var isEnabled:Bool? {
        switch manager.authorizationStatus {
        case .restricted, .denied:
            return false
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        case .notDetermined: // The user hasn’t chosen an authorization status
            return nil
        @unknown default:
            fatalError()
        }
    }
    
    public func locationManager(_ manager:CLLocationManager,
                                didChangeAuthorization status:CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined         : print("notDetermined")        // location permission not asked for yet
        case .authorizedWhenInUse   : print("authorizedWhenInUse")  // location authorized
        case .authorizedAlways      : print("authorizedAlways")     // location authorized
        case .restricted            : print("restricted")           // TODO: handle
        case .denied                : print("denied")               // TODO: handle
        @unknown default            : fatalError()
        }
    }
    
    public func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        deviceLocation = locations.first//?.coordinate
        updateLocality()
        if let loc = deviceLocation {
            locationToUse = loc
        } else {
            locationToUse = defaultLocation
        }
        updateDescription()
    }
    
    public func locationManager(_ manager:CLLocationManager, didFailWithError error:Error) {
        print("Error requesting location")
    }
    
    public func requestLocation() {
        manager.requestLocation()
    }
}


//MARK: Getting Descriptions
extension LocationManager {
    func updateLocality() {
        Task {
            if let loc = deviceLocation {
                do {
                    let placemark = try await Self.placemarkForLocation(loc)
                    DispatchQueue.main.async {
                        self.deviceLocality = placemark.locality
                    }
                } catch {
                    print("LM updateLocality: couldn't find locality")
                }
            }
            
        }
    }
    
    func updateDescription() {
        Task {
            do {
                DispatchQueue.main.async {
                    self.locationName = "..."
                }
                let placemark = try await Self.placemarkForLocation(locationToUse)
                let string = Self.descriptionFromPlacemark(placemark)
                
                DispatchQueue.main.async {
                    self.locationName =  string//?? "No place name available"
                }
                
            } catch {
                print("LM updateDescription: couldn't find locality")
            }
        }
    }
    
    public func updateLocationToUse(lat:Double, long:Double) {
        //TODO: save to user defaults
        let newLocation = CLLocation(latitude: lat, longitude: long)
        
        self.defaultLocation = newLocation
        self.locationToUse = newLocation
        updateDescription()
    }
    
    
}

//TODO:https://developer.apple.com/documentation/mapkit/mklocalsearchcompleter
extension LocationService {
    //TODO: Why only one result?
    public func search(for searchString:String) async throws -> [CLPlacemark] {
        var results:[CLPlacemark] = []
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchString
        
        //Add region priority? searchRequest.region = yourMapView.region
        
        let search = MKLocalSearch(request: searchRequest)
        
        do {
            let response = try await search.start()
            for item in response.mapItems {
                print(item.phoneNumber ?? "No phone number.")
                print(item.placemark.location?.coordinate.latitude)
                print(item.placemark.location?.coordinate.longitude)
                results.append(item.placemark)
            }
        } catch {
            print("LocationSevice search(): search failure.")
            //            print("Error: \(error?.localizedDescription ?? "Unknown error").")
            //            return
        }

        return results
    }
}


