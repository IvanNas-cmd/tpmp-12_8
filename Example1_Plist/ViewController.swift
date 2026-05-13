import UIKit
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Plist Example"
        setupUI()
        readPlist()
    }
    func setupUI() {
        let label = UILabel(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 300))
        label.numberOfLines = 0
        label.tag = 100
        label.textAlignment = .center
        view.addSubview(label)
    }
    func readPlist() {
        guard let path = Bundle.main.path(forResource: "Data", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            (view.viewWithTag(100) as? UILabel)?.text = "No plist found"
            return
        }
        var text = ""
        for (k, v) in dict { text += "\(k): \(v)\n" }
        (view.viewWithTag(100) as? UILabel)?.text = text
    }
}