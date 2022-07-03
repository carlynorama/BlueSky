//
//  ControllerSectionHeaderView.swift
//  
//
//  Created by Labtanza on 7/3/22.
//

import SwiftUI
extension BlueSky {
    struct ControllerSectionHeaderView: View {
        
        var title:String
        @Binding var visibilityToggle:Bool
        
        var body: some View {
            HStack {
                Text("\(title)")
                Toggle("", isOn: $visibilityToggle.animation())
            }
        }
    }
    
    struct ControllerSectionHeaderView_Previews: PreviewProvider {
        
        static var previews: some View {
            ControllerSectionHeaderView(title: "Title", visibilityToggle: .constant(true))
        }
    }
}
