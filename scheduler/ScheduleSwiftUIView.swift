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
            Image("minzLogo").frame(width: 100, height: 52.3, alignment: .top).aspectRatio(contentMode: .fit).padding(.top, 45)
            
            if let curruser = Auth.auth().currentUser {
                let myUid = curruser.uid
                CalendarView(uid: myUid)
            }
            
            Spacer()
            HStack {
                Spacer()
                Button("Add Course") {
                    presentAlert.toggle()
                }
                .alert("Enter your course ID", isPresented: $presentAlert) {
                    TextField("Enter your course ID", text: $courseID)
                        .foregroundColor(.black)
                    Button("OK", action: submit)
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(5)
                .alignmentGuide(.bottom) { d in d[.bottom] }
            }
            .padding(.bottom, 100)
            .padding(.trailing, 130)
            .padding(.leading, 130)
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
        db.collection("courses").document(courseID).getDocument { (document, error) in
            if let document = document, document.exists {
                var data = document.data()!
                if var courses = data["courses"] as? [String] {
                    courses.append(uid)
                    data["courses"] = courses
                    db.collection("courses").document(courseID).setData(data)
                }
            }
            else {
                let data: [String: Any] = ["courseID": courseID, "courses": [uid]]
                db.collection("courses").document(courseID).setData(data)
            }
        }
        
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
