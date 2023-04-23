//
//  FriendRecSwiftUIView.swift
//  scheduler
//
//  Created by Justin Cao on 4/23/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

public struct Friend : Identifiable{
    public var id: UUID = UUID()
    public var uid: String = String()
    public var username:String
    public var similarity:String
}
struct FriendRecSwiftUIView: View {
    @State var global_friends:[Friend] = []

    var body: some View {
        NavigationView {
            ScrollView{
                ForEach(global_friends, id: \.id) {friend in
                    FriendRow(friend: friend ).previewLayout(.sizeThatFits).padding()
                }
            }.navigationBarTitle("Friends")
            Text("hello")
            .onAppear()
            {
            
            hitEndpoint() { friends in
                    DispatchQueue.main.async {
                        global_friends = friends
                    }
                }
                
            }
        }
    }
    func hitEndpoint(completion: @escaping ([Friend]) -> Void) {
        let url = URL(string: "http://127.0.0.1:5000/friends")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let user = Auth.auth().currentUser
        
       
        var friends: [String : [String]] = [:]

        let group = DispatchGroup()

        
        getAllPeopleInCourses(uuid: user!.uid) { people in
            print("All people: \(people)")
            var secondDict = [String: [String]]()
            
            let group = DispatchGroup()
            
            for person in people {
                group.enter()
                getCourses(uuid: person) { courses in
                    for course in courses {
                        if let courseEnrollCode = courseDict[course]?.enrollCode {
                            if secondDict[person] == nil {
                                secondDict[person] = [courseEnrollCode]
                            } else {
                                secondDict[person]!.append(courseEnrollCode)
                            }
                        }
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                // use secondDict here, after all data has been retrieved
                // do something with the people array
                let json: [String: Any] = [
                    "first": [
                        "uuid": user!.uid,
                        "courses": enrollmentCodes
                    ],
                    "second": secondDict
                ]
                print("JSON \(json)")
                request.httpMethod = "POST"
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    request.httpBody = jsonData
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("application/json", forHTTPHeaderField: "Accept")

                } catch {
                    print(error.localizedDescription)
                }

                let session = URLSession.shared
                let task = session.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        print("Invalid response")
                        return
                    }
                    
                    if httpResponse.statusCode != 200 {
                        print("HTTP status code: \(httpResponse.statusCode)")
                        return
                    }
                    
                    if let data = data {
                        do {
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : String]
                            let sortedKeys = Array(result.keys).sorted(by: <)
                            print(sortedKeys)
                            var newArray : [(String, String)] = []
                            for key in sortedKeys
                            {
                                let tuple = (key, result[key]!)
                                newArray.append(tuple)
                            }
                        
                            
                            processResult(result: newArray, completion: {friendsArray in
                                DispatchQueue.main.async {
                                    completion(friendsArray)
                                }
                            })
                        } catch {
                            completion([])
                            print(error.localizedDescription)
                        }
                    }
                }
                completion([])
                task.resume()
            }
        }
    }
}
public var enrollmentCodes: [String] = []
    func getCourses(uuid: String, completion: @escaping ([String]) -> Void) {
                let db = Firestore.firestore()
                let docRef = db.collection("data").document(uuid)
                print("docref \(docRef)")
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        let courses = data?["courses"] as? [String] ?? []
                        print(courses)
                        completion(courses)
                    } else {
                        print("Document does not exist")
                        completion([])
                    }
                }
            }
    func getPeopleInCourses(courseID: String, completion: @escaping ([String]) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("courses").document(courseID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let people = data?["courses"] as? [String] ?? []
                print("people \(people)")
                completion(people)
            } else {
                print("Document does not exist")
                completion([])
            }
        }
    }
    func getAllPeopleInCourses(uuid: String, completion: @escaping ([String]) -> Void) {
        var allPeople = [String]()
        let group = DispatchGroup()
        
        getCourses(uuid: uuid) { (courses) in
            for course in courses {
                enrollmentCodes.append(courseDict[course]!.enrollCode)
                group.enter()
                getPeopleInCourses(courseID: course) { (people) in
                    allPeople.append(contentsOf: people)
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                completion(allPeople)
            }
        }
    }
    

func processResult(result: [(String, String)], completion: @escaping ([Friend]) -> Void) {
        do {
        var friends: [Friend] = []
        let group = DispatchGroup()
        
        for (similarity, uid) in result {
            group.enter()
            getUsername(for: uid) { username in
                let friend = Friend(uid: uid, username: username, similarity: similarity)
                friends.append(friend)
                print("GLOBAL FRIENDS \(friends)")
                completion(friends)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(friends)
        }
    }
}
    func getUsername(for uid: String, completion: @escaping (String) -> Void) {
            let db = Firestore.firestore()
            let userRef = db.collection("data").document(uid)

            userRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
                completion("")
            } else if let document = document, document.exists {
                let username = document.get("user") as? String
                completion(username!)
            } else {
                print("Document does not exist")
                completion("")
            }
        }
    }


struct FriendRecSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRecSwiftUIView()
    }
}

struct FriendRow: View {
    var friend:Friend
    var body: some View {
        NavigationLink(destination: Text(friend.username)){
            HStack{
                VStack(alignment: .leading, spacing: 10){
                    VStack (alignment: .leading){
                        Text(friend.username)
                            .foregroundColor(.primary)
                    }
                    HStack{
                        Button(action: {
                            let db = Firestore.firestore()
                            let uid = Auth.auth().currentUser!.uid
                            let docRef = db.collection("data").document(uid)

                            docRef.updateData([
                                "friends": FieldValue.arrayUnion([friend.uid])
                            ]) { error in
                                if let error = error {
                                    print("Error adding friend: \(error.localizedDescription)")
                                } else {
                                    print("Friend added successfully")
                                }
                            }
                            print("add Friend")
                        }) {
                            ZStack{
                                RoundedRectangle(cornerRadius: 5).frame(height: 35).foregroundColor(.blue)
                                Text("Add friend").font(.system(size:13)).foregroundColor(.white)
                            }
                            
                        }
                        Button(action: {
                            let db = Firestore.firestore()
                            let uid = Auth.auth().currentUser!.uid
                            let docRef = db.collection("data").document(uid)

                            docRef.updateData([
                                "friends": FieldValue.arrayRemove([friend.uid])
                            ]) { error in
                                if let error = error {
                                    print("Error removing friend: \(error.localizedDescription)")
                                } else {
                                    print("Friend removing successfully")
                                }
                            }
                            print("Remove")
                        }) {
                            ZStack{
                                RoundedRectangle(cornerRadius: 5).frame(height: 35).foregroundColor(.gray)
                                Text("Remove").font(.system(size:13)).foregroundColor(.white)
                            }
                        }
                        Text(friend.similarity)
                        Spacer(minLength: 150)
                    }
                }
                
            }
        }
    }
}
