import SwiftUI

public struct BlueSky {
    public private(set) var text = "Hello, World!"
    
    public struct ExampleView:View {
        public var body: some View {
            ExampleWeatherView()
        }
    }
    

    public init() {
    }
}
