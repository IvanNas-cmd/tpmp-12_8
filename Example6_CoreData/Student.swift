import Foundation
import CoreData
@objc(Student)
class Student: NSManagedObject {
    @NSManaged var name: String?
}