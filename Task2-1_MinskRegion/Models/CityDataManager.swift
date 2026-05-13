import Foundation
class CityDataManager {
    static func loadCities() -> [City] {
        guard let path = Bundle.main.path(forResource: "Cities", ofType: "plist"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let dicts = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [[String: Any]] else { return [] }
        return dicts.compactMap { d in
            guard let name = d["name"] as? String,
                  let desc = d["description"] as? String,
                  let lat = d["latitude"] as? Double,
                  let lon = d["longitude"] as? Double,
                  let facts = d["facts"] as? String,
                  let img = d["imageName"] as? String else { return nil }
            return City(name: name, description: desc, latitude: lat, longitude: lon, facts: facts, imageName: img)
        }
    }
}