//
//  CalendarViewController.swift
//  scheduler
//
//  Created by Collin Qian on 4/22/23.
//

import Foundation
import UIKit
import KVKCalendar
import EventKit

final class CalendarViewController: UIViewController, KVKCalendarSettings, KVKCalendarDataModel, UIPopoverPresentationControllerDelegate {
    
    var events = [Event]() {
        didSet {
            calendarView.reloadData()
        }
    }
    var selectDate = Date()
    var style: Style {
        createCalendarStyle()
    }
    var eventViewer = EventViewer()
    
    private lazy var todayButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Today", style: .done, target: self, action: #selector(today))
        button.tintColor = .systemRed
        return button
    }()
    
    private lazy var reloadStyle: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadCalendarStyle))
        button.tintColor = .systemRed
        return button
    }()
    
    private lazy var calendarView: KVKCalendarView = {
        var frame = view.frame
        frame.origin.y = 0
        let calendar = KVKCalendarView(frame: frame, date: selectDate, style: style)
        calendar.delegate = self
        calendar.dataSource = self
        return calendar
    }()
    
    private var calendarTypeBtn: UIBarButtonItem {
        if #available(iOS 14.0, *) {
            let btn = UIBarButtonItem(title: calendarView.selectedType.title, menu: createCalendarTypesMenu())
            btn.style = .done
            btn.tintColor = .systemRed
            return btn
        } else {
            return UIBarButtonItem()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        selectDate = defaultDate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "KVKCalendar"
        view.backgroundColor = .systemBackground
        view.addSubview(calendarView)
        setupBarButtons()
        
        loadEvents(dateFormat: style.timeSystem.format) { (events) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.events = events
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var frame = view.frame
        frame.origin.y = 0
        calendarView.reloadFrame(frame)
    }
    
    @objc private func reloadCalendarStyle() {
        var updatedStyle = calendarView.style
        updatedStyle.timeSystem = calendarView.style.timeSystem == .twentyFour ? .twelve : .twentyFour
        calendarView.updateStyle(updatedStyle)
        calendarView.reloadData()
    }
    
    @objc private func today() {
        selectDate = Date()
        calendarView.scrollTo(selectDate, animated: true)
        calendarView.reloadData()
    }
    
    private func setupBarButtons() {
        navigationItem.leftBarButtonItems = [calendarTypeBtn, todayButton]
        navigationItem.rightBarButtonItems = [reloadStyle]
    }
    
    @available(iOS 14.0, *)
    private func createCalendarTypesMenu() -> UIMenu {
        let actions: [UIMenuElement] = KVKCalendar.CalendarType.allCases.compactMap { (item) in
            UIAction(title: item.title, state: item == calendarView.selectedType ? .on : .off) { [weak self] (_) in
                guard let self = self else { return }
                self.calendarView.set(type: item, date: self.selectDate)
                self.calendarView.reloadData()
                self.setupBarButtons()
            }
        }
        return UIMenu(children: actions)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // to track changing windows and theme of device
        
        loadEvents(dateFormat: style.timeSystem.format) { [weak self] (events) in
            if let style = self?.style {
                self?.calendarView.updateStyle(style)
            }
            self?.events = events
        }
    }
    
}

// MARK: - Calendar delegate

extension CalendarViewController: CalendarDelegate {
    func didChangeEvent(_ event: Event, start: Date?, end: Date?) {
        if let result = handleChangingEvent(event, start: start, end: end) {
            events.replaceSubrange(result.range, with: result.events)
        }
    }
    
    func didSelectDates(_ dates: [Date], type: CalendarType, frame: CGRect?) {
        selectDate = dates.first ?? Date()
        calendarView.reloadData()
    }
    
    func didSelectEvent(_ event: Event, type: CalendarType, frame: CGRect?) {
        print(type, event)
        switch type {
        case .day:
            eventViewer.text = event.title.timeline
        default:
            break
        }
    }
    
    func didDeselectEvent(_ event: Event, animated: Bool) {
        print(event)
    }
    
    func didSelectMore(_ date: Date, frame: CGRect?) {
        print(date)
    }
    
    func didChangeViewerFrame(_ frame: CGRect) {
        eventViewer.reloadFrame(frame: frame)
    }
    
    func didAddNewEvent(_ event: Event, _ date: Date?) {
        if let newEvent = handleNewEvent(event, date: date) {
            events.append(newEvent)
        }
    }
    
    func createEvents(completion: ([Event]) -> Void) {
        let models = updatedEvents// Get events from storage / API
        
        let events = models.compactMap({ (item) in
            var event = Event(ID: item.ID)
            event.start = item.start // start date event
            event.end = item.end // end date event
            event.color = item.color
            event.isAllDay = false
            event.recurringType = .everyWeek// recurring event type - .everyDay, .everyWeek
        
            // Add text event (title, info, location, time)
            
            return event
            
        })
        completion(updatedEvents)
    }
}

// MARK: - Calendar datasource

extension CalendarViewController: CalendarDataSource {
    
    func willSelectDate(_ date: Date, type: CalendarType) {
        print(date, type)
    }
    
    @available(iOS 14.0, *)
    func willDisplayEventOptionMenu(_ event: Event, type: CalendarType) -> (menu: UIMenu, customButton: UIButton?)? {
        handleOptionMenu(type: type)
    }
    
    func eventsForCalendar(systemEvents: [EKEvent]) -> [Event] {
        // if you want to get a system events, you need to set style.systemCalendars = ["test"]
        handleEvents(systemEvents: systemEvents)
    }
    
    func willDisplayEventView(_ event: Event, frame: CGRect, date: Date?) -> EventViewGeneral? {
        handleCustomEventView(event: event, style: style, frame: frame)
    }
    
    func dequeueCell<T>(parameter: CellParameter, type: CalendarType, view: T, indexPath: IndexPath) -> KVKCalendarCellProtocol? where T: UIScrollView {
        handleCell(parameter: parameter, type: type, view: view, indexPath: indexPath)
    }
    
    func willDisplayEventViewer(date: Date, frame: CGRect) -> UIView? {
        eventViewer.frame = frame
        return eventViewer
    }
    
    func sizeForCell(_ date: Date?, type: CalendarType) -> CGSize? {
        handleSizeCell(type: type, stye: calendarView.style, view: view)
    }
}
