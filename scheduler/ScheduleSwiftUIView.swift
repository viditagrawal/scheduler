//
//  ScheduleSwiftUIView.swift
//  scheduler
//
//  Created by vidit agrawal on 4/22/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ScheduleSwiftUIView: View {
    @State private var newCourse = ""
    @State private var presentAlert = false
    @State private var courseID = ""
    let allCourses = courseDict.keys
    
    
    var filteredItems: [String]{
        if courseID.isEmpty{
            return Array(allCourses)
        }
        else
        {
            return allCourses.filter { $0.lowercased().hasPrefix(courseID.lowercased()) }
        }
    }
    var searchResults: [String] {
        if courseID.isEmpty {
            return Array(allCourses)
        } else {
            return allCourses.filter { String($0).lowercased().contains(courseID.lowercased()) }
        }
    }
    var body: some View {
        VStack {
            CalendarView()
            
            Spacer()
            HStack {
                Spacer()
                Button("Add Course") {
                    presentAlert.toggle()
                }
                .alert("Enter your course ID", isPresented: $presentAlert) {
                    NavigationStack {
                        List {
                            ForEach(searchResults, id: \.self) { name in
                                NavigationLink {
                                    Text(name)
                                } label: {
                                    Text(name)
                                }
                            }
                        }
                        .navigationTitle("Contacts")
                    }
                    .searchable(text: $courseID)
                    
                    Button("OK", action: submit)
                    
                }
//                List(filteredItems, id: \.self) { item in
//                    Text(item)
//                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                .alignmentGuide(.bottom) { d in d[.bottom] }
                .alignmentGuide(.trailing) { d in d[.trailing] }
            }
            .padding(.bottom, 100)
            .padding(.trailing, 30)
        }
        .edgesIgnoringSafeArea(.all)
    }
    func submit() {
        updateCourses(courseID: courseID, completion: {_ in 
            courseID = ""
        })
    }
}

func updateCourses(courseID: String, completion: @escaping (Error?) -> Void) {
    if let curruser = Auth.auth().currentUser {
        let uid = curruser.uid
        let db = Firestore.firestore()
        let currData = db.collection("data").document(uid)

        currData.getDocument { (document, error) in
            if let error = error {
                completion(error)
            } else if let document = document, document.exists {
                let data = document.data()
                var currcourses = data?["courses"] as? [String] ?? []
                currcourses.append(courseID)

                db.collection("data").document(uid).setData([
                    "perm": data?["perm"] ?? "",
                    "name": data?["name"] ?? "",
                    "email": data?["email"] ?? "",
                    "user": data?["user"] ?? "",
                    "courses": currcourses
                ]) { error in
                    if let error = error {
                        completion(error)
                    } else {
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    } else {
        completion(nil)
    }
}
struct ScheduleSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleSwiftUIView()
    }
}
