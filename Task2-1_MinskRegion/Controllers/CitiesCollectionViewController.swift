import UIKit
class CitiesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var cities: [City] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("minsk_region", comment: "")
        collectionView.backgroundColor = .white
        collectionView.register(CityCell.self, forCellWithReuseIdentifier: "cell")
        cities = CityDataManager.loadCities()
    }
    override func collectionView(_ cv: UICollectionView, numberOfItemsInSection s: Int) -> Int { cities.count }
    override func collectionView(_ cv: UICollectionView, cellForItemAt ip: IndexPath) -> UICollectionViewCell {
        let c = cv.dequeueReusableCell(withReuseIdentifier: "cell", for: ip) as! CityCell
        c.configure(with: cities[ip.row])
        return c
    }
    func collectionView(_ cv: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt ip: IndexPath) -> CGSize {
        let w = (cv.frame.width - 30) / 2
        return CGSize(width: w, height: w + 40)
    }
    override func collectionView(_ cv: UICollectionView, didSelectItemAt ip: IndexPath) {
        let vc = CityDetailViewController()
        vc.city = cities[ip.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
class CityCell: UICollectionViewCell {
    let imageView = UIImageView()
    let nameLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        imageView.frame = CGRect(x: 10, y: 10, width: frame.width - 20, height: frame.width - 20)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        contentView.addSubview(imageView)
        nameLabel.frame = CGRect(x: 10, y: frame.width - 10, width: frame.width - 20, height: 40)
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(nameLabel)
    }
    required init?(coder: NSCoder) { nil }
    func configure(with city: City) {
        nameLabel.text = city.name
        imageView.image = UIImage(named: city.imageName) ?? UIImage(systemName: "building.2")
    }
}