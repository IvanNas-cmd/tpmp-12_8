import UIKit
import CoreData
import MapKit
class BuildingsListViewController: UITableViewController {
    var buildings: [UniversityBuilding] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("buildings", comment: "")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    override func tableView(_ tv: UITableView, numberOfRowsInSection s: Int) -> Int { buildings.count }
    override func tableView(_ tv: UITableView, cellForRowAt ip: IndexPath) -> UITableViewCell {
        let c = tv.dequeueReusableCell(withIdentifier: "cell", for: ip)
        let b = buildings[ip.row]
        c.textLabel?.text = b.name
        c.detailTextLabel?.text = b.address
        return c
    }
    override func tableView(_ tv: UITableView, didSelectRowAt ip: IndexPath) {
        let b = buildings[ip.row]
        let alert = UIAlertController(title: b.name, message: "Address: \(b.address ?? "")\n\(b.info ?? "")", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("weather", comment: ""), style: .default) { [weak self] _ in
            self?.showWeather(for: b)
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    func showWeather(for building: UniversityBuilding) {
        let apiKey = "YOUR_API_KEY"
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(building.latitude)&lon=\(building.longitude)&appid=\(apiKey)&units=metric&lang=ru"
        guard let url = URL(string: urlStr) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            DispatchQueue.main.async {
                guard let d = data, let json = try? JSONSerialization.jsonObject(with: d) as? [String: Any],
                      let main = json["main"] as? [String: Any], let temp = main["temp"] else {
                    let alert = UIAlertController(title: "Weather", message: "Get a free API key at openweathermap.org", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                    return
                }
                var text = "Temperature: \(temp)°C"
                if let weather = (json["weather"] as? [[String: Any]])?.first, let desc = weather["description"] {
                    text += "\nCondition: \(desc)"
                }
                let alert = UIAlertController(title: "Weather", message: text, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }.resume()
    }
}