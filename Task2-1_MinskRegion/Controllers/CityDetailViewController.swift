import UIKit
import MapKit
class CityDetailViewController: UIViewController {
    var city: City?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = city?.name
        let scroll = UIScrollView(frame: view.bounds)
        view.addSubview(scroll)
        var y: CGFloat = 20
        if let img = UIImage(named: city?.imageName ?? "") {
            let iv = UIImageView(frame: CGRect(x: 20, y: y, width: view.frame.width - 40, height: 200))
            iv.image = img
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.layer.cornerRadius = 12
            scroll.addSubview(iv)
            y += 220
        }
        let nameL = UILabel(frame: CGRect(x: 20, y: y, width: view.frame.width - 40, height: 30))
        nameL.text = city?.name
        nameL.font = .boldSystemFont(ofSize: 24)
        scroll.addSubview(nameL)
        y += 40
        let descL = UILabel(frame: CGRect(x: 20, y: y, width: view.frame.width - 40, height: 60))
        descL.text = city?.description
        descL.numberOfLines = 0
        scroll.addSubview(descL)
        y += 70
        let factsL = UILabel(frame: CGRect(x: 20, y: y, width: view.frame.width - 40, height: 100))
        factsL.text = NSLocalizedString("facts", comment: "") + ": " + (city?.facts ?? "")
        factsL.numberOfLines = 0
        scroll.addSubview(factsL)
        y += 120
        let map = MKMapView(frame: CGRect(x: 20, y: y, width: view.frame.width - 40, height: 200))
        if let c = city {
            let coord = CLLocationCoordinate2D(latitude: c.latitude, longitude: c.longitude)
            map.setRegion(MKCoordinateRegion(center: coord, latitudinalMeters: 10000, longitudinalMeters: 10000), animated: false)
            let ann = MKPointAnnotation()
            ann.coordinate = coord
            ann.title = c.name
            map.addAnnotation(ann)
        }
        scroll.addSubview(map)
        scroll.contentSize = CGSize(width: view.frame.width, height: y + 250)
    }
}