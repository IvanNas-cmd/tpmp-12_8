import UIKit
import CoreData
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ app: UIApplication, didFinishLaunchingWithOptions o: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { true }
    func application(_ app: UIApplication, configurationForConnecting scene: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default", sessionRole: scene.role)
    }
    lazy var persistentContainer: NSPersistentContainer = {
        let c = NSPersistentContainer(name: "Model")
        c.loadPersistentStores { _, error in if let e = error { fatalError(e.localizedDescription) } }
        return c
    }()
    func saveContext() {
        let ctx = persistentContainer.viewContext
        if ctx.hasChanges { try? ctx.save() }
    }
}