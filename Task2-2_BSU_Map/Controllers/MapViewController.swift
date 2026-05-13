import UIKit
import MapKit
import CoreLocation
import CoreData
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let map = MKMapView()
    let lm = CLLocationManager()
    let langControl = UISegmentedControl(items: ["RU", "EN", "PL"])
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = NSLocalizedString("bsu_map", comment: "")
        setupUI()
        addAnnotations()
    }
    func setupUI() {
        langControl.frame = CGRect(x: 20, y: 60, width: view.frame.width - 40, height: 35)
        langControl.selectedSegmentIndex = 0
        langControl.addTarget(self, action: #selector(changeLang), for: .valueChanged)
        view.addSubview(langControl)
        map.frame = CGRect(x: 0, y: 110, width: view.frame.width, height: view.frame.height - 110)
        map.delegate = self
        map.showsUserLocation = true
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 53.890, longitude: 27.560), latitudinalMeters: 5000, longitudinalMeters: 5000), animated: false)
        view.addSubview(map)
        let lp = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        map.addGestureRecognizer(lp)
        lm.delegate = self
    }
    @objc func changeLang() {
        let langs = ["ru", "en", "pl"]
        UserDefaults.standard.set([langs[langControl.selectedSegmentIndex]], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        let alert = UIAlertController(title: NSLocalizedString("restart", comment: ""), message: NSLocalizedString("restart_msg", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in exit(0) })
        present(alert, animated: true)
    }
    func addAnnotations() {
        guard let ad = UIApplication.shared.delegate as? AppDelegate else { return }
        let ctx = ad.persistentContainer.viewContext
        let req = NSFetchRequest<UniversityBuilding>(entityName: "UniversityBuilding")
        guard let buildings = try? ctx.fetch(req) else { return }
        for b in buildings {
            let ann = MKPointAnnotation()
            ann.coordinate = CLLocationCoordinate2D(latitude: b.latitude, longitude: b.longitude)
            ann.title = b.name
            ann.subtitle = b.type
            map.addAnnotation(ann)
        }
    }
    @objc func handleLongPress(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            let point = sender.location(in: map)
            let coord = map.convert(point, toCoordinateFrom: map)
            let loc = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(loc) { [weak self] placemarks, _ in
                guard let district = placemarks?.first?.locality ?? placemarks?.first?.administrativeArea else { return }
                self?.showBuildings(for: district)
            }
        }
    }
    func showBuildings(for district: String) {
        guard let ad = UIApplication.shared.delegate as? AppDelegate else { return }
        let ctx = ad.persistentContainer.viewContext
        let req = NSFetchRequest<UniversityBuilding>(entityName: "UniversityBuilding")
        req.predicate = NSPredicate(format: "district CONTAINS[cd] %@", district)
        guard let buildings = try? ctx.fetch(req), !buildings.isEmpty else {
            let alert = UIAlertController(title: district, message: NSLocalizedString("no_buildings", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        let vc = BuildingsListViewController()
        vc.buildings = buildings
        navigationController?.pushViewController(vc, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locs: [CLLocation]) {
        guard let loc = locs.last else { return }
        map.setRegion(MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000), animated: true)
        lm.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}