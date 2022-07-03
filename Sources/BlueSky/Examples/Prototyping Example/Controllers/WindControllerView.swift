//
//  SwiftUIView.swift
//  
//
//  Created by Labtanza on 7/3/22.
//

import SwiftUI

extension BlueSky {
    struct WindControllerView: View {
        @EnvironmentObject var weatherMap:PrototypeMapping
        
        func doublestring(_ double:Double) -> String {
            (String(format: "%.4f", double))
        }
        
        var body: some View {
            Group{
            Text ("Date of Report: \(weatherMap.windReport.date )")
           VStack(alignment: .leading, spacing: 0) {
              HStack {
                   Text("Wind Direction")
                   Spacer()
                  Text("\(weatherMap.windReport.compassDirection.description )")
               }
              HStack {
                  Text("\(doublestring(weatherMap.windReport.direction.converted(to: .degrees).value))")
                  Slider(value: $weatherMap.windReport.direction.value, in: 0...360)
              }
    //
            }
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Wind Speed")
                    Spacer()
                    Text("\(weatherMap.windReport.windLevel.description) (\(weatherMap.windReport.windLevel.force))")
                }
                HStack {
                    Text("\(doublestring(weatherMap.windReport.speed.converted(to: .knots).value)) kn")
                    Slider(value: $weatherMap.windReport.speed.value, in: 0...64)
                }
            }
            
            //TODO: Why dont the speed and gust sliders match?
            //TODO: Where are the wind level values?
            //TODO: Dummy gusts so much lower than wind speed??
            
                VStack(alignment: .leading, spacing: 0) {
                    HStack{
                        Text("Gusts Data")
                        Spacer()
                        //Toggle("", isOn:$weatherMap.useGustSpeedIfAvailable)
                    }
                    
                    HStack {
                        if weatherMap.gustsDefined {
                            Text("\(doublestring(weatherMap.windReport.gustSpeed?.converted(to: .metersPerSecond).value ?? 0))")
                            
                            Slider(value: $weatherMap.gustForBinding, in: 0...64)
                        } else {
                            Text("Gust Speed is Not Defined")
                            Button("Define as Speed") {
                                weatherMap.windReport.gustSpeed = weatherMap.windReport.speed
                                weatherMap.gustForBinding = weatherMap.windReport.gustSpeedAsMPS!
                            }
                        }
                    }.opacity(weatherMap.useGustSpeedIfAvailable ? 1.0 : 0.5)
                }
            }
        }
    }
    
    struct SwiftUIView_Previews: PreviewProvider {
        static var previews: some View {
            WindControllerView().environmentObject(WeatherMapping())
        }
    }
    
}
