//
//  SwiftUIView.swift
//  
//
//  Created by Carlyn Maw on 7/3/22.
//

import SwiftUI

extension BlueSky {
    struct WindPrototypeDisplayView: View {
        var windReport:WindReport
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Direction: \(windReport.compassDirection.abbreviation) \(windReport.direction.description)")
                Text("Speed: \(windReport.speed.description)")
                Text("Gust: \(windReport.gustSpeed?.description ?? "None")")
                Text("Level: \(windReport.windLevel?.description ?? "None")")
            }
            
        }
    }

}




