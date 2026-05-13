import UIKit
class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [AuthViewController()]
    }
}