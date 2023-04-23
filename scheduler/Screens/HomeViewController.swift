//
//  HomeViewController.swift
//  scheduler
//
//  Created by vidit agrawal on 4/22/23.
//

import UIKit
import SwiftUI

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
            
                
    }
    
    func fetchFriends() {
        let url = URL(string: "http://127.0.0.1:5000/friends")!
        let parameters = [
            "first": [
                "uuid": "2E1qWbu3lIbik8WHCxhKrfXvIbk2",
                "courses": [["CMPSC16"]]
            ],
            "second": [
                "5lwGD2WxVBUx4vRJxSO13almscE3": [["CMPSC32", "CMPSC64"]],
                "9tSkoSsBX1Vov0QoHOGxWbvvzAB2": [["PHYS2"]]
            ]
        ]
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching friends: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data returned from friends endpoint")
                return
            }
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] {
                    for item in jsonArray {
                        if let similarity = item["similarity"] as? Double, let friendUUID = item["friend_uuid"] as? String {
                            // Add the friend UUID and similarity to a list to display in your app
                            print("Friend UUID: \(friendUUID), Similarity: \(similarity)")
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                return
            }
        }
        task.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
