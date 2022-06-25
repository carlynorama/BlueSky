import SwiftUI

public struct BlueSky {
    public private(set) var text = "Hello, World!"
    
    public struct ExampleView:View {
        public init() {}
        public var body: some View {
            ExampleWeatherView()
        }
    }
    

    public init() {
    }
}
