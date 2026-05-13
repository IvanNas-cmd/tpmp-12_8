import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let map = MKMapView()
    let lm = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        map.frame = view.bounds
        map.delegate = self
        map.showsUserLocation = true
        view.addSubview(map)
        lm.delegate = self
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locs: [CLLocation]) {
        guard let loc = locs.last else { return }
        let region = MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.setRegion(region, animated: true)
        let ann = MKPointAnnotation()
        ann.coordinate = loc.coordinate
        ann.title = "You are here"
        map.addAnnotation(ann)
        lm.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}