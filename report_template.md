# Отчёт по лабораторной работе №8
## Технологии программирования для мобильных приложений
## Вариант 17

**Студент:** Насеник Иван  
**Группа:** 12  
**Дата:** _________________

---

## 1. Примеры для изучения

### 1.1 iOS приложение с хранением данных в .plist

**Задача:** Изучить чтение/запись .plist файлов.

**Ключевой код:**
```swift
guard let path = Bundle.main.path(forResource: "Data", ofType: "plist"),
      let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else { return }
for (k, v) in dict { text += "\(k): \(v)\n" }
```

**Скриншот:** [вставить]

### 1.2 Приложение с авторизацией и NSUserDefaults

**Задача:** Форма логина/регистрации с хранением в NSUserDefaults.

**Ключевой код:**
```swift
// Сохранение
UserDefaults.standard.set(pass, forKey: login)
// Чтение
let savedPass = UserDefaults.standard.string(forKey: login)
// Флаг авторизации
UserDefaults.standard.bool(forKey: "loggedIn")
```

**Скриншот:** [вставить]

### 1.3 CoreLocation геолокация

**Задача:** Определение координат пользователя.

**Ключевой код:**
```swift
let lm = CLLocationManager()
lm.delegate = self
lm.requestWhenInUseAuthorization()
lm.startUpdatingLocation()
// В делегате:
func locationManager(_ manager: CLLocationManager, didUpdateLocations locs: [CLLocation]) {
    guard let loc = locs.last else { return }
    label.text = "Lat: \(loc.coordinate.latitude)\nLon: \(loc.coordinate.longitude)"
}
```

**Скриншот:** [вставить]

### 1.4 MapKit + CoreLocation

**Задача:** Отображение карты с текущим местоположением.

**Ключевой код:**
```swift
map.showsUserLocation = true
let region = MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
map.setRegion(region, animated: true)
let ann = MKPointAnnotation()
ann.coordinate = loc.coordinate
ann.title = "You are here"
map.addAnnotation(ann)
```

**Скриншот:** <img width="204" height="372" alt="image" src="https://github.com/user-attachments/assets/ce565ce5-95f2-4b95-8bc9-f97aa378c28d" />


### 1.5 Система бронирования (Obj-C + CoreData + MapKit)

**Задача:** Бронирование авиабилетов с CoreData и MapKit.

**Ключевой код:**
```objc
// CoreData сущность Record: cityFrom, cityTo, aviaCompany, price
// LongPress на карте:
UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
// Reverse Geocoding:
CLGeocoder *geocoder = [[CLGeocoder alloc] init];
[geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) { ... }];
```

**Скриншот:** [вставить]

### 1.6 CoreData Students

**Задача:** CRUD операции со студентами через CoreData.

**Ключевой код:**
```swift
// Добавление
let s = NSEntityDescription.insertNewObject(forEntityName: "Student", into: ctx)
s.setValue(name, forKey: "name")
try? ctx.save()
// Удаление
ctx.delete(students[indexPath.row])
try? ctx.save()
// Загрузка
let req = NSFetchRequest<NSManagedObject>(entityName: "Student")
students = (try? ctx.fetch(req)) ?? []
```

**Скриншот:** [вставить]

### 1.7 Прогноз погоды

**Задача:** Получение погоды через OpenWeatherMap API.

**Ключевой код:**
```swift
let urlStr = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
URLSession.shared.dataTask(with: url) { data, _, _ in
    guard let d = data, let json = try? JSONSerialization.jsonObject(with: d) as? [String: Any] else { return }
    if let main = json["main"] as? [String: Any], let temp = main["temp"] { ... }
}.resume()
```

**Скриншот:** [вставить]

---

## 2. Задание 2.1 — Минская область

**Технологии:** NSUserDefaults + .plist + UICollectionView + локализация (RU, EN, PL)

**Функционал:**
1. Экран авторизации с выбором языка
2. UICollectionView с 12 городами Минской области
3. Детальный экран города с картой
4. Локализация на 3 языка

**Ключевой код — чтение .plist:**
```swift
guard let path = Bundle.main.path(forResource: "Cities", ofType: "plist"),
      let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
      let dicts = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [[String: Any]] else { return }
```

**Ключевой код — локализация:**
```swift
// Переключение языка
UserDefaults.standard.set([langs[index]], forKey: "AppleLanguages")
// Использование
NSLocalizedString("auth_title", comment: "")
```

**Скриншоты:** [вставить]

---

## 3. Задание 2.2 — Карта факультетов и общежитий БГУ

**Технологии:** MapKit + CoreLocation + CoreData + OpenWeatherMap + локализация (RU, EN, PL)

**Функционал:**
1. Карта с аннотациями факультетов и общежитий БГУ
2. LongPress → список зданий в выбранном районе
3. Детальная информация + прогноз погоды
4. Локализация на 3 языка

**CoreData модель:**
```
UniversityBuilding:
  name: String, type: String, district: String,
  address: String, latitude: Double, longitude: Double, info: String
```

**Ключевой код — CoreData:**
```swift
let req = NSFetchRequest<UniversityBuilding>(entityName: "UniversityBuilding")
req.predicate = NSPredicate(format: "district CONTAINS[cd] %@", district)
let buildings = try? ctx.fetch(req)
```

**Ключевой код — погода:**
```swift
let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
```

**Скриншоты:** [вставить]

---

## 4. Контрольные вопросы и ответы

1. **CoreLocation** — фреймворк Apple для определения географического местоположения устройства через GPS, Wi-Fi и сотовую связь.
2. **MapKit** — фреймворк для отображения карт, добавления аннотаций, маршрутов и взаимодействия с картой.
3. **NSUserDefaults** — сохранение: `UserDefaults.standard.set(value, forKey: "key")`, чтение: `UserDefaults.standard.object(forKey: "key")`.
4. **.plist** — XML-файлы (Property List) для хранения структурированных данных: настроек (Info.plist), конфигураций, данных приложения.
5. **Сетевое взаимодействие** — через `URLSession`: создание запроса `URLRequest`, выполнение `dataTask(with:)`, обработка ответа (JSON, Data).
6. **Компоненты GUI iOS** — UIView, UILabel, UIButton, UITextField, UITableView, UICollectionView, MKMapView, UIImageView.
7. **Настройки для определения местоположения** — в Info.plist добавить `NSLocationWhenInUseUsageDescription` или `NSLocationAlwaysUsageDescription` с описанием причины.
8. **CoreData** — фреймворк Apple для объектно-ориентированной работы с базой данных SQLite: модели (NSManagedObject), контекст, fetch-запросы.
9. **Вставка в БД** — `NSEntityDescription.insertNewObject(forEntityName:into:)` + `context.save()`.
10. **Поиск в БД** — `NSFetchRequest` с `NSPredicate` + `executeFetchRequest()` (или `try context.fetch(request)` в Swift).

---

## 5. Выводы

В ходе работы были изучены технологии:
- Хранение данных: NSUserDefaults, .plist, CoreData
- Работа с картами: MapKit, CoreLocation
- Сетевые запросы: URLSession, OpenWeatherMap API
- Локализация приложений на 3 языка (русский, английский, польский)
- MVC-архитектура

Разработаны приложения:
- Примеры 1.1–1.7 (plist, авторизация, геолокация, карта, бронирование, CoreData, погода)
- Задание 2.1: приложение «Минская область» с UICollectionView + 3 языка
- Задание 2.2: интерактивная карта факультетов и общежитий БГУ с прогнозом погоды

---

## Ссылки

- Репозиторий: https://github.com/IvanNas-cmd/tpmp-12_7
- Ветки: example-task1..7, feature-task2-1, feature-task2-2
