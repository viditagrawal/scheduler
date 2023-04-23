//
//  CalendarViewModel.swift
//  scheduler
//
//  Created by Collin Qian on 4/22/23.
//

import Foundation
import KVKCalendar

final class CalendarViewModel: ObservableObject, KVKCalendarSettings, KVKCalendarDataModel {
    
    // 🤔👹🍻😬🥸
    // only for example
    var events: [Event] = []
    
    var style: KVKCalendar.Style {
        createCalendarStyle()
    }
    
    func loadEvents(completion: @escaping ([Event]) -> Void) {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) {
            self.loadEvents(dateFormat: self.style.timeSystem.format, completion: completion)
        }
    }
    
    func addNewEvent() -> Event? {
         handleNewEvent(Event(ID: "-1"), date: Date())
    }
    
}
