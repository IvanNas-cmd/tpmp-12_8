import UIKit
import CoreData
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ app: UIApplication, didFinishLaunchingWithOptions opts: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        preloadData()
        return true
    }
    func application(_ app: UIApplication, configurationForConnecting scene: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default", sessionRole: scene.role)
    }
    lazy var persistentContainer: NSPersistentContainer = {
        let c = NSPersistentContainer(name: "BSUModel")
        c.loadPersistentStores { _, error in if let e = error { fatalError(e.localizedDescription) } }
        return c
    }()
    func saveContext() {
        let ctx = persistentContainer.viewContext
        if ctx.hasChanges { try? ctx.save() }
    }
    func preloadData() {
        let ctx = persistentContainer.viewContext
        let req = NSFetchRequest<NSManagedObject>(entityName: "UniversityBuilding")
        guard (try? ctx.count(for: req)) == 0 else { return }
        let buildings: [(String, String, String, String, Double, Double, String)] = [
            ("ФПМИ", "faculty", "Moscow", "Kalgvarijskaja 1", 53.8900, 27.5350, "Faculty of Applied Mathematics and Computer Science"),
            ("Philological Faculty", "faculty", "Lenin", "K. Marksa 31", 53.8950, 27.5550, "Faculty of Philology"),
            ("Law Faculty", "faculty", "Lenin", "Leningradskaja 8", 53.8930, 27.5600, "Faculty of Law"),
            ("FMO", "faculty", "Lenin", "Leningradskaja 20", 53.8940, 27.5620, "Faculty of International Relations"),
            ("Chemistry Faculty", "faculty", "Lenin", "Leningradskaja 14", 53.8935, 27.5610, "Faculty of Chemistry"),
            ("History Faculty", "faculty", "Lenin", "Krasnoarmejskaja 6", 53.8960, 27.5530, "Faculty of History"),
            ("Mechanics and Mathematics", "faculty", "Lenin", "Nezavisimosti 4", 53.8920, 27.5480, "Mechanics and Mathematics"),
            ("Physics Faculty", "faculty", "Lenin", "Bobrujskaja 5", 53.8910, 27.5500, "Faculty of Physics"),
            ("Biology Faculty", "faculty", "Partizan", "Kurchatova 10", 53.8700, 27.6000, "Faculty of Biology"),
            ("Geography Faculty", "faculty", "Partizan", "Dolgobrodskaja 23", 53.8750, 27.5900, "Faculty of Geography"),
            ("Economics Faculty", "faculty", "Oktyabr", "Nezavisimosti 4", 53.8920, 27.5480, "Faculty of Economics"),
            ("Dormitory 1", "dormitory", "Lenin", "Uljanovskaja 8", 53.8970, 27.5650, "Student Dormitory 1"),
            ("Dormitory 2", "dormitory", "Moscow", "Dzerzhinskogo 83", 53.8800, 27.5300, "Student Dormitory 2"),
        ]
        for b in buildings {
            let obj = NSEntityDescription.insertNewObject(forEntityName: "UniversityBuilding", into: ctx)
            obj.setValue(b.0, forKey: "name")
            obj.setValue(b.1, forKey: "type")
            obj.setValue(b.2, forKey: "district")
            obj.setValue(b.3, forKey: "address")
            obj.setValue(b.4, forKey: "latitude")
            obj.setValue(b.5, forKey: "longitude")
            obj.setValue(b.6, forKey: "info")
        }
        try? ctx.save()
    }
}