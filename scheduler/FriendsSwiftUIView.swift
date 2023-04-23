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
            
            CalendarView(uid: item)
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

func gettingUsers(completion: @escaping ([String]?, Error?) -> Void) {
    if let currentUser = Auth.auth().currentUser {
        let userID = currentUser.uid
        print("Current user ID: \(userID)")
        let db = Firestore.firestore()
        let docref = db.collection("data").document(userID)
        docref.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let friendUIDs = data?["friends"] as? [String] {
                    var friends: [String] = []
                    let group = DispatchGroup()
                    for uid in friendUIDs {
                        group.enter()
                        let friendRef = db.collection("data").document(uid)
                        friendRef.getDocument { (friendDocument, friendError) in
                            if let friendDocument = friendDocument, friendDocument.exists {
                                let friendData = friendDocument.data()
                                if let username = friendData?["user"] as? String {
                                    friends.append(username)
                                    print("friends\(friends)")
                                }
                            }
                            group.leave()
                        }
                    }
                    group.notify(queue: .main) {
                        completion(friends, nil)
                    }
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, error)
            }
        }
    } else {
        let error = NSError(domain: "com.example.app", code: 401, userInfo: [NSLocalizedDescriptionKey: "No user is signed in."])
        completion(nil, error)
    }
}

struct FriendsSwiftUIView: View {
    @State private var searchText = ""
    @State private var selectedChoice = ""
    @State private var friends = [String]()

    var filteredItems: [String] {
            if searchText.isEmpty {
                return friends
            } else {
                return friends.filter { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
    var body: some View {
            NavigationView {
                VStack {
                    TextField("Search", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    List(filteredItems, id: \.self) { item in
                        NavigationLink(destination: DetailView(item: item)) {
                            Text(item)
                        }
                    }
                    
                    Spacer()
                }
                .navigationTitle("Search")
            }
            .onAppear {
                gettingUsers { (friends, error) in
                    if let error = error {
                        print("Error retrieving user document: \(error.localizedDescription)")
                    } else if let friends = friends {
                        self.friends = friends
                    } else {
                        print("User has no friends.")
                    }
                }
            }
        }
}


struct FriendsSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsSwiftUIView()
        
        
        
        
    }
}

