import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {
    let lm = CLLocationManager()
    let label = UILabel()
    let cityField = UITextField()
    let getBtn = UIButton(type: .system)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        label.frame = CGRect(x: 20, y: 120, width: view.frame.width - 40, height: 150)
        label.numberOfLines = 0
        label.textAlignment = .center
        view.addSubview(label)
        cityField.frame = CGRect(x: 20, y: 300, width: view.frame.width - 40, height: 40)
        cityField.placeholder = "Enter city name"
        cityField.borderStyle = .roundedRect
        view.addSubview(cityField)
        getBtn.frame = CGRect(x: 20, y: 360, width: view.frame.width - 40, height: 44)
        getBtn.setTitle("Get weather for city", for: .normal)
        getBtn.backgroundColor = .systemBlue
        getBtn.setTitleColor(.white, for: .normal)
        getBtn.layer.cornerRadius = 8
        getBtn.addTarget(self, action: #selector(getWeatherForCity), for: .touchUpInside)
        view.addSubview(getBtn)
        let locBtn = UIButton(type: .system)
        locBtn.frame = CGRect(x: 20, y: 420, width: view.frame.width - 40, height: 44)
        locBtn.setTitle("Get weather for my location", for: .normal)
        locBtn.backgroundColor = .systemGreen
        locBtn.setTitleColor(.white, for: .normal)
        locBtn.layer.cornerRadius = 8
        locBtn.addTarget(self, action: #selector(getWeatherForLocation), for: .touchUpInside)
        view.addSubview(locBtn)
        lm.delegate = self
        label.text = "Enter a city name or use your location"
    }
    @objc func getWeatherForCity() {
        guard let city = cityField.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), !city.isEmpty else { return }
        fetchWeather(query: "q=\(city)")
    }
    @objc func getWeatherForLocation() {
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locs: [CLLocation]) {
        guard let loc = locs.last else { return }
        lm.stopUpdatingLocation()
        fetchWeather(query: "lat=\(loc.coordinate.latitude)&lon=\(loc.coordinate.longitude)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        label.text = "Location error: \(error.localizedDescription)"
    }
    func fetchWeather(query: String) {
        let apiKey = "YOUR_API_KEY" // Get from https://openweathermap.org/api
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?\(query)&appid=\(apiKey)&units=metric&lang=en"
        guard let url = URL(string: urlStr) else { label.text = "Invalid URL"; return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                guard let d = data, let json = try? JSONSerialization.jsonObject(with: d) as? [String: Any] else {
                    self?.label.text = "Error fetching weather\n\(error?.localizedDescription ?? "unknown")"
                    return
                }
                if let main = json["main"] as? [String: Any], let temp = main["temp"], let name = json["name"] {
                    var text = "City: \(name)\nTemp: \(temp)°C"
                    if let weather = (json["weather"] as? [[String: Any]])?.first, let desc = weather["description"] {
                        text += "\nCondition: \(desc)"
                    }
                    self?.label.text = text
                } else {
                    self?.label.text = "City not found"
                }
            }
        }.resume()
    }
}