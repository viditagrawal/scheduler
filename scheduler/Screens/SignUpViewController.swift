//
//  SignUpViewController.swift
//  scheduler
//
//  Created by vidit agrawal on 4/21/23.
//

import UIKit
import SwiftUI
class SignUpViewController: UIViewController {
    @IBOutlet weak var theContainer : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let childView = UIHostingController(rootView: SignUpSwiftUIView())
        addChild(childView)
        childView.view.frame = theContainer.bounds
        theContainer.addSubview(childView.view)
        // Do any additional setup after loading the view.
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
