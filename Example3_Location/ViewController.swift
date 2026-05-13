import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {
    let lm = CLLocationManager()
    let label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        label.frame = CGRect(x: 20, y: 200, width: view.frame.width - 40, height: 100)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Getting location..."
        view.addSubview(label)
        lm.delegate = self
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locs: [CLLocation]) {
        guard let loc = locs.last else { return }
        label.text = String(format: "Lat: %.4f\nLon: %.4f", loc.coordinate.latitude, loc.coordinate.longitude)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        label.text = "Error: \(error.localizedDescription)"
    }
}