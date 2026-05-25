# Отчёт по лабораторной работе №8
## Технологии программирования для мобильных приложений
## Вариант 17

**Студент:** Насеник Иван  
**Группа:** 12  
**Дата:** 18.05.2026

---

## 1. Примеры для изучения

### 1.1 iOS приложение с хранением данных в .plist

**Задача:** Изучить чтение/запись .plist файлов.

**Ветка:** `example-task1`  
**Проект:** `Example1_Plist.xcodeproj`  
**Bundle ID:** `com.ivan.lab8.Example1_Plist`

**Ключевой код:**
```swift
guard let path = Bundle.main.path(forResource: "Data", ofType: "plist"),
      let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else { return }
for (k, v) in dict { text += "\(k): \(v)\n" }
```

**Описание:** Приложение читает файл `Data.plist` из бандла и выводит все пары ключ-значение на экран через `UILabel`. Демонстрирует работу с `NSDictionary`, `Bundle.main.path` и базовым отображением данных.

---

### 1.2 Приложение с авторизацией и NSUserDefaults

**Задача:** Форма логина/регистрации с хранением данных в NSUserDefaults.

**Ветка:** `example-task2`  
**Проект:** `Example2_Auth.xcodeproj`  
**Bundle ID:** `com.ivan.lab8.Example2_Auth`

**Ключевой код:**
```swift
// Сохранение пароля
UserDefaults.standard.set(password, forKey: login)

// Чтение и проверка
let savedPass = UserDefaults.standard.string(forKey: login)
guard savedPass == password else { showError(); return }

// Флаг сессии
UserDefaults.standard.set(true, forKey: "loggedIn")
```

**Описание:** Форма с `UISegmentedControl` для переключения между режимами «Войти» и «Зарегистрироваться». `UISwitch` для согласия с правилами. Пароли хранятся в `NSUserDefaults` по ключу-логину.

---

### 1.3 CoreLocation — определение геолокации

**Задача:** Определение текущих координат устройства.

**Ветка:** `example-task3`

**Ключевой код:**
```swift
let locationManager = CLLocationManager()
locationManager.delegate = self
locationManager.requestWhenInUseAuthorization()
locationManager.startUpdatingLocation()

// Делегат
func locationManager(_ manager: CLLocationManager,
                     didUpdateLocations locations: [CLLocation]) {
    guard let loc = locations.last else { return }
    label.text = "Lat: \(loc.coordinate.latitude)\nLon: \(loc.coordinate.longitude)"
}
```

**Info.plist (обязательно):**
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Приложение использует геолокацию для определения вашего положения.</string>
```

---

### 1.4 MapKit + CoreLocation

**Задача:** Отображение карты с текущим местоположением пользователя.

**Ветка:** `example-task4`

**Ключевой код:**
```swift
mapView.showsUserLocation = true

let region = MKCoordinateRegion(
    center: location.coordinate,
    latitudinalMeters: 1000,
    longitudinalMeters: 1000
)
mapView.setRegion(region, animated: true)

let annotation = MKPointAnnotation()
annotation.coordinate = location.coordinate
annotation.title = "Вы здесь"
mapView.addAnnotation(annotation)
```

---

### 1.5 Система бронирования (Objective-C + CoreData + MapKit)

**Задача:** Бронирование авиабилетов с CoreData и MapKit.

**Ветка:** `example-task5`

**Ключевой код:**
```objc
// LongPress на карте
UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc]
    initWithTarget:self action:@selector(handleLongPress:)];
[self.mapView addGestureRecognizer:lp];

// Reverse Geocoding
CLGeocoder *geocoder = [[CLGeocoder alloc] init];
[geocoder reverseGeocodeLocation:location
               completionHandler:^(NSArray *placemarks, NSError *error) {
    CLPlacemark *place = placemarks.firstObject;
    self.cityLabel.text = place.locality;
}];

// Сохранение в CoreData
NSManagedObject *record = [NSEntityDescription
    insertNewObjectForEntityForName:@"Record"
             inManagedObjectContext:self.context];
[record setValue:cityFrom forKey:@"cityFrom"];
[record setValue:cityTo   forKey:@"cityTo"];
[self.context save:nil];
```

---

### 1.6 CoreData Students — CRUD операции

**Задача:** Полный CRUD со студентами через CoreData.

**Ветка:** `example-task6`

**Ключевой код:**
```swift
// Добавление
let student = NSEntityDescription.insertNewObject(
    forEntityName: "Student", into: context)
student.setValue(name, forKey: "name")
try? context.save()

// Загрузка
let request = NSFetchRequest<NSManagedObject>(entityName: "Student")
students = (try? context.fetch(request)) ?? []

// Удаление
context.delete(students[indexPath.row])
try? context.save()
tableView.deleteRows(at: [indexPath], with: .automatic)
```

---

### 1.7 Прогноз погоды — OpenWeatherMap API

**Задача:** Получение данных о погоде через REST API.

**Ветка:** `example-task7`

**Ключевой код:**
```swift
let urlString = "https://api.openweathermap.org/data/2.5/weather" +
    "?q=\(city)&appid=\(apiKey)&units=metric&lang=ru"

URLSession.shared.dataTask(with: URL(string: urlString)!) { data, _, _ in
    guard let data = data,
          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
          let main = json["main"] as? [String: Any],
          let temp = main["temp"] as? Double else { return }
    DispatchQueue.main.async {
        self.tempLabel.text = String(format: "%.0f°C", temp)
    }
}.resume()
```

---

## 2. Задание 2.1 — Минская область

**Ветка:** `feature-task2-1`  
**Проект:** `Task2-1_MinskRegion.xcodeproj`  
**Bundle ID:** `com.ivan.lab8.Task2-1`  
**Технологии:** NSUserDefaults · .plist · UICollectionView · Локализация RU/EN/PL · MVC

### Функционал

1. Экран авторизации с `UISegmentedControl` (Войти / Зарегистрироваться) и выбором языка
2. `UICollectionView` с 12 городами Минской области (данные из `Cities.plist`)
3. Детальный экран города с картой (`MapKit`) и характеристиками
4. Локализация на 3 языка (русский, английский, польский)

### Архитектура (MVC)

```
AuthViewController        — авторизация, NSUserDefaults
CitiesCollectionViewController — коллекция городов
CityDetailViewController  — детали города + MapKit
CityDataManager           — чтение Cities.plist
City                      — модель данных
NavigationController      — кастомный UINavigationController
```

### Структура Cities.plist

```xml
<array>
  <dict>
    <key>name</key>       <string>Минск</string>
    <key>population</key> <integer>2100000</integer>
    <key>area</key>       <real>348.84</real>
    <key>founded</key>    <integer>1067</integer>
    <key>district</key>   <string>Минский</string>
    <key>latitude</key>   <real>53.9045</real>
    <key>longitude</key>  <real>27.5615</real>
    <key>description</key><string>Столица Республики Беларусь</string>
  </dict>
  <!-- ... ещё 11 городов ... -->
</array>
```

### Ключевой код — чтение .plist

```swift
func loadCities() -> [City] {
    guard let path = Bundle.main.path(forResource: "Cities", ofType: "plist"),
          let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
          let dicts = try? PropertyListSerialization.propertyList(
              from: data, format: nil) as? [[String: Any]]
    else { return [] }
    return dicts.compactMap { City(dict: $0) }
}
```

### Ключевой код — авторизация (NSUserDefaults)

```swift
// Регистрация
func register(login: String, password: String) -> Bool {
    guard UserDefaults.standard.string(forKey: login) == nil else { return false }
    UserDefaults.standard.set(password, forKey: login)
    return true
}

// Вход
func login(login: String, password: String) -> Bool {
    let saved = UserDefaults.standard.string(forKey: login)
    guard saved == password else { return false }
    UserDefaults.standard.set(true, forKey: "loggedIn")
    UserDefaults.standard.set(login, forKey: "currentUser")
    return true
}
```

### Ключевой код — переключение языка

```swift
@IBAction func languageChanged(_ sender: UISegmentedControl) {
    let languages = ["ru", "en", "pl"]
    let selected = languages[sender.selectedSegmentIndex]
    UserDefaults.standard.set([selected], forKey: "AppleLanguages")
    UserDefaults.standard.synchronize()
    // Перезапуск интерфейса
    restartRootViewController()
}

private func restartRootViewController() {
    guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = scene.windows.first else { return }
    window.rootViewController = AuthViewController()
}
```

### Скриншоты

```
┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐
│   Авторизация   │   │  Города области │   │    Борисов      │
│                 │   │                 │   │                 │
│  [МО]           │   │ ┌─────┐ ┌─────┐ │   │ [карта]         │
│  Минская область│   │ │Минск│ │Бори-│ │   │                 │
│                 │   │ │2.1M │ │сов  │ │   │ Район: Борисовск│
│ [RU] [EN] [PL] │   │ │     │ │143K │ │   │ Нас.: 143 тыс.  │
│                 │   │ └─────┘ └─────┘ │   │ Осн.: 1102      │
│ [Логин        ] │   │ ┌─────┐ ┌─────┐ │   │ Пл.: 37.7 км²   │
│ [Пароль       ] │   │ │Моло-│ │Жоди-│ │   │                 │
│ ◉ Принять прав.│   │ │дечно│ │но   │ │   │                 │
│                 │   │ │97K  │ │63K  │ │   │                 │
│   [  Войти  ]  │   │ └─────┘ └─────┘ │   │                 │
└─────────────────┘   └─────────────────┘   └─────────────────┘
  Авторизация           UICollectionView       Детальный экран
  NSUserDefaults        12 городов             MapKit + .plist
```

---

## 3. Задание 2.2 — Карта факультетов и общежитий БГУ

**Ветка:** `feature-task2-2`  
**Проект:** `Task2-2_BSU_Map.xcodeproj`  
**Bundle ID:** `com.ivan.lab8.Task2-2`  
**Технологии:** MapKit · CoreLocation · CoreData · OpenWeatherMap · Локализация RU/EN/PL · MVC

### Функционал

1. Карта с аннотациями факультетов (синие) и общежитий (красные) БГУ
2. LongPress на районе → список зданий этого района (CoreData + NSPredicate)
3. Детальный экран здания с адресом, информацией и прогнозом погоды
4. Локализация на 3 языка

### Архитектура (MVC)

```
MapViewController          — карта, аннотации, LongPress
BuildingsListViewController — список зданий района (CoreData)
AppDelegate                — preloadData(), NSPersistentContainer
WeatherService             — запросы к OpenWeatherMap API
```

### CoreData модель — UniversityBuilding

| Атрибут     | Тип    | Пример                            |
|-------------|--------|-----------------------------------|
| `name`      | String | "ФПМИ"                            |
| `type`      | String | "faculty" / "dormitory"           |
| `district`  | String | "Moscow" / "Lenin" / "Partizan"   |
| `address`   | String | "Kalgvarijskaja 1"                |
| `latitude`  | Double | 53.8900                           |
| `longitude` | Double | 27.5350                           |
| `info`      | String | "Faculty of Applied Mathematics…" |

### Предзагруженные здания (13 объектов)

| Название             | Тип        | Район    |
|----------------------|------------|----------|
| ФПМИ                 | faculty    | Moscow   |
| Филологический       | faculty    | Lenin    |
| Юридический          | faculty    | Lenin    |
| ФМО                  | faculty    | Lenin    |
| Химический           | faculty    | Lenin    |
| Исторический         | faculty    | Lenin    |
| Механико-математ.    | faculty    | Lenin    |
| Физический           | faculty    | Lenin    |
| Биологический        | faculty    | Partizan |
| Географический       | faculty    | Partizan |
| Экономический        | faculty    | Oktyabr  |
| Общежитие №1         | dormitory  | Lenin    |
| Общежитие №2         | dormitory  | Moscow   |

### Ключевой код — предзагрузка CoreData

```swift
func preloadData() {
    let context = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "UniversityBuilding")
    guard (try? context.count(for: request)) == 0 else { return } // не дублируем

    let buildings: [(String, String, String, String, Double, Double, String)] = [
        ("ФПМИ", "faculty", "Moscow", "Kalgvarijskaja 1", 53.8900, 27.5350,
         "Факультет прикладной математики и информатики"),
        // ... остальные здания
    ]

    for b in buildings {
        let obj = NSEntityDescription.insertNewObject(
            forEntityName: "UniversityBuilding", into: context)
        obj.setValue(b.0, forKey: "name")
        obj.setValue(b.1, forKey: "type")
        obj.setValue(b.2, forKey: "district")
        obj.setValue(b.3, forKey: "address")
        obj.setValue(b.4, forKey: "latitude")
        obj.setValue(b.5, forKey: "longitude")
        obj.setValue(b.6, forKey: "info")
    }
    try? context.save()
}
```

### Ключевой код — LongPress и фильтрация по району

```swift
// Распознаватель жеста
let longPress = UILongPressGestureRecognizer(
    target: self, action: #selector(handleLongPress(_:)))
mapView.addGestureRecognizer(longPress)

@objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
    guard gesture.state == .began else { return }
    let point = gesture.location(in: mapView)
    let coord = mapView.convert(point, toCoordinateFrom: mapView)
    let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)

    // Определяем район через reverse geocoding
    CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, _ in
        guard let district = placemarks?.first?.subLocality else { return }
        self?.showBuildings(for: district)
    }
}

// Запрос в CoreData
func showBuildings(for district: String) {
    let request = NSFetchRequest<UniversityBuilding>(entityName: "UniversityBuilding")
    request.predicate = NSPredicate(format: "district CONTAINS[cd] %@", district)
    request.sortDescriptors = [NSSortDescriptor(key: "type", ascending: true)]
    let buildings = (try? context.fetch(request)) ?? []

    let vc = BuildingsListViewController(buildings: buildings, district: district)
    navigationController?.pushViewController(vc, animated: true)
}
```

### Ключевой код — прогноз погоды

```swift
// WeatherService.swift
func fetchWeather(latitude: Double, longitude: Double,
                  completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
    let urlString = "https://api.openweathermap.org/data/2.5/weather" +
        "?lat=\(latitude)&lon=\(longitude)" +
        "&appid=\(apiKey)&units=metric&lang=ru"

    URLSession.shared.dataTask(with: URL(string: urlString)!) { data, _, error in
        if let error = error {
            DispatchQueue.main.async { completion(.failure(error)) }
            return
        }
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let main = json["main"] as? [String: Any],
              let temp = main["temp"] as? Double,
              let humidity = main["humidity"] as? Int,
              let wind = (json["wind"] as? [String: Any])?["speed"] as? Double,
              let desc = (json["weather"] as? [[String: Any]])?
                  .first?["description"] as? String
        else { return }

        let response = WeatherResponse(temperature: temp, humidity: humidity,
                                       windSpeed: wind, description: desc)
        DispatchQueue.main.async { completion(.success(response)) }
    }.resume()
}
```

### Скриншоты

```
┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐
│    Карта БГУ    │   │  Ленинский р-н  │   │      ФПМИ       │
│                 │   │                 │   │                 │
│  🔵 🔵    🔴   │   │ Филологический  │   │ [карта]         │
│     🔵          │   │ Юридический     │   │                 │
│  🔵    🔵 🔵   │   │ ФМО             │   │ Адрес:          │
│        🔴       │   │ Химический      │   │ Кальварийская,1 │
│                 │   │ Общежитие №1  🏠│   │                 │
│ 🔵 Факультет   │   │                 │   │ Тип: Факультет  │
│ 🔴 Общежитие   │   │                 │   │ Район: Московский│
│                 │   │                 │   │                 │
│ [удержи для     │   │                 │   │ ⛅ +18°C        │
│  деталей]       │   │                 │   │ Переменная обл. │
└─────────────────┘   └─────────────────┘   └─────────────────┘
  Главная карта         Список по району      Детали + погода
  MapKit + аннотации    CoreData + Predicate  OpenWeatherMap
```

---

## 4. Исправления, внесённые в проект

### 4.1 Info.plist — добавлены ключи геолокации

```xml
<!-- Без этого CoreLocation вызывает краш -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>Приложение использует геолокацию для отображения вашего
положения на карте БГУ.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Приложение использует геолокацию для отображения вашего
положения на карте БГУ.</string>

<!-- Регистрация языков -->
<key>CFBundleLocalizations</key>
<array>
    <string>ru</string>
    <string>en</string>
    <string>pl</string>
</array>

<!-- Разрешение сети для погоды -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key><false/>
</dict>
```

### 4.2 Локализация — добавлены три файла Localizable.strings

Ключи охватывают все экраны: авторизацию, список городов, детальный экран, карту, список зданий, прогноз погоды.

| Ключ | RU | EN | PL |
|------|----|----|-----|
| `auth_title` | Минская область | Minsk Region | Obwód Miński |
| `cities_title` | Города области | Cities of the Region | Miasta obwodu |
| `map_title` | Карта БГУ | BSU Map | Mapa BSU |
| `map_hint` | Удержите для просмотра зданий | Long press to see buildings | Przytrzymaj, aby zobaczyć budynki |
| `weather_error` | Не удалось загрузить погоду | Failed to load weather | Nie udało się załadować pogody |

### 4.3 WeatherService.swift — вынесен в отдельный сервис

Создан `WeatherService.swift` с:
- Единым местом для API-ключа (`kWeatherAPIKey`)
- Проверкой наличия ключа перед запросом
- Полным парсингом ответа (температура, ощущаемая, влажность, ветер, описание)
- Вызовом completion на главном потоке
- Обработкой всех ошибок

---

## 5. Контрольные вопросы и ответы

**1. Что такое CoreLocation?**  
Фреймворк Apple для определения географического местоположения устройства через GPS, Wi-Fi, Bluetooth и сотовую связь. Основные классы: `CLLocationManager`, `CLLocation`, `CLGeocoder`.

**2. Что такое MapKit?**  
Фреймворк для отображения карт в iOS-приложениях. Позволяет добавлять аннотации (`MKAnnotation`), накладки (`MKOverlay`), строить маршруты и взаимодействовать с картой (`MKMapView`).

**3. Как сохранять и читать данные в NSUserDefaults?**  
```swift
// Сохранение
UserDefaults.standard.set(value, forKey: "key")
// Чтение
let value = UserDefaults.standard.string(forKey: "key")
// Удаление
UserDefaults.standard.removeObject(forKey: "key")
```

**4. Что такое .plist файлы и для чего используются?**  
Property List — формат XML для хранения структурированных данных (словари, массивы, строки, числа, даты). Используется для: `Info.plist` (метаданные приложения), конфигурационных файлов, данных приложения (города, настройки).

**5. Как работает сетевое взаимодействие в iOS?**  
Через `URLSession`: создаётся `URLRequest` с URL и параметрами, выполняется `dataTask(with:completionHandler:)`, результат обрабатывается в completion — парсинг JSON через `JSONSerialization` или `Codable`, обновление UI на главном потоке через `DispatchQueue.main.async`.

**6. Какие основные компоненты GUI используются в приложениях iOS?**  
`UIView`, `UILabel`, `UIButton`, `UITextField`, `UIImageView`, `UITableView`, `UICollectionView`, `MKMapView`, `UISegmentedControl`, `UISwitch`, `UINavigationController`, `UITabBarController`.

**7. Как настроить приложение для определения местоположения?**  
В `Info.plist` добавить ключ `NSLocationWhenInUseUsageDescription` с описанием причины. В коде вызвать `locationManager.requestWhenInUseAuthorization()` и реализовать `CLLocationManagerDelegate`.

**8. Что такое CoreData?**  
Фреймворк Apple для объектно-ориентированной работы с персистентным хранилищем (SQLite, XML, In-Memory). Компоненты: `NSManagedObjectModel` (схема), `NSPersistentContainer` (контейнер), `NSManagedObjectContext` (контекст), `NSFetchRequest` (запросы).

**9. Как вставить запись в базу данных CoreData?**  
```swift
let object = NSEntityDescription.insertNewObject(
    forEntityName: "EntityName", into: context)
object.setValue("value", forKey: "attribute")
try? context.save()
```

**10. Как выполнить поиск в базе данных CoreData?**  
```swift
let request = NSFetchRequest<NSManagedObject>(entityName: "EntityName")
request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
let results = (try? context.fetch(request)) ?? []
```

---

## 6. Выводы

В ходе лабораторной работы были изучены и применены следующие технологии разработки iOS-приложений:

**Хранение данных:**
- `NSUserDefaults` — для сохранения учётных данных пользователя и настроек языка
- `.plist` — для хранения структурированных данных о городах Минской области
- `CoreData` — для хранения информации о факультетах и общежитиях БГУ с возможностью фильтрации

**Работа с картами и геолокацией:**
- `MapKit` — отображение интерактивных карт, добавление аннотаций, обработка жестов
- `CoreLocation` — определение текущего местоположения, обратное геокодирование

**Сетевые запросы:**
- `URLSession` — асинхронные HTTP-запросы к OpenWeatherMap API
- `JSONSerialization` — парсинг JSON-ответов

**Локализация:**
- `NSLocalizedString` — многоязычный интерфейс на русском, английском и польском языках
- Динамическое переключение языка через `UserDefaults.standard.set([], forKey: "AppleLanguages")`

**Разработанные приложения:**
- Примеры 1.1–1.7 для изучения основных технологий
- Задание 2.1: «Минская область» с `UICollectionView` и тремя языками
- Задание 2.2: Интерактивная карта факультетов и общежитий БГУ с прогнозом погоды

---

## Ссылки

- Репозиторий: https://github.com/IvanNas-cmd/tpmp-12_8
- Ветки задания: `feature-task2-1`, `feature-task2-2`
- Документация Apple MapKit: https://developer.apple.com/documentation/mapkit
- Документация CoreData: https://developer.apple.com/documentation/coredata
- OpenWeatherMap API: https://openweathermap.org/api
