//
//  SwiftUIView.swift
//  
//
//  Created by Labtanza on 7/3/22.
//

import SwiftUI

extension BlueSky {
    struct WindPrototypeDisplayView: View {
        var body: some View {
            VStack(alignment: .leading) {
                Text("Direction")
                Text("Compass Direction")
                Text("Speed")
                Text("Gust")
                Text("Level")
            }
            
        }
    }
    
    struct WindPrototypeDisplayView_Previews: PreviewProvider {
        static var previews: some View {
            BlueSky.WindPrototypeDisplayView()
        }
    }
}


