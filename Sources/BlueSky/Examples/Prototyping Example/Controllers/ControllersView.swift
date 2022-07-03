//
//  ControllersView.swift
//  
//
//  Created by Labtanza on 7/3/22.
//

import SwiftUI

extension BlueSky {
    struct ControllersView: View {
        @EnvironmentObject var weatherMap:PrototypeMapping
        
        @State var showBasicControls:Bool = true
        @State var showWindControls:Bool = true
        
        
        var body: some View {
            VStack {
                Form {
                    Section(header: ControllerSectionHeaderView(title: "Basic", visibilityToggle: $showBasicControls)) {
                        if showBasicControls {
                            VStack {
                                Text("more")
                                Text("Put location swap control here.")
                            }
                        }
                        
                        Button("Get Current \(weatherMap.locationName) Weather") {
                            updateWeather()
                        }
                    }
                    Section(header: ControllerSectionHeaderView(title: "Wind", visibilityToggle: $showWindControls)) {
                        if showWindControls {
                            WindControllerView()
                        }

                    }
                }
            }.environmentObject(weatherMap)
            
        }
        
        func updateWeather() {
            print("PCV update: update underway")
            Task {
                await weatherMap.updateWeather()
            }
            print("PCV update: update completed")
        }
    }
    
    struct ControllersView_Previews: PreviewProvider {
        static var previews: some View {
            ControllersView().environmentObject(PrototypeMapping())
        }
    }
}
