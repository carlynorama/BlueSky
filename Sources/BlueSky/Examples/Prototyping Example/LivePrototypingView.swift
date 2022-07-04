//
//  SwiftUIView.swift
//  
//
//  Created by Labtanza on 7/3/22.
//

import SwiftUI

public extension BlueSky {
    struct LivePrototypingView: View {
        @StateObject var weatherMap = PrototypeMapping()
        
        public init() {}
        
        
        public var body: some View {
            HStack {
                DisplayView()
                ControllersView()
            }.environmentObject(weatherMap)
        }
    }
    
//    struct LivePrototypingView_Previews: PreviewProvider {
//        public static var previews: some View {
//            LivePrototypingView()
//        }
//    }

}


