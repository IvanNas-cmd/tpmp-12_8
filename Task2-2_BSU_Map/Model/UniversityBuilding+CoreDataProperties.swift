import Foundation
import CoreData
extension UniversityBuilding {
    @nonobjc class func fetchRequest() -> NSFetchRequest<UniversityBuilding> {
        NSFetchRequest<UniversityBuilding>(entityName: "UniversityBuilding")
    }
    @NSManaged var name: String?
    @NSManaged var type: String?
    @NSManaged var district: String?
    @NSManaged var address: String?
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var info: String?
}