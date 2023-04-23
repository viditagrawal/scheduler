//
//  HomeViewController.swift
//  scheduler
//
//  Created by vidit agrawal on 4/22/23.
//

import UIKit
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class HomeViewController: UIViewController {
    @IBOutlet weak var theContainer : UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
            let scheduleView = UINavigationController(rootViewController: UIHostingController(rootView: ScheduleSwiftUIView()))
            scheduleView.tabBarItem = UITabBarItem(title: "Schedule", image: nil, selectedImage: nil)
            let courseRecView = UINavigationController(rootViewController: UIHostingController(rootView: CourseRecSwiftUIView()))
            courseRecView.tabBarItem = UITabBarItem(title: "Course Search", image: nil, selectedImage: nil)
            let friendsView = UINavigationController(rootViewController: UIHostingController(rootView: FriendsSwiftUIView()))
            friendsView.tabBarItem = UITabBarItem(title: "Friends", image: nil, selectedImage: nil)
            
            // Create the tab view
            let tabView = UITabBarController()
            tabView.viewControllers = [scheduleView, courseRecView, friendsView]
            
            // Set the tab view as the root view controller
            UIApplication.shared.windows.first?.rootViewController = tabView
            hitEndpoint()
                
    }
        
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
                let people = data?[courseID] as? [String] ?? []
                completion(people)
            } else {
                print("Document does not exist")
                completion([])
            }
        }
    }
    func hitEndpoint()
    {
        let url = URL(string: "http://127.0.0.1:5000")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let user = Auth.auth().currentUser
        
        var friends = [String: [String]]()

        getCourses(uuid: user!.uid) { (courses) in
            for course in courses {
                self.getPeopleInCourses(courseID: course) { (people) in
                    for person in people {
                        if friends[person] == nil {
                            friends[person] = []
                        }
                        friends[person]!.append(course)
                    }
                }
            }
            print("FRIENDS \(friends)") // move print statement inside closure
        }

        getCourses(uuid: user!.uid){ (courses) in
            print("Courses: \(courses)")
            let json: [String: Any] = [
                "first": [
                    "uuid": user!.uid,
                    "courses": courses
                ],
                "second": friends
            ]
            // use json here
            request.httpMethod = "POST"
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch {
                print(error.localizedDescription)
            }
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
    
                if let data = data {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        print(result)
                    } catch {
                        print(error.localizedDescription)
                    }
    
                }
            }
            task.resume()
        }
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


