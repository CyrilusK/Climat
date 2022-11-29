import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=5bc95c7c3abb9acc6b5354a421b76c21&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = weatherURL + "&q=\(cityName)"
        performRequest(urlStr: urlString)
    }
    
    func performRequest(urlStr: String) {
        //1. Create a URL
        if let url = URL(string: urlStr) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, responce, error in
                if error != nil {
                    print(error!)
                }
                if let data = data {
                    //let dataString = String(data: data, encoding: .utf8)
                    parseJSON(weatherData: data)
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let cityName = decodedData.name
            let idWeather = decodedData.weather[0].id
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(cityName: cityName, idWeather: idWeather, temperature: temp)
            print(weather.description)
        } catch {
            print(error)
        }
    }
    
    
}
