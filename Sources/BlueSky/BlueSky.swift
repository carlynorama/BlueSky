import SwiftUI

public struct BlueSky {
    public private(set) var text = "Hello, World!"

    /// A view that displays the temperature in Los Angeles.
    ///
    /// This view is the HelloWord of ``BlueSky``. It provides proof that the App's connection to WeatherKit is working.
    /// Creating an ExampleView by putting it any view. It requires no parameters.
    /// ```
    /// public var body: some View {
    ///    ExampleView()
    /// }
    /// ```
    ///
    public struct WeatherTestView:View {
        public init() {}
        public var body: some View {
            HelloWeather()
        }
    }


    public init() {
    }
}
