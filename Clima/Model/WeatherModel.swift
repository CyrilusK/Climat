import Foundation

struct WeatherModel {
    let cityName: String
    let idWeather: Int
    let temperature: Double
    
    var tempString: String {
        return String(format: "%.1f", temperature)
    }
    
    var description: String {
        switch idWeather {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
}
