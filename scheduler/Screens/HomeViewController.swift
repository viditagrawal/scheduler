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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
