import UIKit
class AuthViewController: UIViewController {
    let loginField = UITextField()
    let passField = UITextField()
    let loginBtn = UIButton(type: .system)
    let langControl = UISegmentedControl(items: ["RU", "EN", "PL"])
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = NSLocalizedString("auth_title", comment: "")
        setupUI()
        if UserDefaults.standard.bool(forKey: "loggedIn") {
            goToMain()
        }
    }
    func setupUI() {
        langControl.frame = CGRect(x: 40, y: 80, width: view.frame.width - 80, height: 35)
        langControl.selectedSegmentIndex = 0
        langControl.addTarget(self, action: #selector(changeLang), for: .valueChanged)
        view.addSubview(langControl)
        loginField.frame = CGRect(x: 40, y: 140, width: view.frame.width - 80, height: 40)
        loginField.placeholder = NSLocalizedString("login", comment: "")
        loginField.borderStyle = .roundedRect
        view.addSubview(loginField)
        passField.frame = CGRect(x: 40, y: 200, width: view.frame.width - 80, height: 40)
        passField.placeholder = NSLocalizedString("password", comment: "")
        passField.isSecureTextEntry = true
        passField.borderStyle = .roundedRect
        view.addSubview(passField)
        loginBtn.frame = CGRect(x: 40, y: 260, width: view.frame.width - 80, height: 44)
        loginBtn.setTitle(NSLocalizedString("enter", comment: ""), for: .normal)
        loginBtn.backgroundColor = .systemBlue
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.layer.cornerRadius = 8
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        view.addSubview(loginBtn)
    }
    @objc func changeLang() {
        let langs = ["ru", "en", "pl"]
        UserDefaults.standard.set([langs[langControl.selectedSegmentIndex]], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        let alert = UIAlertController(title: NSLocalizedString("restart", comment: ""), message: NSLocalizedString("restart_msg", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in exit(0) })
        present(alert, animated: true)
    }
    @objc func login() {
        guard let login = loginField.text, !login.isEmpty, let pass = passField.text, !pass.isEmpty else { return }
        UserDefaults.standard.set(pass, forKey: login)
        UserDefaults.standard.set(true, forKey: "loggedIn")
        goToMain()
    }
    func goToMain() {
        let vc = CitiesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.setViewControllers([vc], animated: true)
    }
}