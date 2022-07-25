//
//  LocationStore.swift
//  Wind
//
//  Created by Carlyn Maw on 6/24/22.
//
// More Locations? https://www.kurzwind.com/9-windiest-cities/
// Barrow Island, Australia
// Cape Blanco, Oregon
// Ab-Paran, Afghanistan
// Gruissan, France

import Foundation

public struct Location:Locatable {
    public let latitude:Double
    public let longitude:Double
    let description:String
}

struct LocationStore {
    public static let locations = [
        Location(
            latitude: 34.0536909,
            longitude: -118.242766,
            description: "Los Angeles, CA, United States"),
        Location(
            latitude: 25.7959,
            longitude: -80.2871,
            description: "Miami, FL, United States"),
        Location(
            latitude: 41.8755616,
            longitude: -87.6244212,
            description: "Chicago, IL, United States"),
        Location(
            latitude: 47.4612,
            longitude: 8.5535,
            description: "Wellington, New Zealand"),
        Location(
            latitude: -8.7467,
            longitude: 115.1668,
            description: "Rio Gallegos, Argentina"),
        Location(
            latitude: -37.8142176,
            longitude: 144.9631608,
            description: "St. Johns, NL, Canada"),
        Location(
            latitude: -37.8142176,
            longitude: 144.9631608,
            description: "Punta Arenas, Chile"),
        Location(
            latitude: -37.8142176,
            longitude: 144.9631608,
            description: "Dodge City, KS, United States"),
        Location(
            latitude: 3.52559,
            longitude: 36.0745062,
            description: "Lake Turkana, Marsabit County, Kenya"),
        Location(
            latitude: -66.9000,
            longitude: 142.6667,
            description: "Commonwealth Bay, Antarctica"),
        Location(
            latitude: 47.4612,
            longitude: 8.5535,
            description: "Zürich"),
        Location(
            latitude: -8.7467,
            longitude: 115.1668,
            description: "Bali")
    ]
}

