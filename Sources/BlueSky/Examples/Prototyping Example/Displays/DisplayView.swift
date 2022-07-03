//
//  DisplayView.swift
//  
//
//  Created by Labtanza on 7/3/22.
//

import SwiftUI


extension BlueSky {
    struct DisplayView: View {
        @EnvironmentObject var weather:PrototypeMapping
        
        var windReport:WindReport {
            weather.windReport.returnStatic()
        }
        
        var body: some View {
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
    
//    struct DisplayView_Previews: PreviewProvider {
//        static var previews: some View {
//            DisplayView().environmentObject(PrototypeMapping())
//        }
//    }
    
}
