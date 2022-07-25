//
//  DisplayView.swift
//  
//
//  Created by Carlyn Maw on 7/3/22.
//

import SwiftUI


extension BlueSky {
    struct DisplayView: View {
        @EnvironmentObject var weather:PrototypeMapping
        
        public init() {}
        
        var windReport:WindReport {
            weather.windReport.returnStatic()
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text("The Weather").font(.largeTitle)
                Text("Basic Weather Information").font(.title)
                Text("Wind Details").font(.title)
                WindPrototypeDisplayView(windReport: windReport)
                    .font(.body)
                Spacer()
            }
            .padding()
            .environmentObject(weather)
        }
        
    }
    

    
}
