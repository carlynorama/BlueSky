//
//  WeatherAttributionMarkView.swift
//  Wind
//
//  Created by Labtanza on 6/24/22.
//

import SwiftUI
import WeatherKit

public extension BlueSky {
    struct AttributionMarkView: View {
        @Environment(\.colorScheme) var colorScheme: ColorScheme
        @State private var attributionLink: URL?
        @State private var attributionLogo: URL?
        
        public var body: some View {
            VStack {
                VStack {
                    AsyncImage(url: attributionLogo) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                            .controlSize(.mini)
                    }
                    .frame(width: 20, height: 20)
                    
                    Link("Other data sources", destination: attributionLink ?? URL(string: "https://weather-data.apple.com/legal-attribution.html")!)
                }
                .font(.footnote)
            }.task() {
                do {
                    let attribution = try await WeatherService.shared.attribution
                    attributionLink = attribution.legalPageURL
                    attributionLogo = colorScheme == .light ? attribution.combinedMarkLightURL : attribution.combinedMarkDarkURL
                } catch {
                    print("Could not get weather mark", error.localizedDescription)
                }
                
            }
            
        }
    }
    
    public struct WeatherAttributionMarkView_Previews: PreviewProvider {
        public static var previews: some View {
            AttributionMarkView()
        }
    }
}

