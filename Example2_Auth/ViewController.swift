import UIKit
class ViewController: UIViewController {
    let segment = UISegmentedControl(items: ["Login", "Register"])
    let loginField = UITextField()
    let passField = UITextField()
    let actionBtn = UIButton(type: .system)
    let regView = UIView()
    let confirmSwitch = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        if UserDefaults.standard.bool(forKey: "loggedIn") {
            showMainScreen()
        }
    }
    func setupUI() {
        segment.frame = CGRect(x: 40, y: 100, width: view.frame.width - 80, height: 35)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        view.addSubview(segment)

        loginField.frame = CGRect(x: 40, y: 160, width: view.frame.width - 80, height: 40)
        loginField.placeholder = "Login"
        loginField.borderStyle = .roundedRect
        view.addSubview(loginField)

        passField.frame = CGRect(x: 40, y: 210, width: view.frame.width - 80, height: 40)
        passField.placeholder = "Password"
        passField.isSecureTextEntry = true
        passField.borderStyle = .roundedRect
        view.addSubview(passField)

        actionBtn.frame = CGRect(x: 40, y: 270, width: view.frame.width - 80, height: 44)
        actionBtn.setTitle("Login", for: .normal)
        actionBtn.backgroundColor = .systemBlue
        actionBtn.setTitleColor(.white, for: .normal)
        actionBtn.layer.cornerRadius = 8
        actionBtn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(actionBtn)

        regView.frame = CGRect(x: 40, y: 330, width: view.frame.width - 80, height: 60)
        regView.isHidden = true
        view.addSubview(regView)

        let regLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        regLabel.text = "Accept rules:"
        regView.addSubview(regLabel)

        confirmSwitch.frame = CGRect(x: 220, y: 0, width: 50, height: 30)
        regView.addSubview(confirmSwitch)
    }
    @objc func segmentChanged() {
        let isRegister = segment.selectedSegmentIndex == 1
        regView.isHidden = !isRegister
        actionBtn.setTitle(isRegister ? "Register" : "Login", for: .normal)
    }
    @objc func buttonTapped() {
        guard let login = loginField.text, !login.isEmpty,
              let pass = passField.text, !pass.isEmpty else { return }

        if segment.selectedSegmentIndex == 0 {
            let savedPass = UserDefaults.standard.string(forKey: login)
            if savedPass == pass {
                UserDefaults.standard.set(true, forKey: "loggedIn")
                showMainScreen()
            } else {
                let alert = UIAlertController(title: "Error", message: "Invalid credentials", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
        } else {
            guard confirmSwitch.isOn else { return }
            UserDefaults.standard.set(pass, forKey: login)
            UserDefaults.standard.set(true, forKey: "loggedIn")
            showMainScreen()
        }
    }
    func showMainScreen() {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 40, y: 200, width: vc.view.frame.width - 80, height: 50))
        label.text = "Welcome! You are logged in."
        label.textAlignment = .center
        vc.view.addSubview(label)
        let logoutBtn = UIButton(type: .system)
        logoutBtn.frame = CGRect(x: 40, y: 270, width: vc.view.frame.width - 80, height: 44)
        logoutBtn.setTitle("Logout", for: .normal)
        logoutBtn.backgroundColor = .systemRed
        logoutBtn.setTitleColor(.white, for: .normal)
        logoutBtn.layer.cornerRadius = 8
        logoutBtn.addTarget(self, action: #selector(logout), for: .touchUpInside)
        vc.view.addSubview(logoutBtn)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    @objc func logout() {
        UserDefaults.standard.set(false, forKey: "loggedIn")
        dismiss(animated: true)
    }
}