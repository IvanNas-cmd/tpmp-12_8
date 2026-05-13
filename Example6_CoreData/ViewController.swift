import UIKit
import CoreData
class ViewController: UIViewController, UITableViewDataSource {
    let tableView = UITableView()
    let textField = UITextField()
    var students: [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Students"
        setupUI()
        loadData()
    }
    func setupUI() {
        textField.frame = CGRect(x: 20, y: 100, width: view.frame.width - 90, height: 40)
        textField.placeholder = "Enter student name"
        textField.borderStyle = .roundedRect
        view.addSubview(textField)
        let addBtn = UIButton(type: .system)
        addBtn.frame = CGRect(x: view.frame.width - 60, y: 100, width: 50, height: 40)
        addBtn.setTitle("Add", for: .normal)
        addBtn.addTarget(self, action: #selector(addStudent), for: .touchUpInside)
        view.addSubview(addBtn)
        tableView.frame = CGRect(x: 0, y: 160, width: view.frame.width, height: view.frame.height - 160)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    func loadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let ctx = appDelegate.persistentContainer.viewContext
        let req = NSFetchRequest<NSManagedObject>(entityName: "Student")
        students = (try? ctx.fetch(req)) ?? []
        tableView.reloadData()
    }
    @objc func addStudent() {
        guard let name = textField.text, !name.isEmpty else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let ctx = appDelegate.persistentContainer.viewContext
        let s = NSEntityDescription.insertNewObject(forEntityName: "Student", into: ctx)
        s.setValue(name, forKey: "name")
        try? ctx.save()
        textField.text = ""
        loadData()
    }
    func tableView(_ tv: UITableView, numberOfRowsInSection s: Int) -> Int { students.count }
    func tableView(_ tv: UITableView, cellForRowAt ip: IndexPath) -> UITableViewCell {
        let c = tv.dequeueReusableCell(withIdentifier: "cell", for: ip)
        c.textLabel?.text = students[ip.row].value(forKey: "name") as? String
        return c
    }
    func tableView(_ tv: UITableView, commit es: UITableViewCell.EditingStyle, forRowAt ip: IndexPath) {
        if es == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let ctx = appDelegate.persistentContainer.viewContext
            ctx.delete(students[ip.row])
            try? ctx.save()
            students.remove(at: ip.row)
            tv.deleteRows(at: [ip], with: .left)
        }
    }
}