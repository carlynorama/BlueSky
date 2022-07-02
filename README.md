# BlueSky

This package is for exploring the new Apple WeatherKit native API. It is under rapid development being designed for internal use. Nothing is settled, but feel free to poke around.

[![Swift Version][swift-image]][swift-url]

## Installation

Requires:
    Xcode 14 Beta
    Platform targets iOS 16 or later, MacOS 13 or later

It is changing A LOT. Currently would suggest downloading it and using it as a local package, snagging code snippets, or just looking at the [[references][references]] below.

* Provision WeatherKit for the app via developer.apple.com
  * Certs & Identities > Identities > Add Identity
  * Tick off WeatherKit on both tabs Capabilities and App Services
* Add WeatherKit Capabilities to your app via XCode
* Crib from the BlueSky code or save locally and use as package.

## Usage example

Shows the temperature for Los Angeles.

```
import SwiftUI
import BlueSky

struct ContentView: View {    
    var body: some View {
        BlueSky.ExampleView()
      }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

## Release History

* 0.0.0
    * Current State. Wouldn't exactly call it "released"


## References [references]

### WeatherKit
* WWDC 2022 [Meet WeatherKit](https://developer.apple.com/videos/play/wwdc2022/10003/) talk
* [WeatherKit talk example code](https://developer.apple.com/documentation/weatherkit/fetching_weather_forecasts_with_weatherkit) from "Meet WeatherKit"
* [Sample Food Truck Code](https://github.com/apple/sample-food-truck/) which has a ton WeatherKit code in it. [more info](https://developer.apple.com/documentation/swiftui/food_truck_building_a_swiftui_multiplatform_app)
* Has the steps for [provisioning WeatherKit](https://betterprogramming.pub/wwdc22-get-started-with-weatherkit-202794853c01) for an App with screenshots

### Meterology
* National Weather Service [forecast weather terms](https://www.weather.gov/bgm/forecast_terms)
* National Weather Service [glossary](https://w1.weather.gov/glossary/)
* National Weather Service [Beaufort Wind Scale](https://www.weather.gov/mfl/beaufort)
* National Weather Service [Saffir-Simpson Hurricane Scale](https://www.weather.gov/mfl/saffirsimpson)
* Wikipedia [Beaufort Wind Scale](https://en.wikipedia.org/wiki/Beaufort_scale)

### General Package Creation/Documentation Tips
* [Package Swift Docs](https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html)
* [Making views work](https://www.appcoda.com/swift-packages-swiftui-views/) from a package
* [WWDC What's New in DocC](https://developer.apple.com/videos/play/wwdc2022/110368/)

## Contact and Contributing

Feature not yet available.

[swift-image]:https://img.shields.io/badge/swift-5.7-orange.svg
[swift-url]: https://swift.org/
