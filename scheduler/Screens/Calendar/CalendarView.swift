//
//  CalendarView.swift
//  scheduler
//
//  Created by Collin Qian on 4/22/23.
//

import Foundation
import SwiftUI
import KVKCalendar
import FirebaseAuth
import FirebaseFirestore

@available(iOS 14.0, *)
struct CalendarView: View {
    //@State var style : Style = Style()
    @State private var typeCalendar = CalendarType.day
    @State private var events: [Event] = []
    @State private var updatedDate: Date?
    @State private var orientation: UIInterfaceOrientation = .unknown
    @ObservedObject private var viewModel = CalendarViewModel()
    
    var uid : String
    
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
            //style.week.colorBackgroundCurrentDate = .green
            //sleep(5)
            myUID = uid
            viewModel.loadEvents { (items) in
                print("Items: ", items)
                print("updatedEvents: ", updatedEvents)
                events = updatedEvents
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
                                            color: .green,
                                            showDropDownIcon: true)
                    
                    Button {
                        updatedDate = Date()
                    } label: {
                        Text("Today")
<<<<<<< Updated upstream
                            .font(.headline)
                            .foregroundColor(.blue)
=======
                            .font(Font.custom("GT-Walsheim-Pro-Trial-Medium", size: 18))
                            .foregroundColor(.green)
>>>>>>> Stashed changes
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if let event = viewModel.addNewEvent() {
                        events.append(event)
                        
                        viewModel.loadEvents { (items) in
                            print("Items: ", items)
                            print("updatedEvents: ", updatedEvents)
                            events = updatedEvents
                        }
                        
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.green)
                }
                
            }
            
        }
    }
    
}

@available(iOS 14.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if let curruser = Auth.auth().currentUser {
            let myUid = curruser.uid
            CalendarView(uid: myUid)
        }
    }
}
