//
//  FriendsSwiftUIView.swift
//  scheduler
//
//  Created by vidit agrawal on 4/22/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct DetailView: View {
    var item: String
    
    var body: some View {
        VStack {
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
var friends: [String] = []

func gettingUsers(){
    if let currentUser = Auth.auth().currentUser {
        let userID = currentUser.uid
        print("Current user ID: \(userID)")
    }
    else{
        print("no user is signed in.")
    }
}

struct FriendsSwiftUIView: View {
    @State private var searchText = ""
    @State private var selectedChoice = ""
    let choices = ["student1", "student2", "student3"]
    var filteredItems: [String] {
        if searchText.isEmpty {
            return choices
        } else {
            return choices.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    var body: some View {
        NavigationView {
            VStack{
                TextField("Search", text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                List(filteredItems, id: \.self) { item in
                                NavigationLink(destination: DetailView(item: item)) {
                                    Text(item)
                                }
                        }
                Spacer()
            }.navigationTitle("Search")
        }
    }
}


struct FriendsSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsSwiftUIView()
        
        
        
        
    }
}

