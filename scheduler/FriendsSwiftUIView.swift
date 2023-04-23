//
//  FriendsSwiftUIView.swift
//  scheduler
//
//  Created by vidit agrawal on 4/22/23.
//

import SwiftUI
<<<<<<< Updated upstream
=======
import FirebaseAuth

struct DetailView: View {
    var item: String
    
    var body: some View {
        VStack {
            CalendarView(uid: "PeT7yg3UqCRbf3CkjoAJoFv0l8z2")
            Text(item)
                .font(.title)
                .padding()
            Text("This is the detail view for \(item).")
                .padding()
        }
        .navigationTitle(item)
    }
}


//filled with uuid's
//var recommended = []

//friends you are already friends with
//var friends = []
>>>>>>> Stashed changes

struct FriendsSwiftUIView: View {
    var body: some View {
        Text("friends")
    }
}

struct FriendsSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsSwiftUIView()
    }
}
