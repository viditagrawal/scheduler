//
//  KVKCalendarSettings.swift
//  scheduler
//
//  Created by Collin Qian on 4/22/23.
//

import Foundation
import KVKCalendar
import EventKit
import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol KVKCalendarDataModel {
    
    var events: [Event] { get set }
    var style: Style { get }
    
}

public var updatedEvents = [Event]()

protocol KVKCalendarSettings {}

extension KVKCalendarSettings where Self: KVKCalendarDataModel {
    
    func handleChangingEvent(_ event: Event, start: Date?, end: Date?) -> (range: Range<Int>, events: [Event])? {
        var eventTemp = event
        guard let startTemp = start, let endTemp = end else { return nil }
        
        let startTime = timeFormatter(date: startTemp, format: style.timeSystem.format)
        let endTime = timeFormatter(date: endTemp, format: style.timeSystem.format)
        eventTemp.start = startTemp
        eventTemp.end = endTemp
        eventTemp.title = TextEvent(timeline: "\(startTime) - \(endTime)\n new time",
                                    month: "\(startTime) - \(endTime)\n new time",
                                    list: "\(startTime) - \(endTime)\n new time")
        
        if let idx = events.firstIndex(where: { $0.compare(eventTemp) }) {
           return (idx..<idx + 1, [eventTemp])
        } else {
            return nil
        }
    }
    
    func handleSizeCell(type: CalendarType, stye: Style, view: UIView) -> CGSize? {
        guard type == .month && UIDevice.current.userInterfaceIdiom == .phone else { return nil }
        
        switch style.month.scrollDirection {
        case .vertical:
            return CGSize(width: view.bounds.width / 7, height: 70)
        case .horizontal:
            return nil
        @unknown default:
            return nil
        }
    }
    
    func handleNewEvent(_ event: Event, date: Date?) -> Event? {
        var newEvent = event
        
        guard let start = date,
              let end = Calendar.current.date(byAdding: .minute, value: 30, to: start) else { return nil }
        
        let startTime = timeFormatter(date: start, format: style.timeSystem.format)
        let endTime = timeFormatter(date: end, format: style.timeSystem.format)
        newEvent.start = start
        newEvent.end = end
        newEvent.ID = "\(events.count + 1)"
        newEvent.title = TextEvent(timeline: "\(startTime) - \(endTime)\n new time",
                                   month: "\(startTime) - \(endTime)\n new time",
                                   list: "\(startTime) - \(endTime)\n new time")
        return newEvent
    }
    
    func handleEvents(systemEvents: [EKEvent]) -> [Event] {
        // if you want to get a system events, you need to set style.systemCalendars = ["test"]
        let mappedEvents = systemEvents.compactMap { (event) -> Event in
            let startTime = timeFormatter(date: event.startDate, format: style.timeSystem.format)
            let endTime = timeFormatter(date: event.endDate, format: style.timeSystem.format)
            event.title = "\(startTime) - \(endTime)\n\(event.title ?? "")"
            
            return Event(event: event)
        }
        
        return events + mappedEvents
    }
    
    
    
    func loadEvents(dateFormat: String, completion: ([Event]) -> Void) {
        let decoder = JSONDecoder()
        var courses : Set<String> = []
        if let curruser = Auth.auth().currentUser {
            let uid = curruser.uid
//            let uid = "PeT7yg3UqCRbf3CkjoAJoFv0l8z2"
            let db = Firestore.firestore()
            let currData = db.collection("data").document(uid)
            
            //print("currData: \(currData)")
            
            currData.getDocument { (document, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let document = document, document.exists {
                    let data = document.data()
                    //print("Data: \(data)")
                    if let currcourses = data?["courses"] as? [String]{
                        print("courses: \(currcourses)")
                        for i in currcourses{
                            courses.insert(i)
                        }
                        print(courses.count)
                        
                        
                        for i in courses {
                            let timeString = courseDict[i]?.beginTime
                            let daysString = courseDict[i]?.days
                            
                            let trimmedString = daysString!.trimmingCharacters(in: .whitespaces)
                            let daysArray = trimmedString.components(separatedBy: " ")
                            print("timeString: ", timeString)
                            print("daysString: ", daysString)
                            print("daysArray: ", daysArray)
                            
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            
                            let timeTrimmedString = timeString!.trimmingCharacters(in: .whitespaces)
                            let timeComponents = timeTrimmedString.components(separatedBy: ":")

                            let today = Date()
                            let calendar = Calendar.current
                            
                            var dateComponents = calendar.dateComponents([.year, .month, .day], from: today)
                            
                            dateComponents.hour = Int(timeComponents[0])! - 7
                            dateComponents.minute = Int(timeComponents[1])
                            
                            var currTime = calendar.date(from: dateComponents)!
                            
                            var weekComponents = calendar.dateComponents([.weekday], from: today)
                            print("Weekday: \(String(describing: weekComponents.weekday))")
                            
                            var weekday = weekComponents.weekday
                            
                            var timesArray : [Date] = []
                            
                            for i in 0...7 {
                                if daysArray.contains("M") && (weekday!+i) % 7 == 2 {
                                    var currDate = calendar.date(byAdding: .day, value: i, to: currTime)
                                    for i in 0...10 {
                                        var nextWeek = calendar.date(byAdding: .weekOfYear, value: i, to: currDate!)
                                        timesArray.append(nextWeek!)
                                    }
                                }
                                if daysArray.contains("T") && (weekday!+i) % 7 == 3 {
                                    var currDate = calendar.date(byAdding: .day, value: i, to: currTime)
                                    var nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: currDate!)
                                    for i in 0...10 {
                                        var nextWeek = calendar.date(byAdding: .weekOfYear, value: i, to: currDate!)
                                        timesArray.append(nextWeek!)
                                    }
                                }
                                if daysArray.contains("W") && (weekday!+i) % 7 == 4 {
                                    var currDate = calendar.date(byAdding: .day, value: i, to: currTime)
                                    var nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: currDate!)
                                    for i in 0...10 {
                                        var nextWeek = calendar.date(byAdding: .weekOfYear, value: i, to: currDate!)
                                        timesArray.append(nextWeek!)
                                    }
                                }
                                if daysArray.contains("R") && (weekday!+i) % 7 == 5 {
                                    var currDate = calendar.date(byAdding: .day, value: i, to: currTime)
                                    var nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: currDate!)
                                    for i in 0...10 {
                                        var nextWeek = calendar.date(byAdding: .weekOfYear, value: i, to: currDate!)
                                        timesArray.append(nextWeek!)
                                    }
                                }
                                if daysArray.contains("F") && (weekday!+i) % 7 == 6 {
                                    var currDate = calendar.date(byAdding: .day, value: i, to: currTime)
                                    var nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: currDate!)
                                    for i in 0...10 {
                                        var nextWeek = calendar.date(byAdding: .weekOfYear, value: i, to: currDate!)
                                        timesArray.append(nextWeek!)
                                    }
                                }
                            }
                            
                            print("timesArray: ", timesArray)
                            
                            // Set the day of the week components
                            let weekdays = [Calendar.current.weekdaySymbols, Calendar.current.shortWeekdaySymbols].flatMap({ $0 })
                            let daysIndexes = daysArray.compactMap({ weekdays.firstIndex(of: $0) })
                            dateComponents.weekday = daysIndexes.first
                            
                            // Create the date
                            if let date = calendar.date(from: dateComponents) {
                                let dateString = formatter.string(from: date)
                                print(dateString)
                            }
                
                            
                            for times in timesArray{
                                
                                var dateComponents = DateComponents()
                                dateComponents.minute = 90
                                var endtime = calendar.date(byAdding: dateComponents, to: times)
                                
                                
                                var newEvent = Event(ID: courseDict[i]!.courseID)
                                newEvent.isAllDay = false
                                newEvent.start = times
                                newEvent.end = endtime!
                                newEvent.data = courseDict[i]!.title
                                newEvent.textColor = UIColor(.blue)
                                newEvent.backgroundColor = UIColor(.green)
                                
                                
                                updatedEvents.append(newEvent)
                                
                            }
                            
                        }
                        
                        print("EVENTS: ", updatedEvents)


                        
                        // Load existing JSON data
                        /*
                         guard let url = Bundle.main.url(forResource: "events", withExtension: "json"),
                         let data = try? Data(contentsOf: url),
                         var json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                         else {
                         fatalError("Failed to load or parse JSON data.")
                         }
                         
                         // Create a new event
                         
                         for course in courses {
                         let newEvent: [String: Any] = [
                         "all_day": 0,
                         "border_color": "#333333",
                         "color": "#ffa500",
                         "end": "2023-05-01T18:00:00+01:00",
                         "id": "1402",
                         "start": "2023-05-01T12:00:00+01:00",
                         "text_color": "#000000",
                         "title": "New Event",
                         "files": []
                         ]
                         
                         // Add the new event to the existing data
                         var events : [[String: Any]] = []
                         events.append(newEvent)
                         }
                         
                         
                         // Write the updated JSON data to a file
                         do {
                         json["data"] = events
                         let updatedData = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
                         try updatedData.write(to: url)
                         print("JSON data updated successfully.")
                         } catch {
                         print("Failed to write updated JSON data: \(error)")
                         }
                         
                         }*/
                    }
                }

            }
        }
    
        
    
        
        
        guard let path = Bundle.main.path(forResource: "events", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
              let result = try? decoder.decode(ItemData.self, from: data) else { return }
        
            let events = result.data.compactMap({ (item) -> Event in
            let startDate = formatter(date: item.start)
            let endDate = formatter(date: item.end)
            let startTime = timeFormatter(date: startDate, format: dateFormat)
            let endTime = timeFormatter(date: endDate, format: dateFormat)
            
            var event = Event(ID: item.id)
            event.start = startDate
            event.end = endDate
            event.color = Event.Color(item.color)
            event.isAllDay = item.allDay
            event.isContainsFile = !item.files.isEmpty
            
            if item.allDay {
                event.title = TextEvent(timeline: " \(item.title)",
                                        month: "\(item.title) \(startTime)",
                                        list: item.title)
            } else {
                event.title = TextEvent(timeline: "\(startTime) - \(endTime)\n\(item.title)",
                                        month: "\(item.title) \(startTime)",
                                        list: "\(startTime) - \(endTime) \(item.title)")
            }
            
            if item.id == "14" {
                event.recurringType = .everyMonth
                var customeStyle = style.event
                customeStyle.defaultHeight = 40
                event.style = customeStyle
            } else if item.id == "40" {
                event.recurringType = .everyYear
            } else if item.id == "1400" {
                var customeStyle = style.event
                customeStyle.defaultWidth = 40
                event.style = customeStyle
            }
            return event
        })
        completion(events)
    }
    
}

extension KVKCalendarSettings {
    
    var defaultStringDate: String {
        "14.11.2022"
    }
    
    var defaultDate: Date {
        onlyDateFormatter.date(from: defaultStringDate) ?? Date()
    }
    
    var onlyDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
    
    func handleCustomEventView(event: Event, style: Style, frame: CGRect) -> EventViewGeneral? {
        switch event.ID {
        case "2":
            return CustomViewEvent(style: style, event: event, frame: frame)
        case "1400":
            return BlockViewEvent(style: style, event: event, frame: frame)
        default:
            return nil
        }
    }
    
    func handleOptionMenu(type: CalendarType) -> (menu: UIMenu, customButton: UIButton?)? {
        guard type == .day else { return nil }
        
        let action = UIAction(title: "Delete", attributes: .destructive) { _ in
            print("test tap")
        }
        
        return (UIMenu(title: "Options", children: [action]), nil)
    }
    
    func handleCell<T>(parameter: CellParameter,
                       type: CalendarType,
                       view: T,
                       indexPath: IndexPath) -> KVKCalendarCellProtocol? where T: UIScrollView {
        switch type {
        case .year where parameter.date?.kvkMonth == Date().kvkMonth:
            let cell = (view as? UICollectionView)?.kvkDequeueCell(indexPath: indexPath) { (cell: CustomDayCell) in
                cell.imageView.image = UIImage(named: "ic_stub")
            }
            return cell
        case .day, .week, .month:
            guard parameter.date?.kvkDay == Date().kvkDay && parameter.type != .empty else { return nil }
            
            let cell = (view as? UICollectionView)?.kvkDequeueCell(indexPath: indexPath) { (cell: CustomDayCell) in
                cell.imageView.image = UIImage(named: "ic_stub")
            }
            return cell
        default:
            return nil
        }
    }
    
    func createCalendarStyle() -> Style {
        var style = Style()
        style.timeline.isHiddenStubEvent = false
        style.startWeekDay = .sunday
        style.systemCalendars = ["Calendar1", "Calendar2", "Calendar3"]
        style.event.iconFile = UIImage(systemName: "paperclip")
        style.timeline.scrollLineHourMode = .onlyOnInitForDate(defaultDate)
        style.timeline.showLineHourMode = .always
        style.month.autoSelectionDateWhenScrolling = true
        style.timeline.useDefaultCorderHeader = true
        return style
    }
    
    func timeFormatter(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func formatter(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: date) ?? Date()
    }
    
}

final class CustomViewEvent: EventViewGeneral {
    override init(style: Style, event: Event, frame: CGRect) {
        super.init(style: style, event: event, frame: frame)
        
        let imageView = UIImageView(image: UIImage(named: "ic_stub"))
        imageView.frame = CGRect(origin: CGPoint(x: 3, y: 1), size: CGSize(width: frame.width - 6, height: frame.height - 2))
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class BlockViewEvent: EventViewGeneral {
    override init(style: Style, event: Event, frame: CGRect) {
        var updatedStyle = style
        updatedStyle.event.states = []
        super.init(style: updatedStyle, event: event, frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = event.color?.value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
    }
}

struct ItemData: Decodable {
    let data: [Item]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([Item].self, forKey: CodingKeys.data)
    }
}

struct Item: Decodable {
    let id: String, title: String, start: String, end: String
    let color: UIColor, colorText: UIColor
    let files: [String]
    let allDay: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, title, start, end, color, files
        case colorText = "text_color"
        case allDay = "all_day"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: CodingKeys.id)
        title = try container.decode(String.self, forKey: CodingKeys.title)
        start = try container.decode(String.self, forKey: CodingKeys.start)
        end = try container.decode(String.self, forKey: CodingKeys.end)
        allDay = try container.decode(Int.self, forKey: CodingKeys.allDay) != 0
        files = try container.decode([String].self, forKey: CodingKeys.files)
        let strColor = try container.decode(String.self, forKey: CodingKeys.color)
        color = UIColor.hexStringToColor(hex: strColor)
        let strColorText = try container.decode(String.self, forKey: CodingKeys.colorText)
        colorText = UIColor.hexStringToColor(hex: strColorText)
    }
}

extension UIColor {
    
    static func hexStringToColor(hex: String) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return .systemGray
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: 1.0)
    }
    
}

extension UIApplication {
    
    var activeWindow: UIWindow? {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
    
    var statusBarHeight: CGFloat {
        activeWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 24
    }
    
    var windowSize: CGSize {
        windows.last?.bounds.size ?? UIScreen.main.bounds.size
    }
    
    var screenOffset: UIEdgeInsets {
        var oldInsets: UIEdgeInsets {
            let barHeight = UIApplication.shared.statusBarHeight
            return UIEdgeInsets(top: barHeight, left: 0, bottom: 0, right: 0)
        }
        return UIApplication.shared.activeWindow?.rootViewController?.view.safeAreaInsets ?? oldInsets
    }
    
}
