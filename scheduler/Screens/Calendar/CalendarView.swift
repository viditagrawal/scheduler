//
//  CalendarView.swift
//  scheduler
//
//  Created by Collin Qian on 4/22/23.
//

import Foundation
import SwiftUI
import KVKCalendar

@available(iOS 14.0, *)
struct CalendarView: View {
    
    @State private var typeCalendar = CalendarType.day
    @State private var events: [Event] = []
    @State private var updatedDate: Date?
    @State private var orientation: UIInterfaceOrientation = .unknown
    @ObservedObject private var viewModel = CalendarViewModel()
    
    var body: some View {
        kvkHandleNavigationView(calendarView)
    }
    
    private var calendarView: some View {
        CalendarViewDisplayable(events: $events,
                                type: $typeCalendar,
                                updatedDate: $updatedDate,
                                orientation: $orientation)
        .kvkOnRotate(action: { (newOrientation) in
            orientation = newOrientation
        })
        .onAppear {
            viewModel.loadEvents { (items) in
                print("Items: ", items)
                sleep(10)
                print("updatedEvents: ", updatedEvents)
                events = items
            }
        }
        .navigationBarTitle("KVKCalendar", displayMode: .inline)
        .edgesIgnoringSafeArea(.bottom)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    ItemsMenu<CalendarType>(type: $typeCalendar,
                                            items: CalendarType.allCases,
                                            showCheckmark: true,
                                            showDropDownIcon: true)
                    
                    Button {
                        updatedDate = Date()
                    } label: {
                        Text("Today")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if let event = viewModel.addNewEvent() {
                        events.append(event)
                        //calendarView.reload
                        //calendarView.loadEvents(completion: completion)
                    }
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.red)
                }
                
            }
        }
    }
    
}

@available(iOS 14.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
