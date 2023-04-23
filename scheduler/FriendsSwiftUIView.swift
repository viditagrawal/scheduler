//
//  FriendsSwiftUIView.swift
//  scheduler
//
//  Created by vidit agrawal on 4/22/23.
//

import SwiftUI
import FirebaseAuth

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
//var friends = []

struct FriendsSwiftUIView: View {
    @State private var searchText = ""
    @State private var selectedChoice = ""
    let choices = ["friend1", "friend2", "friend3", "friend4"]
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

