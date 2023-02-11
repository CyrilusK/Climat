import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=***&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = weatherURL + "&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude lat: Double, longitute lon: Double) {
        let urlString = weatherURL + "&lon=\(lon)&lat=\(lat)"
        performRequest(with: urlString)
    }
    
    func performRequest(with: String) {
        //1. Create a URL
        if let url = URL(string: with) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, responce, error in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let data = data {
                    //let dataString = String(data: data, encoding: .utf8)
                    if let weather = parseJSON(data) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let cityName = decodedData.name
            let idWeather = decodedData.weather[0].id
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(cityName: cityName, idWeather: idWeather, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
    
    
}
