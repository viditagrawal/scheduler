//
//  ScheduleSwiftUIView.swift
//  scheduler
//
//  Created by vidit agrawal on 4/22/23.
//

import SwiftUI

struct ScheduleSwiftUIView: View {
    @State private var newCourse = ""
    @State private var presentAlert = false
    var body: some View {
        Button("Add")
        {
            
        }.alert("Title", isPresented: $presentAlert, actions: {
            TextField("TextField", text: .constant("Value"))
        })
    }
}

struct ScheduleSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleSwiftUIView()
    }
}
